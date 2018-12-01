#!/usr/bin/env lua
local json = require(pcall(require, "cjson") and "cjson" or "dkjson")
local util = require "digestif.util"
local langserver = require "digestif.langserver"

local log, path_join = util.log, util.path_join

util.null = json.null

-- Set the right data directory when installed by luarocks
local rock_path = debug.getinfo(1).source:match(
   "^@(.*/luarocks/rocks/digestif/[^/]*)/bin/digestif$")
if rock_path then
   util.config.data_dir = rock_path .. "/digestif-data/"
end

if not require("digestif.data")("latex") then
   error("Could not find data files at " .. util.config.data_dir)
end

local function write_msg(msg)
   io.write("Content-Length: " .. #msg .. "\r\n\r\n" .. msg)
   io.flush()
end

local function read_msg()
   local headers, msg = {}, nil
   for h in io.lines() do
      if h == "" or h == "\r" then break end
      local k, v = string.match(h, "^([%a%-]+): (.*)")
      if k then headers[k] = v end
   end
   local len = tonumber(headers["Content-Length"])
   if len then msg = io.read(len) end
   return msg, headers
end

local function rpc_send(id, result, error_code)
   write_msg(
      json.encode({
            jsonrpc = "2.0",
            id = id,
            result = not error_code and result,
            error = error_code and {code = error_code, message = result}
   }))
end

local function rpc_receive()
   local msg = read_msg()
   local success, request = pcall(json.decode, msg)
   if not success then
      util.log("Error: " .. request .. "\n")
      rpc_send(json.null, request, -32700)
      return
   end
   return request.id, request.method, request.params
end

local function process_request()
   local clock = os.clock()
   local id, method_name, params = rpc_receive()
   local method = langserver[method_name]
   if not method then
      if not method_name:match("^%$/") then
         util.log("Error: method " .. method_name .. " does not exist\n")
         rpc_send(id, "method " .. method_name .. " does not exist", -32601)
      end
      return
   end
   local success, result = pcall(method, params)
   if not success then
      rpc_send(id, result, 1)
      return
   end
   if id then
      rpc_send(id, result)
   end
   util.log("Request:", method_name, id or '',
            "time: " .. (os.clock() - clock) * 1000 .. "ms")
end

while true do process_request() end
