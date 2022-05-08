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

function Framework.String.IsNull(str)
    if type(str) ~= "string" then Framework.ShowError(GetCurrentResourceName(), 'The passed parameter at Framework.String.IsNull() is not a type of string!') return true end
    if str and str ~= '' and str ~= nil then
        return false
    end
    return true
end