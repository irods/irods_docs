#

!!! Note
    All uses of `python` in this page refer to python 3 (sometimes aliased as `python3`).

## Core test suite

The Python `unittest`-based test suite known as the "core" tests is a required verification step in order to release the iRODS server. Verifying the iRODS server before release involves running the core tests in the following configurations for all supported operating systems, and database types and versions:

 - catalog service provider
 - topology on catalog service provider (with and without SSL enabled)
 - topology on catalog service consumer (with and without SSL enabled)

The list of tests can be found here: [https://github.com/irods/irods/blob/main/scripts/core_tests_list.json](https://github.com/irods/irods/blob/main/scripts/core_tests_list.json)

Additionally, there is a set of tests having to do specifically with federated zones which must be passing as well.

### How to run the tests

The [iRODS Testing Environment](#irods-testing-environment) is the primary tool for verifying the iRODS server software. If you do not want to use the iRODS Testing Environment, you must install the iRODS server packages on some host and run the following command **as the iRODS service account user**:
```
python /var/lib/irods/scripts/run_tests.py
```
This serially runs the entire test suite on the local host. The `--run_specific_tests` option enables the user to specify a dot-delimited test name to run. The test file and test class specified must exist in `/var/lib/irods/scripts/irods/test` for this to work.

### How to add tests

The Python tests are maintained in the main iRODS repository. The test files are located in the `scripts/irods/test` directory. The Python test suite is based on the `unittest` test framework. To learn more about this, see the documentation: [https://docs.python.org/3/library/unittest.html#module-unittest](https://docs.python.org/3/library/unittest.html#module-unittest)

!!! Note
    Remember: Every test file, test class, and test case must have a name which begins with the string `test_`. This is required by Python's `unittest` test discovery mechanism.

#### Adding a test

Adding a new test file, test class, or test case is a matter of discretion on the part of the developer. Here are some hints for helping to make the decision:

 1. If you are unable to find an existing file which seems related to the feature or issue being tested, or you wish to keep your tests separated, add a new test file with its own test classes.
 2. If you are able to locate an existing file which seems related to the feature or issue being tested, but your use case requires a specific kind of setup, add a new test class to the existing test file.
 3. If you are able to locate an existing test class which is related to the feature or issue being tested and provides all the setup required by your use case, simply add a new method to the existing test class.
 4. If you are able to locate an existing test case which is precisely related to the feature or issue being tested, modify the existing test case to cover the new functionality.

You will almost always want to add at least a new test case, if not a new test class or even a new test file. Modify an existing test case (option 4) should only happen if you are fixing an existing test which is broken, or requirements changed in such a way that existing test cases must be adjusted.

#### Add new test suites to the test list

If you added a new test file or a new test class to an existing test file, you must add your new test to the `core_tests_list.json` file in the `scripts` directory, making sure to maintain the alphabetical order of the list. It should be referred to by the dot-delimited name used by Python modules. For instance, if your test class is called `test_feature_with_invalid_input` and it exists in the test file `test_feature`, the following line should be added:
```javascript
[
    // ... other tests ...

    "test_feature.test_feature_with_invalid_input",

    // ... other tests ...
]
```
If you added a new test file, make sure every new test class is added as its own line item in the list of tests. Avoid adding individual test cases to this list.

## Unit test suite (Catch2)

The C++ [Catch2](https://github.com/catchorg/Catch2)-based test suite known as the "unit" tests is a required verification step in order to release the iRODS server. These tests involve many unit tests for C and C++ client libraries. There are also a number of tests for the iRODS C APIs, but these are not unit tests, strictly speaking, because they require a running iRODS server and an authenticated iRODS user.

The list of tests can be found here: [https://github.com/irods/irods/blob/main/unit_tests/unit_tests_list.json](https://github.com/irods/irods/blob/main/unit_tests/unit_tests_list.json)

### How to run the tests

The [iRODS Testing Environment](#irods-testing-environment) is the primary tool for verifying the iRODS server software. If you do not want to use the iRODS Testing Environment, you must build the iRODS server packages with the `IRODS_ENABLE_ALL_TESTS` CMake option enabled, install the iRODS server packages on some host, and run the following command **as the iRODS service account user** for each `TEST_NAME` in the list of tests:
```
/var/lib/irods/unit_tests/TEST_NAME
```
The Catch2 tests are built as executable files - one for each test suite - that can only be executed one at a time. Each executable comes with runtime options provided by Catch2.

### How to add tests

There are three parts to every Catch2 test suite: a C++ source file, a CMake target, and an entry in the unit tests list.

#### Add a new test

The unit tests are maintained in the main iRODS repository. The test files are located in the `unit_tests/src` directory.

Adding a new test file or test case is a matter of discretion on the part of the developer. Here are some hints for helping to make the decision:

 1. If you are unable to find an existing file which seems related to the feature or issue being tested, or you wish to keep your tests separated, add a new test file with its own test cases.
 2. If you are able to locate an existing file which seems related to the feature or issue being tested, but your use case requires a specific kind of setup, add a new test case to the existing test file.
 3. If you are able to locate an existing test case which seems related to the feature or issue being tested, add a new section to the existing test case.
 4. If you are able to locate an existing test case which is precisely related to the feature or issue being tested, modify the existing test case to cover the new functionality.

You will almost always want to add at least a new section to an existing test case, if not a new test case or even a new test file. Modifying an existing test case (option 4) should only happen if you are fixing an existing test which is broken, or requirements changed in such a way that existing test cases must be adjusted.

If you add a new test file, place it in the `unit_tests/src` directory with a name beginning with `test_`. For example, if you are testing a new library called `my_cool_library`, the unit test file could be called `test_my_cool_library.cpp`.

See the [Catch2 documentation](https://github.com/catchorg/Catch2) for information on writing Catch2 tests.

#### Add a CMake target

If you add a new test file, a CMake file will need to be added to the `unit_tests/cmake/test_config` directory and the `subdirectory` added to the main `unit_tests` CMakeLists.txt. The CMake file should have a name that begins with `irods_`. It should be named in such a way that it can be connected to the source file with which it is associated. Continuing with the previous example, a CMake file for testing `my_cool_library` should be named `irods_my_cool_library.cmake`.

The CMake file should include the following declarations:

 - `IRODS_TEST_TARGET`: the CMake target name; this should be the same as the name of the CMake file without the `.cmake` suffix
 - `IRODS_TEST_SOURCE_FILES`: the source files to compile; each test should compile `main.cpp` in addition to the associated test's source file
 - `IRODS_TEST_INCLUDE_PATH`: any required include paths
 - `IRODS_TEST_LINK_LIBRARIES`: any libraries that need to be linked

If in doubt, use existing CMake files as reference. The value of `IRODS_TEST_TARGET` will produce an executable which is the executable which should be run in order to run the tests.

#### Add the test suite to the test list

If you added a unit test file, you must add your new test to the `unit_tests_list.json` file in the `unit_tests` directory, making sure to maintain the alphabetical order of the list. It should refer to the `IRODS_TEST_TARGET` CMake variable set in the CMake file for the new test. For instance, if your `IRODS_TEST_TARGET` is called `irods_my_cool_library`, the following line should be added:
```javascript
[
    // ... other tests ...

    "irods_my_cool_library",

    // ... other tests ...
]
```

## iRODS Testing Environment

The iRODS Testing Environment is a Docker Compose-based project written in Python that is used by the Consortium to test the iRODS server and its plugins. The Testing Environment is driven by a series of scripts to run the tests on a number of different platforms with various database backends and other configuration options. This is the primary tool used for day-to-day testing for iRODS developers as well as for verification in releasing the iRODS server. In addition to running tests, the Compose projects can be useful for manually testing things and quickly deploying specific environments for reproducing issues or developing a proof of concept.

This documentation will briefly describe a few useful ways to employ the iRODS Testing Environment. The README in the project's GitHub repository provides extensive details on the purpose and usage of the various scripts: [https://github.com/irods/irods_testing_environment/blob/main/README.md](https://github.com/irods/irods_testing_environment/blob/main/README.md)

Each script available in the project also has help text available with the `--help` option which describes the available options and their purposes.

### Getting started

In order to configure your environment to use the iRODS Testing Environment, using a virtual environment is highly recommended. Here's how to set up a virtual environment and install the required Python packages:
```
python -m venv -p python3 ~/irods_testing_environment
source ~/irods_testing_environment/bin/activate
pip install docker-compose GitPython
```

#### If you cannot install `docker-compose` ...

The iRODS Testing Environment is built on top of the now-defunct Python implementation of Docker Compose called `docker-compose`: [https://github.com/docker/compose/tree/1.29.2](https://github.com/docker/compose/tree/1.29.2) `docker-compose` is being phased out by Docker and you may experience problems installing it via `pip`.

If this happens to you, try doing the following:

Clone the Docker Compose Git repository:
```bash
git clone https://github.com/docker/compose
```

Check out the latest tag which was still using the Python implementation:
```bash
cd compose
git checkout 1.29.2
```

At this point, you can make the modifications needed to fix any problems you may encounter.

Once done, back out and pip install the local directory:
```bash
cd ..
pip install ./compose
```

### How to run core tests: `run_core_tests.py`

`run_core_tests.py` is the main script for running the iRODS "core" test suite (see [Core test suite](#core-test-suite)).

Here is the minimal form for running the test suite for a particular `OS`, `OS_VERSION`, `DATABASE`, and `DATABASE_VERSION`:
```
python run_core_tests.py --project-directory projects/${OS}-${OS_VERSION}/${OS}-${OS_VERSION}-${DATABASE}-${DATABASE_VERSION}
```

This will serially run the entire test suite using the latest release of the iRODS server. This will create a container for the iRODS server configured as the sole catalog service provider, a container for the database where the catalog is stored, and a network so that they can communicate as if it were a distributed environment.

#### Using locally built iRODS packages

The `--irods-package-directory` option allows the user to provide iRODS packages as files on the host machine. This is the standard way for iRODS developers to test modifications to the iRODS server software before it is released:
```
python run_core_tests.py \
    --project-directory projects/${OS}-${OS_VERSION}/${OS}-${OS_VERSION}-${DATABASE}-${DATABASE_VERSION} \
    --irods-package-directory /path/to/directory/containing/irods/package/files
```

#### Using concurrency to reduce test time

The `--concurrent-test-executors` option allows the user to specify how many iRODS zones to deploy and use for splitting up the list of tests to run. Note that this option can quickly increase the number of containers created by the Compose project (2 containers per test executor), so make sure to choose a number appropriate to the host system's capabilities. Here is an example of how to use the option:
```
python run_core_tests.py \
    --project-directory projects/${OS}-${OS_VERSION}/${OS}-${OS_VERSION}-${DATABASE}-${DATABASE_VERSION} \
    --concurrent-test-executors 4
```
This will deploy 4 iRODS zones (4 * (1 catalog service provider + 1 database) = 8 containers) and will run tests from the list of tests by taking them from a queue and concurrently executing on the catalog service providers in each zone.

The test suite takes 8-10 hours to complete when run serially. With 4 concurrent executors on an 8-core host system, the test suite takes about 2 hours to complete.

#### Running specific tests

The `--tests` option allows the user to specify a space-delimited list of specific tests to run. Here is an example of how to use the option:
```
python run_core_tests.py \
    --project-directory projects/${OS}-${OS_VERSION}/${OS}-${OS_VERSION}-${DATABASE}-${DATABASE_VERSION} \
    --tests test_ils test_icp test_ihelp
```
This will deploy a single iRODS zone and execute the following tests in order on the catalog service provider: `test_ils`, `test_icp`, and `test_ihelp`. This can be used in conjunction with the `--concurrent-test-executors` option, but the tests will not be run in a deterministic order as the concurrent executors will take tests from the queue as they complete earlier tests.

### How to run unit tests: `run_unit_tests.py`

`run_unit_tests.py` is the main script for running the iRODS "unit" test suite (see [Unit test suite](#unit-test-suite-catch2)).

Here is the minimal form for running the test suite for a particular `OS`, `OS_VERSION`, `DATABASE`, and `DATABASE_VERSION`:
```
python run_unit_tests.py --project-directory projects/${OS}-${OS_VERSION}/${OS}-${OS_VERSION}-${DATABASE}-${DATABASE_VERSION}
```

This will serially run the unit test suite using the latest release of the iRODS server. This will create a container for the iRODS server configured as the sole catalog service provider, a container for the database where the catalog is stored, and a network so that they can communicate as if it were a distributed environment. A running iRODS server is required because the Catch2 tests are not actually unit tests. Most of the same options available for `run_core_tests.py` are also available for this script.

The longest unit test takes about 2 minutes to complete.

### How to stand up an iRODS zone: `stand_it_up.py`

`stand_it_up.py` simply stands up an iRODS zone as specified. The minimal iRODS zone is a single catalog service provider and the database with which it communicates to maintain the catalog. The default behavior of this script is this: create a container for the iRODS server configured as the sole catalog service provider, a container for the database where the catalog is stored, and a network so that they can communicate as if it were a distributed environment.

Here is the minimal form for creating a minimal iRODS zone using the latest release of the iRODS server for a particular `OS`, `OS_VERSION`, `DATABASE`, and `DATABASE_VERSION`:
```
python stand_it_up.py --project-directory projects/${OS}-${OS_VERSION}/${OS}-${OS_VERSION}-${DATABASE}-${DATABASE_VERSION}
```

#### Adding catalog service consumers

The `--consumer-instance-count` option allows the user to specify how many catalog service consumers to deploy alongside the catalog service provider (of which there can only be one at this time). Here is an example of how to use the option:
```
python run_core_tests.py \
    --project-directory projects/${OS}-${OS_VERSION}/${OS}-${OS_VERSION}-${DATABASE}-${DATABASE_VERSION} \
    --consumer-instance-count 3
```
This will deploy a single iRODS zone with 1 catalog service provider, 1 database instance, and 3 catalog service consumers (a total of 5 containers).
