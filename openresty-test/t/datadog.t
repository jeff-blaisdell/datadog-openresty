use Test::Nginx::Socket 'no_plan';

no_long_string();
run_tests();

__DATA__

=== It should load DataDog module without crashing.
--- main_config
load_module /usr/local/openresty/nginx/modules/ngx_http_datadog_module.so;
--- config
location = /datadog {
  default_type text/html;
  content_by_lua_block {
    ngx.say("<p>hello, world</p>")
  }
}
--- request
GET /datadog
--- response_body
<p>hello, world</p>
--- error_code: 200
