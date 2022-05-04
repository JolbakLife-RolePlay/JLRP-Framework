Framework.Integer = {}
local NumberCharset = {}

for i = 48,  57 do NumberCharset[#NumberCharset+1] = string.char(i) end

function Framework.Integer.Random(length)
    if length <= 0 then return '' end
    return Framework.Integer.Random(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
end
