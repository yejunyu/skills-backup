# Quick Start Guide

## Installation

```bash
# Install go-zero
go get -u github.com/zeromicro/go-zero

# Install goctl (code generation tool)
go install github.com/zeromicro/go-zero/tools/goctl@latest
```

## Create Your First API Service

### 1. Define API Specification

Create `hello.api`:

```go
syntax = "v1"

type HelloRequest {
    Name string `json:"name"`
}

type HelloResponse {
    Message string `json:"message"`
}

service hello-api {
    @handler HelloHandler
    post /hello (HelloRequest) returns (HelloResponse)
}
```

### 2. Generate Code

```bash
goctl api go -api hello.api -dir .
```

This generates:
```
.
├── etc/
│   └── hello-api.yaml        # Configuration
├── internal/
│   ├── config/
│   │   └── config.go         # Config struct
│   ├── handler/
│   │   └── hellohandler.go   # HTTP handler
│   ├── logic/
│   │   └── hellologic.go     # Business logic
│   ├── svc/
│   │   └── servicecontext.go # Service dependencies
│   └── types/
│       └── types.go          # Request/response types
└── hello.go                  # Entry point
```

### 3. Implement Business Logic

Edit `internal/logic/hellologic.go`:

```go
func (l *HelloLogic) Hello(req *types.HelloRequest) (resp *types.HelloResponse, err error) {
    return &types.HelloResponse{
        Message: fmt.Sprintf("Hello, %s!", req.Name),
    }, nil
}
```

### 4. Run the Service

```bash
go run hello.go -f etc/hello-api.yaml
```

### 5. Test the API

```bash
curl -X POST http://localhost:8888/hello \
  -H "Content-Type: application/json" \
  -d '{"name":"World"}'
```

Response:
```json
{
  "message": "Hello, World!"
}
```

## Create Your First RPC Service

### 1. Define Protocol Buffer

Create `greet.proto`:

```protobuf
syntax = "proto3";

package greet;
option go_package = "./greet";

message GreetRequest {
  string name = 1;
}

message GreetResponse {
  string message = 1;
}

service Greeter {
  rpc Greet(GreetRequest) returns(GreetResponse);
}
```

### 2. Generate Code

```bash
goctl rpc protoc greet.proto --go_out=. --go-grpc_out=. --zrpc_out=.
```

### 3. Implement RPC Logic

Edit `internal/logic/greetlogic.go`:

```go
func (l *GreetLogic) Greet(in *greet.GreetRequest) (*greet.GreetResponse, error) {
    return &greet.GreetResponse{
        Message: fmt.Sprintf("Hello, %s!", in.Name),
    }, nil
}
```

### 4. Run the RPC Service

```bash
go run greet.go -f etc/greet.yaml
```

### 5. Test with Client

Create `client/main.go`:

```go
package main

import (
    "context"
    "fmt"
    "log"

    "github.com/zeromicro/go-zero/zrpc"
    "your-module/greet"
)

func main() {
    conn := zrpc.MustNewClient(zrpc.RpcClientConf{
        Endpoints: []string{"127.0.0.1:8080"},
    })

    client := greet.NewGreeterClient(conn.Conn())
    resp, err := client.Greet(context.Background(), &greet.GreetRequest{
        Name: "gRPC",
    })
    if err != nil {
        log.Fatal(err)
    }

    fmt.Println(resp.Message) // Output: Hello, gRPC!
}
```

## Next Steps

- Read [REST API Patterns](../patterns/rest-api-patterns.md) for advanced API development
- Read [RPC Patterns](../patterns/rpc-patterns.md) for microservices communication
- Explore [Database Patterns](../patterns/database-patterns.md) for data persistence
- Learn about [Resilience Patterns](../patterns/resilience-patterns.md) for production stability
