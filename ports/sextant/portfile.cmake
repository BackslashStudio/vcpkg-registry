vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO BackslashStudio/sextant
    REF "v${VERSION}"
    SHA512 0
    HEAD_REF main
)

# sextant builds GLFW into itself, carrying the macOS patches in its own
# cmake/glfw/ (Cocoa-only; the glfw3 port has neither). Applied here because
# FetchContent runs no PATCH_COMMAND on a local source tree.
file(GLOB GLFW_PATCHES "${SOURCE_PATH}/cmake/glfw/*.patch")
list(SORT GLFW_PATCHES)
vcpkg_from_github(
    OUT_SOURCE_PATH GLFW_SOURCE_PATH
    REPO glfw/glfw
    REF 3.4
    SHA512 39ad7a4521267fbebc35d2ff0c389a56236ead5fa4bdff33db113bd302f70f5f2869ff4e6db1979512e1542813292dff5a482e94dfce231750f0746c301ae9ed
    HEAD_REF master
    PATCHES ${GLFW_PATCHES}
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        freetype SEXTANT_USE_FREETYPE
        png      SEXTANT_USE_LIBPNG
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DSEXTANT_PACKAGE_BUILD=ON
        -DSEXTANT_BUILD_TESTS=OFF
        -DSEXTANT_FETCH_GLFW=ON
        "-DFETCHCONTENT_SOURCE_DIR_GLFW=${GLFW_SOURCE_PATH}"
        -DFETCHCONTENT_FULLY_DISCONNECTED=ON
)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/sextant)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE" "${SOURCE_PATH}/THIRD_PARTY_NOTICES.md")
