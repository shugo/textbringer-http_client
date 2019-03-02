#l frozen_string_literal: true

require "uri"
require "net/http"

define_command(:send_http_request,
               doc: "Send an HTTP request") do
  s = Buffer.current.to_s
  m = %r'(?:(?<method>GET|HEAD|POST|PUT|DELETE|OPTIONS|TRACE|PATCH|PROPFIND|PROPPATCH|MKCOL|COPY|MOVE|LOCK|UNLOCK) *)?(?<uri>https?://\S*)\n(?<header>([^\n]*?:[^\n]*\n)+)?(\n(?<body>.+))?'m.match(s)
  if m.nil?
    raise "No request found"
  end
  uri = URI.parse(m[:uri])
  background do
    Net::HTTP.start(uri.host, uri.port,
                    use_ssl: uri.scheme == "https") do |http|
      header = m[:header]&.scan(/(.*): *(.*)\n/)&.to_h
      req = Net::HTTP.const_get(m[:method].capitalize).new(uri, header)
      res = http.request(req, m[:body])
      foreground do
        buffer = Buffer.find_or_new("*response*", undo_limit: 0,
                                    read_only: true)
        buffer.read_only_edit do
          buffer.clear
          buffer.insert("HTTP/#{res.http_version} #{res.code} #{res.message}\n")
          res.canonical_each do |name, val|
            buffer.insert("#{name}: #{val}\n")
          end
          buffer.insert("\n")
          buffer.insert(res.body)
        end
        buffer.beginning_of_buffer
        switch_to_buffer(buffer)
      end
    end
  end
end
