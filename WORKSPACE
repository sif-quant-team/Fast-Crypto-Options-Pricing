workspace(name = "crypto_options")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Bazel Skylib (required by rules_boost)
http_archive(
    name = "bazel_skylib",
    sha256 = "bc283cdfcd526a52c3201279cda4bc298652efa898b10b4db0837dc51652756f",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz",
    ],
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
bazel_skylib_workspace()

# Boost
http_archive(
    name = "com_github_nelhage_rules_boost",
    url = "https://github.com/nelhage/rules_boost/archive/master.tar.gz",
    strip_prefix = "rules_boost-master",
    sha256 = "88a1d650806b50dfdf14e0a5b644e61df0dc2b0d21e195663fb3554a873ccc1b",
)

load("@com_github_nelhage_rules_boost//:boost/boost.bzl", "boost_deps")
boost_deps()

# BoringSSL
http_archive(
    name = "boringssl",
    # Use the same version that rules_boost is using
    sha256 = "1188e29000013ed6517168600fc35a010d58c5d321846d6a6dfee74e4c788b45",
    strip_prefix = "boringssl-7f634429a04abc48e2eb041c81c5235816c96514",
    urls = ["https://github.com/google/boringssl/archive/7f634429a04abc48e2eb041c81c5235816c96514.tar.gz"],
)

# simdjson using new_http_archive with direct build
http_archive(
    name = "simdjson",
    sha256 = "1e8f881cb2c0f626c56cd3665832f1e97b9d4ffc648ad9e1067c134862bba060",
    strip_prefix = "simdjson-3.10.1",
    urls = ["https://github.com/simdjson/simdjson/archive/v3.10.1.tar.gz"],
    build_file_content = """
cc_library(
    name = "simdjson",
    srcs = ["singleheader/simdjson.cpp"],
    hdrs = ["singleheader/simdjson.h"],
    includes = ["singleheader"],
    copts = [
        "-std=c++17",
        "-O3",
        "-DSIMDJSON_DISABLE_DEPRECATED_API",
    ],
    visibility = ["//visibility:public"],
)
    """,
)

# GoogleTest
http_archive(
    name = "googletest",
    sha256 = "7b42b4d6ed48810c5362c265a17faebe90dc2373c885e5216439d37927f02926",
    strip_prefix = "googletest-1.15.2",
    urls = ["https://github.com/google/googletest/archive/v1.15.2.tar.gz"],
)
