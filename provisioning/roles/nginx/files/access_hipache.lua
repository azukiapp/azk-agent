-- Connect to Redis
local redis = require "resty.redis"
local red = redis:new()
red:set_timeout(1000)
local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
    ngx.say("Failed to connect to Redis: ", err)
    return
end

-- Extract only the hostname without the port
local frontend = ngx.re.match(ngx.var.http_host, "^([^:]*)")[1]
-- Extract the domain name without the subdomain
local domain_name = ngx.re.match(frontend, "(\.[^.]+\.[^.]+)$")[1]

-- Redis lookup
red:multi()
red:lrange("frontend:" .. frontend, 0, -1)
red:lrange("frontend:*" .. domain_name, 0, -1)
red:smembers("dead:" .. frontend)
local ans, err = red:exec()
if not ans then
    ngx.say("Lookup failed: ", err)
    return
end

-- Parse the result of the Redis lookup
local backends = ans[1]
if #backends == 0 then
    backends = ans[2]
end
if #backends == 0 then
    ngx.say("Backend not found")
    return
end
local vhost_name = backends[1]
table.remove(backends, 1)
local deads = ans[3]

-- Pickup a random backend (after removing the dead ones)
local indexes = {}
for i, v in ipairs(deads) do
    deads[v] = true
end
for i, v in ipairs(backends) do
    if deads[tostring(i)] == nil then
        table.insert(indexes, i)
    end
end
local index = indexes[math.random(1, #indexes)]
local backend = backends[index]

-- Announce dead backends if there is any
local deads = ngx.shared.deads
for i, v in ipairs(deads:get_keys()) do
    red:publish("dead", deads:get(v))
    deads:delete(v)
end

-- Set the connection pool (to avoid connect/close everytime)
red:set_keepalive(0, 100)

-- Export variables
ngx.var.backend = backend
ngx.var.backends_len = #backends
ngx.var.backend_id = index - 1
ngx.var.frontend = frontend
ngx.var.vhost = vhost_name

