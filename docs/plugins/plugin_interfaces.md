iRODS 4.0+ represents a major effort to analyze, harden, and package iRODS for sustainability, modularization, security, and testability.  This has led to a fairly significant refactorization of much of the underlying codebase.  The following descriptions are included to help explain the architecture of iRODS.

The core is designed to be as immutable as possible and serve as a bus for handling the internal logic of the business of iRODS (data storage, policy enforcement, etc.).  Seven interfaces are exposed by the core and allow extensibility and separation of functionality into plugins.  A few plugins are included by default in an iRODS distribution to provide a set of base functionality.

The defined plugin interfaces are listed here:

| Plugin Interface               | Status     |  Since   |
| ------------------------------ | ---------- | -------- |
| [Pluggable Microservices](pluggable_microservices.md)    | Complete   |  3.0b2   |
| [Composable Resources](composable_resources.md)          | Complete   |  3.0b3   |
| [Pluggable Authentication](pluggable_authentication.md)  | Complete   |  3.0.1b1 |
| [Pluggable Network](pluggable_network.md)                | Complete   |  3.0.1b1 |
| [Pluggable Database](pluggable_database.md)              | Complete   |  4.0.0b1 |
| [Pluggable RPC API](pluggable_rpc_api.md)                | Complete   |  4.0.0b2 |
| [Pluggable Rule Engine](pluggable_rule_engine.md)        | Complete   |  4.2.0   |

