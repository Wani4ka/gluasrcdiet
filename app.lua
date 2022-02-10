local diet = require 'diet'
local llex = require 'llex'
local gmatch = string.gmatch

local patternEscape = {
	['('] = '%(',
	[')'] = '%)',
	['.'] = '%.',
	['%'] = '%%',
	['+'] = '%+',
	['-'] = '%-',
	['*'] = '%*',
	['?'] = '%?',
	['['] = '%[',
	[']'] = '%]',
	['^'] = '%^',
	['$'] = '%$',
	['\0'] = '%z'
}
local function patternSafe(str)
	return str:gsub('.', patternEscape)
end

local arg = {...}
local filesList = {}
local outputFolder = './'
local prefix = ''
local llexOnly = false

local i = 1
while i <= #arg do
	if arg[i] == '-llex' then
		llexOnly = true
	elseif arg[i] == '-lst' then
		i = i + 1
		local fileName = arg[i]
		local fList = io.open(arg[i], 'r+')
		local filesStr = fList:read('*a')
		fList:close()
		for f in gmatch(filesStr, '%S+') do
			filesList[#filesList + 1] = f
		end
	elseif arg[i] == '-pref' then
		i = i + 1
		prefix = arg[i]
	elseif arg[i] == '-o' then
		i = i + 1
		outputFolder = arg[i] .. '/'
	else filesList[#filesList + 1] = arg[i] end
	i = i + 1
end

local is_realtoken = {          -- significant (grammar) tokens
  TK_KEYWORD = true,
  TK_NAME = true,
  TK_NUMBER = true,
  TK_STRING = true,
  TK_LSTRING = true,
  TK_OP = true,
  TK_EOS = true,
}
local function build_stream(s)
	local stok, sseminfo = llex.lex(s) -- source list (with whitespace elements)
	local tok, seminfo   -- processed list (real elements only)
	  = {}, {}
	for i = 1, #stok do
	  local t = stok[i]
	  if is_realtoken[t] then
		tok[#tok + 1] = t
		seminfo[#seminfo + 1] = sseminfo[i]
	  end
	end--for
	for i = #tok-1, 1, -1 do
		if tok[i] == 'TK_OP' and seminfo[i] == ',' and tok[i+1] == 'TK_OP' and seminfo[i+1] == '}' then
			table.remove(tok, i)
			table.remove(seminfo, i)
		end
	end
	return tok, seminfo
  end  

local function process(str)
	if llexOnly then
		local toklist, seminfolist = build_stream(str)
		local result = ''
		for i = 1, #toklist do
			result = result .. ('%s %s\n'):format(toklist[i], seminfolist[i])
		end
		return result
	else return diet.optimize(str) end
end

for _, f in ipairs(filesList) do
	io.write('processing ' .. f .. ': ')io.flush()
	local fIn = io.open(f, 'r+')
	local content = fIn:read '*a'
	local sz = content:len()
	fIn:close()
	content = process(content)
	sz = content:len() / sz
	local toklist, seminfolist, toklnlist = llex.lex(content)
	local fOut = io.open(outputFolder .. f:gsub('^' .. patternSafe(prefix), ''), 'w')
	fOut:write(content)
	fOut:close()
	io.write(('done (%d%% less)\n'):format((1-sz)*100))
end
