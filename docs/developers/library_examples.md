# Library Examples

This section provides examples demonstrating how to use various C/C++ libraries provided by iRODS.

You can find more information about the libraries presented by visiting the [Doxygen documentation](/doxygen/index.html).

If you'd like to request examples of other libraries and APIs, please create an issue at [https://github.com/irods/irods_docs](https://github.com/irods/irods_docs).

## C API

### Connecting to an iRODS server

Demonstrates how to use `rcConnect`, `clientLogin`, and `rcDisconnect`.

```c++
#include <irods/getRodsEnv.h>
#include <irods/rodsClient.h>
#include <irods/rcConnect.h>

void connecting_to_an_irods_server()
{
    rodsEnv env;

    // Load the client connection information from $HOME/.irods/irods_environment.json.
    // This information will be stored in "env" and used to connect to an iRODS server.
    if (const int ec = getRodsEnv(&env); ec != 0) {
        // Handle error.
        return;
    }

    // This is the safest place to load all client-side API plugins.
    // This step is required for proper interaction with a 4.3.0 server. Forgetting to call this
    // function will result in errors if subsequent API calls depend on client-side plugins.
    load_client_api_plugins();

    rErrMsg_t error;
    RcComm* conn = rcConnect(env.rodsHost,
                             env.rodsPort,
                             env.rodsUserName,
                             env.rodsZone,
                             0,
                             &error);

    if (!conn) {
        // Failed to connect to server.
        // Handle error.
        return;
    }

    // We've successfully connected to an iRODS server.
    // Here's how you authenticate (i.e. log in) with the server.
    if (const int ec = clientLogin(conn); ec != 0) {
        // Failed to authenticate with server.
        // Handle error and disconnect.
        rcDisconnect(conn);
        return;
    }

    //
    // Use the "conn" pointer to execute operations.
    //

    // When done, call rcDisconnect() so that the server knows the client is finished.
    // This lets the server know it is okay to deallocate OS resources.
    rcDisconnect(conn);
}
```

### Iterating over a collection

Demonstrates how to use `rclOpenCollection`, `rclReadCollection` and `rclCloseCollection`.

```cpp
#include <irods/miscUtil.h>

#include <fmt/format.h>

void iterating_over_a_collection(RcComm* conn)
{
    // We need a handle to manage the state between the client and server.
    //
    // The curly braces here are important (in C++) because they instruct the compiler to zero
    // out the memory. This is equivalent to calling the following:
    //
    //    std::memset(&handle, 0, sizeof(CollHandle));
    //
    CollHandle handle{};

    // The collection to iterate over.
    char logical_path[] = "/tempZone/home/alice";

    // "rclOpenCollection" can be instructed to gather additional information for each entry
    // by bitwise-OR'ing one or more bits. See miscUtil.h for the list of available options.
    // In this example, the default information is good enough.
    const int flags = 0;

    // The first thing we need to do is open the collection. This should feel familiar to people
    // who have used POSIX opendir.
    if (const int ec = rclOpenCollection(conn, logical_path, flags, &handle); ec < 0) {
        // Failed to open the collection.
        // Handle error.
        return;
    }

    //
    // Now that the collection is open, we can read entries from it.
    //

    // This will hold information about a single entry in the collection.
    CollEnt entry{}; 

    while (true) {
        // Read a single entry from the collection and fill "entry" with that information.
        // Every call to this function moves the collection iterator forward.
        if (const int ec = rclReadCollection(conn, &handle, &entry); ec < 0) {
            if (ec == CAT_NO_ROWS_FOUND) {
                // We've iterated over all entries in the collection.
                break;
            }

            // Something bad happened while processing the request.
            // Handle error.
            break;
        }

        // "entry" now holds information about the previously read collection entry.
        // Copy the information you need from "entry" for post processing. This is important to
        // remember because as soon as "rclReadCollection" is called, "entry" will be updated with
        // new information about a different object.

        // Let's print the logical path and the checksum for each entry.
        //
        // The CollEnt type contains several other member variables. Take a look at miscUtil.h to see
        // what is available.
        switch (entry.objType) {
            case COLL_OBJ_T:
                // Collections don't support checksums, so we only print the logical path.
                fmt::print("Collection: {}\n", entry.collName);
                break;

            case DATA_OBJ_T:
                fmt::print("Data Object: {}, Checksum: {}\n", entry.dataName, entry.chksum);
                break;

            default:
                fmt::print("Unknown object type.\n");
                break;
        }
    }

    // The "rcl*" collection functions manage memory for us. These functions will free any heap
    // allocated memory for us. Attempting to free any memory returned from "rclReadCollection"
    // will result in a crash.

    rclCloseCollection(&handle);
}
```

### Querying the Catalog using General Queries

Demonstrates how to use `rcGenQuery` to fetch information from the catalog.

```cpp
#include <irods/genQuery.h>

#include <fmt/format.h>

void fetch_resource_information_using_a_general_query(RcComm* conn)
{
    GenQueryInp input{}; // Curly braces are equivalent to using std::memset to clear the object.

    // Fetch the maximum number of rows for a single page.
    // This is specific to iRODS. The maximum page size is unrelated to any specific database setting.
    input.maxRows = MAX_SQL_ROWS;

    // Here's where we specify the columns we want to fetch, along with various options.
    addInxIval(&input.selectInp, COL_R_RESC_ID, ORDER_BY_DESC); // Sort by resource id in descending order.
    addInxIval(&input.selectInp, COL_R_RESC_NAME, 0);           // No special options on this column.

    // We can apply conditions to the query as well.
    // If we wanted to find all resources whose name starts with the letter 'd', we'd do the following.
    addInxVal(&input.sqlCondInp, COL_R_RESC_NAME, "like 'd%'");

    // So, we've set up our query. Now, we need to execute it. To do that, "rcGenQuery" requires that
    // we pass it a pointer. The pointer we give to "rcGenQuery" will point to memory holding the
    // results of our query. Following execution of the query, if nothing goes wrong, we will be able
    // to use the pointer to iterate over the results. More on that later.
    GenQueryOut* output{};

    // We're all set. Execute the query and iterate/print the results!
    while (true) {
        if (const int ec = rcGenQuery(conn, &input, &output); ec != 0) {
            // Break out of the loop if there aren't any results.
            if (ec == CAT_NO_ROWS_FOUND) {
                break;
            }

            // Failed to execute query.
            // Handle error.
            break;
        }

        //
        // At this point, we know "output" contains the information we're interested in.
        // All we have to do is print it.
        //

        // Iterate over each row.
        for (int row = 0; row < output->rowCnt; ++row) {
            fmt::print("row: ");

            // Iterate over each attribute (i.e. this is a column or the result of an aggregate function).
            // Each SqlResult object represents a single column in the resultset. This loop iterates over
            // all the attributes and jumps to the correct index associated to the row being processed.
            for (int attr = 0; attr < output->attriCnt; ++attr) {
                const SqlResult* sql_result = &output->sqlResult[attr];
                const char* value = sql_result->value + (row * sql_result->len);
                fmt::print("[{}] ", value);
            }

            fmt::print("\n");
        }

        // There's no more data, exit the loop.
        if (output->continueInx <= 0) {
            break;
        }

        // To move to the next page of the resultset, copy the continue index contained in the output
        // structure to the continue index of the input structure. Forgetting to do this will result in
        // an infinite loop!
        input.continueInx = output->continueInx;

        // Deallocate resources for this page of the resultset before calling "rcGenQuery" again.
        // This keeps the application from leaking memory.
        clearGenQueryOut(output);
    }

    // Don't forget to clean up and release any resources used by the queries.
    clearGenQueryInp(&input);
    clearGenQueryOut(output);
}
```

### Querying the Catalog using Specific Queries

Demonstrates how to use `rcSpecificQuery` to fetch information from the catalog.

```cpp
#include <irods/specificQuery.h>

#include <fmt/format.h>

void fetch_information_about_a_collection_using_a_specific_query(RcComm* conn)
{
    SpecificQueryInp input{}; // Curly braces are equivalent to using std::memset to clear the object.

    // Specific queries are pre-defined SQL statements stored in the catalog.
    // Administrators are the only iRODS users allowed to register specific queries.
    //
    // Specific queries allow administrators to address the limitations of general queries. For example,
    // general queries can sometimes produce SQL that isn't very performant. For situations such as these,
    // it may be better to write the SQL directly and expose it as a specific query.
    //
    // Now that we understand why a person may choose to use a specific query, let's see how to execute one.
    //
    // To use a specific query, the query must be registered in iRODS.
    // You can view the full listing of specific queries by running the following icommand: iquest --sql ls
    //
    // Here, we'll be running a specific query that fetches the following information about a collection:
    // 1. R_USER_MAIN.user_name
    // 2. R_USER_MAIN.zone_name
    // 3. R_TOKN_MAIN.token_name
    // 4. R_USER_MAIN.user_type_name
    //
    // Keep in mind that the column information is fetched in the order specificed by the specific query.
    char query_alias[] = "ShowCollAcls";
    input.sql = query_alias;

    // The specific query, "ShowCollAcls", accepts one argument (indicated by the use of "?").
    // Arguments for specific queries are denoted by the use of question marks just like with prepared
    // statements in SQL.
    //
    // "ShowCollAcls" expects the absolute path to a collection as shown below.
    char input_arg[] = "/tempZone/home/rods";
    input.args[0] = input_arg;

    // IMPORTANT: Specific queries can accept up to ten arguments!

    // Fetch the maximum number of rows for a single page.
    // This is specific to iRODS. The maximum page size is unrelated to any specific database setting.
    input.maxRows = MAX_SQL_ROWS;

    // So, we've set up our query. Now, we need to execute it. To do that, "rcSpecificQuery" requires that
    // we pass it a pointer. The pointer we give to "rcSpecificQuery" will point to memory holding the results
    // of our query. Following execution of the query, if nothing goes wrong, we will be able to use the
    // pointer to iterate over the results. More on that later.
    GenQueryOut* output{};

    // We're all set. Execute the query and iterate/print the results!
    while (true) {
        if (const int ec = rcSpecificQuery(conn, &input, &output); ec != 0) {
            // Break out of the loop if there aren't any results.
            if (ec == CAT_NO_ROWS_FOUND) {
                break;
            }

            // Failed to execute query.
            // Handle error.
            break;
        }

        //
        // At this point, we know "output" contains the information we're interested in.
        // All we have to do is print it.
        //

        // Iterate over each row.
        for (int row = 0; row < output->rowCnt; ++row) {
            fmt::print("row: ");

            // Iterate over each attribute (i.e. this is a column or the result of an aggregate function).
            // Each SqlResult object represents a single column in the resultset. This loop iterates over
            // all the attributes and jumps to the correct index associated to the row being processed.
            for (int attr = 0; attr < output->attriCnt; ++attr) {
                const SqlResult* sql_result = &output->sqlResult[attr];
                const char* value = sql_result->value + (row * sql_result->len);
                fmt::print("[{}] ", value);
            }

            fmt::print("\n");
        }

        // There's no more data, exit the loop.
        if (output->continueInx <= 0) {
            break;
        }

        // To move to the next page of the resultset, copy the continue index contained in the output
        // structure to the continue index of the input structure. Forgetting to do this will result in
        // an infinite loop!
        input.continueInx = output->continueInx;

        // Deallocate resources for this page of the resultset before calling "rcSpecificQuery" again.
        // This keeps the application from leaking memory.
        clearGenQueryOut(output);
    }

    // Don't forget to clean up and release any resources used by the queries.
    clearKeyVal(&input.condInput);
    clearGenQueryOut(output);
}
```

## C++ API

### client_connection

Available Since: v4.2.9

Demonstrates how to use `irods::client_connection` to connect to an iRODS server.

```c++
#include <irods/rodsClient.h>
#include <irods/client_connection.hpp>

void connecting_to_an_irods_server()
{
    rodsEnv env;
    _getRodsEnv(env);

    // This is the safest place to load all client-side API plugins.
    // This step is required for proper interaction with a 4.3.0 server. Forgetting to call this
    // function will result in errors if subsequent API calls depend on client-side plugins.
    load_client_api_plugins();

    // Creates a connection to an iRODS server based on the user's
    // $HOME/.irods/irods_environment.json file.
    irods::experimental::client_connection conn{env.rodsHost,
                                                env.rodsPort,
                                                env.rodsUserName,
                                                env.rodsZone};

    // Because this is such a common step, the default constructor will do this for you.
    // For example, the following is equivalent to the code above.
    //
    //     irods::experimental::client_connection conn;

    // This class is very similar to the connection pool class. The primary difference is
    // that it handles construction and destruction of a single connection. For this
    // reason, the interfaces are nearly identical.
    //
    // However, this class also offers some tools that aren't available via the connection
    // pool such as taking ownership of an RcComm or proxying as a different user.
    //
    // If you're interested in all the things offered by this class, take a look
    // at the header file and unit tests.

    // Here is an example showing that instances of this class can be implicitly cast to
    // an RcComm. This makes it easy to use with modern iRODS APIs. Be careful though,
    // this will throw an exception if "conn" doesn't contain a valid RcComm.
    RcComm& reference = conn;

    // Here is an example of casting to a pointer.
    // Use this for C APIs.
    auto* pointer = static_cast<RcComm*>(conn);

    // You can also check if the connection manages a connection.
    // This only checks whether the underlying RcComm pointer points to an object.
    if (conn) {
        // Do something with the connection ...
    }
}
```

### connection_pool

Available Since: v4.2.5

Demonstrates how to stand up and use an `irods::connection_pool`.

```c++
#include <irods/rodsClient.h>
#include <irods/connection_pool.hpp>

void init_connection_pool()
{
    rodsEnv env;

    if (getRodsEnv(&env) < 0) {
        // Handle error.
    }

    // This is the safest place to load all client-side API plugins.
    // This step is required for proper interaction with a 4.3.0 server. Forgetting to call this
    // function will result in errors if subsequent API calls depend on client-side plugins.
    //
    // For systems using versions of iRODS older than 4.2.8, use "init_client_api_table".
    load_client_api_plugins();

    const int connection_pool_size = 4;
    const int refresh_time_in_secs = 600;

    // Creates a connection pool that manages four RcComm connections
    // and refreshes each connection every 600 seconds.
    irods::connection_pool pool{connection_pool_size,
                                env.rodsHost,
                                env.rodsPort,
                                env.rodsUserName,
                                env.rodsZone,
                                refresh_time_in_secs};

    // As an alternative to the steps above, you can use the following free
    // function to construct a connection pool. This function simply automates
    // all of the steps preceding this line. The primary difference is that the
    // pool is allocated on the heap and is returned via a shared pointer.
    //
    //     auto pool = irods::make_connection_pool(4);

    // Get a connection from the pool.
    // "conn" is returned to the pool when it goes out of scope.
    // The type returned from the pool is moveable, but it cannot be copied.
    auto conn = pool.get_connection();

    // The object returned from the pool is a proxy for an RcComm and
    // can be implicitly cast to a reference to RcComm.
    RcComm& reference = conn;

    // Here is an example of casting to a pointer.
    // Use this for C APIs.
    auto* pointer = static_cast<RcComm*>(conn);

    // You can also take ownership of connections created by the connection pool.
    // Taking ownership means the connection is no longer managed by the connection pool
    // and you are responsible for cleaning up any resources allocated by the connection.
    // Once the connection is released, the connection pool will create a new connection
    // in its place.
    auto* released_conn = conn.release();

    // Because connections can be released from the pool, it makes sense to provide an
    // operation for checking if the connection proxy still manages a valid connection.
    // Connection objects are now convertible to bool.
    if (conn) {
        // Do something with the connection ...
    }
}
```

### filesystem

Available Since: v4.2.6

Demonstrates how to iterate over collections as well as other functionality.
Because it implements the ISO C++17 Standard Filesystem library, you may use the documentation at [cppreference](https://cppreference.com).

```c++
// If you are writing server-side code and wish to enable the server-side API, you must
// define the following macro before including the library.
//
//    IRODS_FILESYSTEM_ENABLE_SERVER_SIDE_API
//
#include <irods/filesystem.hpp>

struct RcComm;

void iterating_over_collections(RcComm& conn)
{
    // IMPORTANT!!!
    // ~~~~~~~~~~~~
    // Notice that this library exists under the "experimental" namespace.
    // This is important if you're considering using this library. It means that any
    // library under this namespace could change in the future. Changes are likely
    // to only occur based on feedback from the community.
    namespace fs = irods::experimental::filesystem;

    // iRODS Filesystem has two namespaces, client and server.
    // Not all classes and functions require the use of these namespaces.

    try {
        // Here's an example of how to iterate over a collection on the client-side.
        // Notice how the "client" namespace follows the "fs" namespace alias.
        // This is required by some functions and classes to control which implementation
        // should be used. If you wanted to do this on the server-side, you would replace
        // "client" with "server". This does not recurse into subcollections.
        for (auto&& e : fs::client::collection_iterator{conn, "/path/to/collection"}) {
            // Do something with the collection entry.
        }

        // To recursively iterate over a collection and all of its children, use a
        // recursive iterator.
        for (auto&& e : fs::client::recursive_collection_iterator{conn, "/path/to/collection"}) {
            // Do something with the collection entry.
        }

        // These iterators support shallow copying. This means, if you copy an iterator,
        // subsequent operations on the copy, such as iterating to the next entry, will
        // be visible to the original iterator.

        //
        // Let's try something new.
        //
        
        // How about getting the size of a data object.
        auto size = fs::client::data_object_size(conn, "/path/to/data_object");

        // Or checking if an object exists.
        if (fs::client::exists(conn, path)) {
            // Do something with it.
        }
    }
    catch (const fs::filesystem_error& e) {
        // Handle error.
    }
}
```

### iostreams

Available Since: v4.2.6

Demonstrates how to use `dstream` and `default_transport` to read and write data objects.

```c++
// Defines 3 classes:
// - idstream: Input-only stream for reading data objects.
// - odstream: Output-only stream for writing data objects.
// - dstream : Bidirectional stream for reading and writing data objects.
#include <irods/dstream.hpp>

// Defines the default transport mechanism for transporting bytes via the iRODS protocol.
//
// If you are writing server-side code and wish to enable the server-side API, you must
// define the following macro before including the transport library following this comment.
//
//     IRODS_IO_TRANSPORT_ENABLE_SERVER_SIDE_API
//
#include <irods/transport/default_transport.hpp>

#include <array>
#include <string>

struct RcComm;

void write_to_data_object(RcComm& conn)
{
    // IMPORTANT!!!
    // ~~~~~~~~~~~~
    // Notice that this library exists under the "experimental" namespace.
    // This is important if you're considering using this library. It means that any
    // library under this namespace could change in the future. Changes are likely
    // to only occur based on feedback from the community.
    namespace io = irods::experimental::io;

    // Instantiates a new transport object which uses the iRODS protocol to read and
    // write bytes into a data object. Transport objects are designed to be used by IOStreams
    // objects such as dstream. "default_transport" is a wrapper around the iRODS C API for
    // reading and writing data objects.
    //
    // You can add support for more transport protocols by implementing the transport interface.
    io::client::default_transport xport{conn};

    // Here, we are creating a new output stream for writing. If the data object exists, then
    // the existing data object is opened, else a new data object is created.
    // We could have also used "dstream" itself, but then we'd need to pass in openmode flags
    // to instruct iRODS on how to open the data object.
    io::odstream out{xport, "/path/to/data_object"};

    if (!out) {
        // Handle error.
    }

    std::array<char, 4_Mb> buffer{}; // Buffer full of data.

    // This is the fastest way to write data into iRODS via the new stream API.
    // Bytes written this way are stored directly in the buffer as is.
    out.write(buffer.data(), buffer.size());

    // This will also write data into the data object. This is slower than the previous method
    // because stream operators format data.
    out << "Here is some more data ...\n";
}

void read_from_data_object(RcComm& conn)
{
    namespace io = irods::experimental::io;

    // See function above for information about this type.
    io::client::default_transport xport{conn};

    // Here, we are creating a new input stream for reading. 
    io::idstream in{xport, "/path/to/data_object"};

    if (!in) {
        // Handle error.
    }

    std::array<char, 4_Mb> buffer{}; // Buffer to hold data.

    // This is the fastest way to write data into iRODS via the new stream API.
    // Bytes read this way are stored directly in the buffer as is.
    in.read(buffer.data(), buffer.size());

    // Read a single character sequence into "word".
    // This assumes the input stream contains a sequence of printable characters.
    std::string word;
    in >> word;

    std::string line;
    while (std::getline(in, line)) {
        // Read every line of the input stream until eof.
    }
}
```

### key_value_proxy

Available Since: v4.2.8

Demonstrates how to use `irods::key_value_proxy` to manipulate the C data type, `KeyValPair`.

```c++
#include <irods/key_value_proxy.hpp>
#include <irods/dataObjOpen.h>
#include <irods/stringOpr.h>

#include <string>

void manipulating_keyValuePair_t()
{
    // Let's open a replica for writing using the iRODS C API.
    dataObjInp_t input{};
    input.createMode = 0600;
    input.openFlags = O_WRONLY;
    rstrcpy(input.objPath, "/tempZone/home/rods/foo", MAX_NAME_LEN);

    // Now, we need to set the options that target a specific replica.
    // Normally we'd use the "keyValuePair_t" family of functions to add/remove
    // options. Instead, we'll use the "key_value_proxy" class.
    irods::experimental::key_value_proxy kvp{input.condInput};

    // This proxy object does not own the underlying keyValuePair_t. It simply provides
    // a map-like interface to manipulate and inspect it.

    // Let's target a specific replica of this data object.
    // This adds the "REPL_NUM_KW" key to the underlying keyValuePair_t and sets its
    // value to the string "2". The string is copied into the object.
    kvp[REPL_NUM_KW] = "2";

    // This proxy type also supports checking if the kevValuePair_t contains a specific key.
    if (kvp.contains(RESC_NAME_KW)) {
        // Do something ...
    }

    // Extracting a value is easy too.
    const std::string value = kvp.at(RESC_HIER_STR_KW);
}
```

### query

Available Since: v4.2.5

Demonstrates how to use `irods::query` to query the catalog.

```c++
#include <irods/irods_query.hpp>

#include <fmt/format.h>

struct RcComm;

void print_all_resource_names(RcComm& conn)
{
    // Print all resource names known to iRODS.
    for (auto&& row : irods::query<RcComm>{&conn, "select RESC_NAME"}) {
        fmt::print("{}\n", row[0]);
    }
}
```

### query_builder

Available Since: v4.2.7

Demonstrates how to construct query iterators via an `irods::experimental::query_builder`.

```c++
#include <irods/query_builder.hpp>

#include <vector>
#include <string>

struct RcComm;

void make_query(RcComm& conn)
{
    // Construct the builder.
    // Builders can be copied and moved.
    irods::experimental::query_builder builder; 

    // Set the arguments for how the query should be constructed.
    // A reference to the builder object is always returned after setting an argument.
    //
    // Here, we are setting the type of query to construct as well as the zone
    // for which the query applies.
    //
    // The type always defaults to "general".
    builder.type(irods::experimental::query_type::general)
           .zone_hint("other_zone");

    // To construct the query, call build and pass the C type of
    // the connection and the SQL-like query statement.
    //
    // If the query string is empty, an exception will be thrown.
    auto general_query = builder.build<RcComm>(conn, "select COLL_NAME");

    // Use the query object as you normally would.
    for (auto&& row : general_query) {
        // Process results ...
    }

    // We can create more query objects using the same builder.
    // Let's try a specific query!

    // For specific queries, it is important to remember that the argument vector
    // is not copied into the query object. This means the argument vector must live
    // longer than the query object constructed by the builder.
    std::vector<std::string> args{"/other_zone/home/rods"};

    // All that is left is to update the builder options.
    // The zone is already set from a previous call.
    // So just bind the arguments and change the query type.
    auto specific_query = builder.type(irods::experimental::query_type::specific)
                                 .bind_arguments(args)
                                 .build<RcComm>(conn, "ShowCollAcls");

    for (auto&& row : specific_query) {
        // Process results ...
    }

    // Builders can also be reset to their original state by calling clear.
    builder.clear();
}
```

### query_processor

Available Since: v4.2.6

Demonstrates how to use `irods::query_processor` to asynchronously process each row of a query resultset.

```c++
#include <irods/query_processor.hpp>
#include <irods/thread_pool.hpp>

#include <fmt/format.h>

#include <vector>
#include <mutex>

struct RcComm;

void process_all_query_results(RcComm& conn)
{
    // This will hold all data object absolute paths found by the query processor.
    std::vector<std::string> paths;

    // Protects the paths vector from simultaneous updates.
    std::mutex mtx;

    using query_processor = irods::query_processor<RcComm>;

    // This is where we create our query processor. As you can see, we pass it
    // the query string as well as the handler. The handler will process each row
    // (i.e. std::vector<std::string>) asynchronously. This means that it is your
    // responsibility to protect shared data if necessary.
    //
    // In the following example, the handler creates a path from "_row" and stores
    // it in the referenced "paths" container. Notice how a mutex is acquired before
    // adding the path to the container.
    query_processor qproc{"select COLL_NAME, DATA_NAME", [&paths](const auto& _row) {
        std::lock_guard lk{mtx};
        paths.push_back(_row[0] + '/' + _row[1]);
    }};

    irods::thread_pool thread_pool{4}; // Launch a thread pool with four threads.

    // This is how we run the query. Notice how the execute call accepts a thread
    // pool and connection. This allows developers to run queries on different
    // thread pools.
    //
    // The object returned is a handle to a std::future containing error information.
    // By doing this, the execution of the query and handling of its results are done
    // asynchronously, therefore the application is not blocked from doing other work.
    auto errors = qproc.execute(thread_pool, conn);

    // Because the errors are returned via a std::future, calling ".get()" will cause
    // the application to wait until all query results have been processed by the
    // handler provided on construction.
    for (auto&& error : errors.get()) {
        // Handle errors.
    }

    // Print all the results.
    for (auto&& path : paths) {
        fmt::print("path: {}\n", path.c_str());
    }
}
```

### thread_pool

Available Since: v4.2.5

Demonstrates how to spin up an `irods::thread_pool` and dispatch tasks to it.

```c++
#include <irods/thread_pool.hpp>

void schedule_task_on_thread_pool()
{
    // Creates a thread pool with 4 threads.
    // iRODS thread pool will never launch more than "std::thread::hardware_concurrency()" threads.
    irods::thread_pool pool{4};

    // This is one way to schedule a task for execution
    // "irods::thread_pool::defer" schedules the task on the thread pool. If the current thread
    // belongs to the thread pool, then the task is scheduled after the current thread returns and
    // control is returned back to the thread pool. The task is never run inside of the "defer" call.
    irods::thread_pool::defer(pool, [] {
        // Do science later!
    });

    // This is a function object.
    struct scientific_task
    {
        void operator()()
        {
            // Do science!
        }
    };

    scientific_task task;

    // This is just like "defer" except the task is scheduled immediately. The task is never
    // executed inside of the "post" call.
    irods::thread_pool::post(pool, task);

    // This is just like "post" except, if the current thread belongs to the thread pool, then
    // the task is executed directly inside of the call to "dispatch".
    irods::thread_pool::dispatch(pool, [] {
        // Do science!
    });

    // Wait until ALL tasks have completed.
    // If this is not called, then on destruction of the thread pool, all tasks that have not
    // been executed are cancelled. Tasks that are still executing are allowed to finish.
    pool.join();
}
```

### with_durability

Available Since: v4.2.8

Demonstrates how to use the `irods::with_durability` utility function to enable retry logic in a controlled manner.

```c++
#include <irods/with_durability.hpp>
#include <irods/client_connection.hpp>
#include <irods/filesystem.hpp>

#include <fmt/format.h>

void get_collection_status_over_unreliabile_network()
{
    namespace ix = irods::experimental;
    namespace fs = irods::experimental::filesystem;

    // Holds the status of the collection.
    fs::status s;

    // This is where we define our rules for how durable we want a particular set of
    // operations should be. Notice how we've set the number of retries and the delay
    // multiplier. These options are completely optional. The last result will be
    // returned to the call site. All intermediate results will be lost.
    //
    // The most important thing to understand about this function is the function-like
    // object that will be invoked. It is up to the developer to instruct "with_durability"
    // of when the set of operations have succeeded or failed, etc.
    auto exec_result = ix::with_durability(ix::retries{5}, ix::delay_multiplier{2.f}, [&] {
        try {
            ix::client_connection conn;
            s = fs::client::status(conn, "/tempZone/home/rods");
            return ix::execution_result::success;
        }
        catch (const fs::filesystem_error&) {
            return ix::execution_result::failure;
        }

        // Any exception that escapes the function-like object will be caught by the
        // "with_durability" function.
    });

    // Here, we check the result of the operations and decide what should happen next. 
    if (ix::execution_result::success != exec_result) {
        // Handle failure.
    }

    // Print whether the collection exists.
    fmt::print("Status of collection: {}\n", fs::client::exists(s));
}
```
