---------
-- LuaSrcDiet API
----
local equiv = require 'equiv'
local llex = require 'llex'
local lparser = require 'lparser'
local optlex = require 'optlex'
local optparser = require 'optparser'

local concat = table.concat

local _  -- placeholder


local function noop ()
  return
end

local function opts_to_legacy (opts)
  local res = {}
  for key, val in pairs(opts) do
    res['opt-'..key] = val
  end
  return res
end


local M = {}

--- The module's name.
M._NAME = 'luasrcdiet'

--- The module's version number.
M._VERSION = '1.0.0'

--- The module's homepage.
M._HOMEPAGE = 'https://github.com/jirutka/luasrcdiet'

--- All optimizations enabled.
M.ALL_OPTS = {
  binequiv = true,
  comments = true,
  emptylines = true,
  entropy = true,
  eols = true,
  experimental = true,
  locals = true,
  numbers = true,
  srcequiv = true,
  strings = true,
  whitespace = true,
}

--- Optimizes the given Lua source code.
--
-- @tparam string source The Lua source code to optimize.
-- @treturn string Optimized source.
-- @raise if the source is malformed, source equivalence test failed, or some
--   other error occured.
function M.optimize (source)
  assert(source and type(source) == 'string',
         'bad argument #2: expected string, got a '..type(source))

  local legacy_opts = opts_to_legacy(M.ALL_OPTS)

  local toklist, seminfolist, toklnlist = llex.lex(source)
  local xinfo = lparser.parse(toklist, seminfolist, toklnlist)

  optparser.print = noop
  optparser.optimize(legacy_opts, toklist, seminfolist, xinfo)

  local warn = optlex.warn  -- use this as a general warning lookup
  optlex.print = noop
  _, seminfolist = optlex.optimize(legacy_opts, toklist, seminfolist, toklnlist)
  local optim_source = concat(seminfolist)

--   if opts.srcequiv and not opts.experimental then
    -- equiv.init(legacy_opts, llex, warn)
    -- equiv.source(source, optim_source)

    if warn.SRC_EQUIV then
      error('Source equivalence test failed!')
    end
--   end

  return optim_source
end

return M