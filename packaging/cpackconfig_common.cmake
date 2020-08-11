cpack_add_component(_cura
                    DISPLAY_NAME "Organ Regenerator"
                    Description "Organ Regenerator Executable and Data Files"
                    REQUIRED
)

# ========================================
# CPack Common Settings
# ========================================
set(CPACK_PACKAGE_NAME "Organ Regenerator")
set(CPACK_PACKAGE_VENDOR "Rokit Healthcare")
set(CPACK_PACKAGE_HOMEPAGE_URL "https://github.com/jungjuseong/RokitCura")

# MSI only supports version format like "x.x.x.x" where x is an integer from 0 to 65534
set(CPACK_PACKAGE_VERSION_MAJOR ${CURA_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${CURA_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${CURA_VERSION_PATCH})

# Use full version x.x.x string in install directory of MSI,
#  so that IT can easily automatically upgrade to a newer patch version
set(CURA_FULL_VERSION "${CURA_VERSION_MAJOR}.${CURA_VERSION_MINOR}")
if(CPACK_GENERATOR MATCHES "WIX")
    set(CURA_FULL_VERSION "${CURA_FULL_VERSION}.${CURA_VERSION_PATCH}")
endif()

set(CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/packaging/rokit.ico")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Organ Regenerator - 3D Bio Printing Software")
set(CPACK_PACKAGE_CONTACT "IRON <jungjuseong@gmail.com>")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/packaging/cura_license.txt")

set(CPACK_CREATE_DESKTOP_LINKS Cura "Organ Regenerator ${CURA_FULL_VERSION}")
set(CPACK_PACKAGE_EXECUTABLES Cura "Organ Regenerator ${CURA_FULL_VERSION}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "Organ Regenerator ${CURA_FULL_VERSION}")
