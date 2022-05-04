Framework.String = {}

local StringCharset = {}

for i = 65,  90 do StringCharset[#StringCharset+1] = string.char(i) end
for i = 97, 122 do StringCharset[#StringCharset+1] = string.char(i) end

function Framework.String.Random(length)
    if length <= 0 then return '' end
    return Framework.String.Random(length - 1) .. StringCharset[math.random(1, #StringCharset)]
end

function Framework.GetRandomString(length) -- for compatibility with esx
    return Framework.String.Random(length)
end