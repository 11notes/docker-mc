# ╔═════════════════════════════════════════════════════╗
# ║                       SETUP                         ║
# ╚═════════════════════════════════════════════════════╝
# GLOBAL
  ARG APP_UID=1000 \
      APP_GID=1000 \
      BUILD_ROOT=/go/mc \
      BUILD_SRC=minio/mc.git \
      BUILD_BIN=/mc

# :: FOREIGN IMAGES
  FROM 11notes/distroless AS distroless

# ╔═════════════════════════════════════════════════════╗
# ║                       BUILD                         ║
# ╚═════════════════════════════════════════════════════╝
# :: MINIO
  FROM 11notes/go:1.25 AS build
  ARG APP_VERSION \
      APP_VERSION_BUILD \
      BUILD_ROOT \
      BUILD_SRC \
      BUILD_BIN

  RUN set -ex; \
    SEMVER=$(echo ${APP_VERSION} | sed 's|\.|-|g'); \
    eleven git clone ${BUILD_SRC} RELEASE.${SEMVER}T${APP_VERSION_BUILD};

  RUN set -ex; \
    cd ${BUILD_ROOT}; \
    eleven go build ${BUILD_BIN} main.go;

  RUN set -ex; \
    eleven distroless ${BUILD_BIN};

# :: ENTRYPOINT
  FROM 11notes/go:1.25 AS entrypoint
  COPY ./build /
  ARG APP_VERSION \
      APP_VERSION_BUILD

  RUN set -ex; \
    cd /go/entrypoint; \
    eleven go build /entrypoint main.go;

  RUN set -ex; \
    eleven distroless /entrypoint;

# :: FILE SYSTEM
  FROM alpine AS file-system
  ARG APP_ROOT \
      APP_UID \
      APP_GID

  RUN set -ex; \
    mkdir -p /distroless${APP_ROOT}/etc;

# ╔═════════════════════════════════════════════════════╗
# ║                       IMAGE                         ║
# ╚═════════════════════════════════════════════════════╝
# :: HEADER
  FROM scratch

  # :: default arguments
    ARG TARGETPLATFORM \
        TARGETOS \
        TARGETARCH \
        TARGETVARIANT \
        APP_IMAGE \
        APP_NAME \
        APP_VERSION \
        APP_ROOT \
        APP_UID \
        APP_GID \
        APP_NO_CACHE

  # :: default environment
    ENV APP_IMAGE=${APP_IMAGE} \
        APP_NAME=${APP_NAME} \
        APP_VERSION=${APP_VERSION} \
        APP_ROOT=${APP_ROOT}

  # :: app specific environment
    ENV MC_CONFIG_DIR=${APP_ROOT}/etc \
        MC_JSON="true" \
        MC_NO_COLOR="true" \
        MC_ALIAS="minio" \
        MC_MINIO_ROOT_USER="admin"

  # :: multi-stage
    COPY --from=distroless / /
    COPY --from=build /distroless/ /
    COPY --from=entrypoint /distroless/ /
    COPY --from=file-system --chown=${APP_UID}:${APP_GID} /distroless/ /

# :: PERSISTENT DATA
  VOLUME ["${APP_ROOT}/etc"]

# :: EXECUTE
  USER ${APP_UID}:${APP_GID}
  ENTRYPOINT ["/usr/local/bin/entrypoint"]