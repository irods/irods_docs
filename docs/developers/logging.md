# Logging in iRODS 4.3+

Logging in 4.3+ has been changed significantly. There is a new logging library that utilizes spdlog and syslog.

The rodsLog and irods::log APIs are called from several places within the iRODS code base. Replacing all calls to these with the new library is going to take some time. In order to help with this transition, the rodsLog implementation has been modified. It will continue to operate as it has in the past, but it will now forward all messages to the new library as well.

!!! IMPORTANT
    This library is meant to be used in server-side code only. The library is tightly coupled to the server and makes use of features such as syslog and shared memory. Attempting to use the library in client-side code is highly discouraged.

## Features

- Uses syslog
- No files to manage or write to
- Output is in JSON format and is easily parseable
- Allows administrators to use common tools for analysis and management
- Clean API

## Build Requirements

To use the library, you'll need to do three things.

- Define the macro, `IRODS_ENABLE_SYSLOG`
    - If this isn't defined, log messages will not be sent to syslog
- Link against `libirods_common.so`
- Link against `libfmt.so`
    - Must be the same externals package used to compile `libirods_common.so`

## Usage

First, you'll need to include the correct header. For example:
```c++
#include "irods/irods_logger.hpp"
```

Because the library is part of the experimental namespace, you'll likely want to use either a namespace alias or type alias to avoid excessive typing. Here is an example demonstrating use of a type alias.
```c++
using log = irods::experimental::log;
```
You can define the type alias anywhere in the cpp file. Defining an alias like the one presented in a header file is highly discouraged.

!!! NOTE
    From this point on, we'll refer to `irods::experimental::log` via the type alias, `log`, we just defined.

Now, let's talk about how to invoke the logger.

Using the line below, we'll explain each component (i.e. `<placeholder>`) making up an invocation to the logger:
```c++
log::<category>::<log_level>(<args> ...);
```

A `<category>` is a tag that identifies a particular logger. All logger properties are keyed off of the category.

A category can be a custom tag or one of the pre-defined tags:

- legacy
- server
- agent_factory
- agent
- delay_server
- resource
- database
- authentication
- api
- microservice
- network
- rule_engine

You'll soon see how to [create your own](#creating-a-new-category).

`<log_level>` must be one of the following:

- trace
- debug
- info
- warn
- error
- critical

`<args>` must be one of the following:

- string literal
- `std::string`
- `std::initializer_list<log::key_value>`
- A container holding one or more `log::key_value`'s
    - The container must support begin/end iterators (e.g. `std::vector<log::key_value>`)
- A format string followed by a list of arguments

## Creating a new Category

You might be asking yourself, why would anyone ever want to do this?

The primary reason for doing this is so that you can pick and choose which log messages appear in the log file. Systems like iRODS are built upon several components and being able to pick and choose which set of log messages appear in the log file can make debugging much easier and faster.

So, how do we create a new category?

There are three steps:

1. Declare a category tag.
2. Specialize the `logger_config` for the new category tag.
3. Use the logger with the category tag.
    
See the example below:

```c++
#include "irods/irods_logger.hpp"

// 1. Declare the custom category tag.
//    This structure does not need to define a body.
//    This tag allows the logger to locate data specific to the new category.
struct my_category;

// 2. Specialize the logger configuration for the new category.
//    This also defines the default configuration for the new category.
namespace irods::experimental
{
    template <>
    class log::logger_config<my_category>
    {
        // This defines the name that will appear in the log under the "log_category" key.
        // The "log_category" key defines where the message originated. Try to use a name
        // that makes it easy for administrators to determine what produced the message.
        static constexpr const char* name = "my_category";

        // This is the current log level for the category. This also represents the initial
        // log level. Use the "set_level()" function to adjust the level.
        static inline log::level level = log::level::info;

        // This is required since the fields above are private.
        // This allows the logger to access and modify the configuration.
        friend class logger<my_category>;
    };
} // namespace irods::experimental

// 3. Use the logger with the new category
void example()
{
    using log = irods::experimental::log;

    // Here is the logger with the new category.
    using logger = log::logger<my_category>; 

    try {
        // This message will be recorded.
        logger::info("Hello, My Category!!!");

        // Increase the log level for the category from "info" to "warn". Now, only messages
        // with a level greater than or equal to "warn" will be recorded. All other messages
        // will be discarded.
        logger::set_level(log::level::warn);

        // This debug message will not be recorded because the log level for the category is
        // set to a higher level (warn > debug).
        logger::debug("This message will not be recorded.");

        // You can also pass in a list of key-value pairs.
        // All keys and values must have a data type of std::string.
        logger::info({{"key_1", "value_1"},
                      {"key_2", "value_2"},
                      {"key_n", "value_n"}});
    }
    catch (const std::exception& e) {
        // This message uses a format string to construct the log message from one or more
        // arguments.
        logger::error("ERROR: {}", e.what());
    }
}
```
