local printf = function(str,...) print(str:format(...)) end

local start = 0x0000
local len = 0x10000

local function itoutf8(idx)
	return string.char(idx>>8,idx&0xFF)
end

local line_len = 32
for i = start,start+len-1,line_len do
	local tbl = {}
	for j = 0,line_len-1 do
		local idx = i+j
		tbl[#tbl+1] = utf8.char(idx)
	end
	printf("%04Xh: %s",i,table.concat(tbl,' '))
end
