Accompanying resources for https://www.gee-whiz.de/2018/remote-debugging/

## Setup notes

*This is not a production ready implementation. Here be dragons!*

1. Read and understand the linked blog post
2. Add a proper server and client frp configuration in their default locations
    * The frp client configuration also needs to set `remote_port` to `0` to let the server choose an unused port
    * The frp client configuration needs an `admin_port` to access the server-chosen external port

## Todos

* Implementation in plain groovy
* Use an sshd instead of socat
* Extract socats port exposing functionality in a generic way