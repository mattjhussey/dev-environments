ARG UBUNTU_VERSION=20.04
ARG CTEST_CPUS=6
FROM ubuntu:${UBUNTU_VERSION} as base
    # Pull variable inside scope
    ARG CTEST_CPUS

    # Install C++ compiler and tools
    RUN \
        export DEBIAN_FRONTEND=noninteractive && \
        apt update -y && \
        apt install -y cmake build-essential clang-tidy-12 clang-format-12 uuid-dev lcov doxygen graphviz mscgen texlive-latex-extra texlive-font-utils default-jre gcovr ninja-build

    # Set clang tools to use version 12
    RUN \
        update-alternatives --install "/usr/bin/clang-tidy" "clang-tidy" "/bin/clang-tidy-12" 1000 && \
        update-alternatives --install "/usr/bin/clang-format" "clang-format" "/bin/clang-format-12" 1000

    # Set parallel level to 6 (should be per machine but...)
    ENV CTEST_PARALLEL_LEVEL=${CTEST_CPUS}

    CMD ["bash"]

FROM scratch as dev
    # Pull variable inside scope
    ARG CTEST_CPUS

    # Build a clean image
    COPY --from=base / /

    # Set parallel level to 6 (should be per machine but...)
    ENV CTEST_PARALLEL_LEVEL=${CTEST_CPUS}

    CMD ["bash"]

