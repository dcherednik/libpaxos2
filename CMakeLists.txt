CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)
SET(LIBRARY_NAME "paxos2")
SET(TESTS_DIR "tests")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3 -Wall -g -Wshadow -Wextra")
SET(CMAKE_C_ARCHIVE_CREATE "<CMAKE_AR> rc <TARGET> <LINK_FLAGS> <OBJECTS>")
INCLUDE(FindLibevent)

project(lib${LIBRARY_NAME})
include_directories(${libpaxos2_SOURCE_DIR} ${libpaxos2_SOURCE_DIR}/include)

find_package(Libevent REQUIRED)
find_package(Bdb REQUIRED)
find_package (Threads REQUIRED)

include(CheckLibraryExists)
CHECK_LIBRARY_EXISTS(rt clock_gettime "time.h" HAVE_CLOCK_GETTIME)

set(SOURCE_LIB lib/paxos_malloc.c lib/udp_receiver.c lib/udp_sendbuf.c lib/learner.c lib/acceptor_stable_storage.c lib/acceptor.c lib/proposer.c lib/proposer_values_handler.c lib/submit_handle.c)

add_library(${LIBRARY_NAME} SHARED ${SOURCE_LIB})
LINK_DIRECTORIES(${CMAKE_BINARY_DIR})
MESSAGE(${BDB_LIBRARIES})
MESSAGE(${EVENT_LIBRARIES})
MESSAGE(${CMAKE_THREAD_LIBS_INIT})
AUX_SOURCE_DIRECTORY(${libpaxos2_SOURCE_DIR}/${TESTS_DIR} TEST_EXEC_FILES)

foreach( testsourcefile ${TEST_EXEC_FILES})
    string( REPLACE ".c" "" testpath ${testsourcefile} )
    get_filename_component(testname ${testpath} NAME)
    MESSAGE(${testname})
    add_executable(${TESTS_DIR}/${testname}  ${testsourcefile} )
    target_link_libraries( ${TESTS_DIR}/${testname} ${LIBRARY_NAME} ${EVENT_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT} ${BDB_LIBRARIES} )
endforeach( testsourcefile ${TEST_EXEC_FILES})
