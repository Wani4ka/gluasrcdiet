# gluasrcdiet
a fork of [luasrcdiet](https://github.com/jirutka/luasrcdiet), which supports glua features:
* `continue` keyword
* additional replaces `not` -> `!`, `and` -> `&&`, `or` -> `||`, allowing to remove surrounding whitespaces too
* strip trailing commas before closing curly braces

see `test.bat` for usage

**before**
```lua
GlobalVariable = GlobalVariable or {}
function GlobalFunction()
	print('hello world!')
end
local var = 'test'
local var2 = {
	pos = Vector(0, 0, 0),
	ang = Angle(45, 0, 2),
	data = {
		msg1 = 'example',
		msg2 = 'cozy',
	},
}
local function myFunc(num)
	return num % 1337 == 0
end

hook.Add('Think', 'example', function()
	hook.Remove('Think', 'example')
	local fr = vgui.Create 'DFrame'
	fr:SetTitle(var)
	fr:SetSize(10, 100)
	for i, v in ipairs(fr:GetChildren()) do
		if myFunc(i) then
			break
		end
	end
	local superLongButUseless1, superLongButUseless2, superLongButUseful3 = 0, 0, 0
	for index = 1, 10 do
		if not myFunc(index) or not myFunc(index * 3) or (index > 3 and index < 10) then
			continue
		end
		superLongButUseful3 = superLongButUseful3 + index
	end
end)
```

**after**
```lua
GlobalVariable=GlobalVariable||{}function GlobalFunction()print'hello world!'end
local n='test'local e={pos=Vector(0,0,0),ang=Angle(45,0,2),data={msg1='example',msg2='cozy'}}local function o(e)return e%1337==0
end
hook.Add('Think','example',function()hook.Remove('Think','example')local e=vgui.Create'DFrame'e:SetTitle(n)e:SetSize(10,100)for e,n in ipairs(e:GetChildren())do
if o(e)then
break
end
end
local e,e,n=0,0,0
for e=1,10 do
if!o(e)||!o(e*3)||(e>3&&e<10)then
continue
end
n=n+e
end
end)
```

overall, the code is 36% shorter (807 chars vs. 509), but it'll be much more resultative if you usually indent using spaces, not tabs

also, pay attention to some lines that became really times shorter:
| before | after | comments |
|--------|-------|----------|
| `if not myFunc(i) or not myFunc(i * 3) or (i > 3 and i < 10) then` | `if!o(e)\|\|!o(e*3)\|\|(e>3&&e<10)then` | **(51.6%)** using c-styled logical operators, you will be able not to place any spaces at all, gmod accepts it
| `local superLongButUseless1, superLongButUseless2, superLongButUseful3 = 0, 0, 0` | `local e,e,n=0,0,0` | **(21.5%)** (luasrcdiet feature) renames local variables to as short as possible
| `local var2 = {  pos = Vector(0, 0, 0),  ang = Angle(45, 0, 2),  data = {   msg1 = 'example',   msg2 = 'cozy',  }, }` | `local e={pos=Vector(0,0,0),ang=Angle(45,0,2),data={msg1='example',msg2='cozy'}}` | **(68.7%)** renamed table, removed whitespaces and *trailing commas* (there could be pretty enough in large config tables)
