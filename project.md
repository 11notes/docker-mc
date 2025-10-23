${{ content_synopsis }} This image will run mc [rootless](https://github.com/11notes/RTFM/blob/main/linux/container/image/rootless.md) and [distroless](https://github.com/11notes/RTFM/blob/main/linux/container/image/distroless.md), for maximum security and performance. In addition to being small and secure, it will also automatically create the **minio** alias with the user set via environment variables.

${{ content_uvp }} Good question! Because ...

${{ github:> [!IMPORTANT] }}
${{ github:> }}* ... this image runs [rootless](https://github.com/11notes/RTFM/blob/main/linux/container/image/rootless.md) as 1000:1000
${{ github:> }}* ... this image has no shell since it is [distroless](https://github.com/11notes/RTFM/blob/main/linux/container/image/distroless.md)
${{ github:> }}* ... this image is auto updated to the latest version via CI/CD
${{ github:> }}* ... this image has a health check
${{ github:> }}* ... this image runs read-only
${{ github:> }}* ... this image is automatically scanned for CVEs before and after publishing
${{ github:> }}* ... this image is created via a secure and pinned CI/CD process
${{ github:> }}* ... this image is very small

If you value security, simplicity and optimizations to the extreme, then this image might be for you.

${{ content_comparison }}

${{ title_volumes }}
* **${{ json_root }}/etc** - Directory of mc config

${{ content_compose }}

${{ content_defaults }}
| `alias` | minio | the alias used for all mc interactions |

${{ content_environment }}
| `MC_MINIO_URL` | URL of minio server to connect to |  |
| `MC_MINIO_ROOT_USER` | username of admin account | admin |
| `MC_MINIO_ROOT_PASSWORD` | password of root user |  |
| `MC_MINIO_ROOT_PASSWORD_FILE` | password file of root user for secrets |  |
| `MC_*` | all other available [settings](https://docs.min.io/enterprise/aistor-object-store/reference/cli/aistor-client-settings/) |  |

${{ content_source }}

${{ content_parent }}

${{ content_built }}

${{ content_tips }}

${{ title_caution }}
${{ github:> [!CAUTION] }}
${{ github:> }}* The compose example uses ```MC_INSECURE```. Never do this in production! Use a valid SSL certificate to terminate your minio!