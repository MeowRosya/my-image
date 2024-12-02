## 1. BUILD ARGS
# These allow changing the produced image by passing different build args to adjust
# the source from which your image is built.
# Build args can be provided on the commandline when building locally with:
#   podman build -f Containerfile --build-arg FEDORA_VERSION=40 -t local-image

# SOURCE_IMAGE arg can be anything from ublue upstream which matches your desired version:
# See list here: https://github.com/orgs/ublue-os/packages?repo_name=main
# - "silverblue"
# - "kinoite"
# - "sericea"
# - "onyx"
# - "lazurite"
# - "vauxite"
# - "base"
#
#  "aurora", "bazzite", "bluefin" or "ucore" may also be used but have different suffixes.
ARG SOURCE_IMAGE="base"

## SOURCE_SUFFIX arg should include a hyphen and the appropriate suffix name
# These examples all work for silverblue/kinoite/sericea/onyx/lazurite/vauxite/base
# - "-main"
# - "-nvidia"
# - "-asus"
# - "-asus-nvidia"
# - "-surface"
# - "-surface-nvidia"
#
# aurora, bazzite and bluefin each have unique suffixes. Please check the specific image.
# ucore has the following possible suffixes
# - stable
# - stable-nvidia
# - stable-zfs
# - stable-nvidia-zfs
# - (and the above with testing rather than stable)
ARG SOURCE_SUFFIX="-main"

## SOURCE_TAG arg must be a version built for the specific image: eg, 39, 40, gts, latest
ARG SOURCE_TAG="latest"


### 2. SOURCE IMAGE
## this is a standard Containerfile FROM using the build ARGs above to select the right upstream image
FROM ghcr.io/ublue-os/${SOURCE_IMAGE}${SOURCE_SUFFIX}:${SOURCE_TAG}


### 3. MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

COPY build.sh /tmp/build.sh

RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        vulkan-loader \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        alsa-lib \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        gnutls \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        glib2 \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        nspr \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        nss \
        nss-softokn \
        nss-softokn-freebl \
        nss-sysinit \
        nss-util \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        atk \
        at-spi2-atk \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libaom \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        gstreamer1 \
        gstreamer1-plugins-base \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libdecor \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libtirpc \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libuuid \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libblkid \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libmount \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        cups-libs \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libinput \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libopenmpt \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        llvm-libs \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        zlib-ng-compat \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        fontconfig \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        pciutils-libs \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libdrm \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        cpp \
        libatomic \
        libgcc \
        libgfortran \
        libgomp \
        libobjc \
        libstdc++ \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libX11 \
        libX11-common \
        libX11-xcb \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libv4l \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        elfutils-libelf \
        elfutils-libs \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        glibc \
        glibc-common \
        glibc-all-langpacks \
        glibc-gconv-extra \
        || true && \
    if grep -q "kinoite" <<< "${BASE_IMAGE_NAME}"; then \
        rpm-ostree override replace \
        --experimental \
        --from repo=updates \
            qt6-qtbase \
            qt6-qtbase-common \
            qt6-qtbase-mysql \
            qt6-qtbase-gui \
            || true \
    ; fi && \
    rpm-ostree override remove \
        glibc32 \
        || true && \
    /usr/libexec/containerbuild/cleanup.sh && \
    ostree container commit

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    ostree container commit
## NOTES:
# - /var/lib/alternatives is required to prevent failure with some RPM installs
# - All RUN commands must end with ostree container commit
#   see: https://coreos.github.io/rpm-ostree/container/#using-ostree-container-commit
