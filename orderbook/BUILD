cc_library(
    name = "Orderbook",
    srcs = ["orderbook.cpp"],
    hdrs = [
        "orderbook.h",
        "data.h",
        "OrderbookTypes.h",
    ],
    visibility = ["//visibility:public"],
    copts = ["-std=c++20"],
)

cc_test(
    name = "OrderbookTest",
    srcs = ["OrderbookTest.cpp"],
    deps = [
        ":Orderbook",
        "@googletest//:gtest_main",
    ],
    copts = ["-std=c++20"],
)
