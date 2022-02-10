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