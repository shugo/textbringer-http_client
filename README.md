# textbringer-http_client

HTTP client plugin for [Textbringer](https://github.com/shugo/textbringer).

## Installation

    $ gem install textbringer-http_client

## Usage

Type `M-x send_http_request` to send an HTTP request, for example, in the following buffer:

```
POST http://localhost:4000/graphql
Content-Type: application/json

{
  "query":"query todo{ todo(id: 1) { id content } }",
  "variables":null,
  "operationName":"todo"
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shugo/textbringer-http_client.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
