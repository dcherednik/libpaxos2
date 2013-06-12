 
if (BDB_INCLUDE_DIR AND BDB_LIBRARY)
    # Already in cache, be silent
    set(BDB_FIND_QUIETLY TRUE)
endif (BDB_INCLUDE_DIR AND BDB_LIBRARY)

find_path(BDB_INCLUDE_DIR db.h
    PATHS /usr/include
    PATH_SUFFIXES db
)

find_library(BDB_LIBRARY
   NAMES db
   PATHS /usr/lib /usr/local/lib
)

set(BDB_LIBRARIES ${BDB_LIBRARY} )

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(BDB
    DEFAULT_MSG
    BDB_INCLUDE_DIR
    BDB_LIBRARIES
)

mark_as_advanced(BDB_INCLUDE_DIR BDB_LIBRARY)
