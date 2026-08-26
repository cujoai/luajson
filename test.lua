-- import the json module

local json = require('json')

local foo = json.decode([[
            {"name" : "lol", "age" : -1.5e+06, "foo" : ["bar", true, null]}
            ]])
foo.x = 'x'
-- foo[1] = 'hossa'
-- foo[2] = 'rossa'

print(foo.age)    -- -1500000
print(foo.name)   -- lol
print(foo.foo[1]) -- bar
print(foo.foo[2]) -- true
print(foo.foo[3]) -- null
print(foo.foo[3] == json.null) -- true
foo.foox = "omg :D"
foo.theNull = json.null
foo.itIs = true
foo.itIsNot = false
foo.isNil = nil
foo.a = 'a'

foo.subtable = {
	a = 'one',
	b = 'two'
}

local a = {
	test = 'hello',
	test2 = 'world'
}

a.myself = a

local str = json.encode(foo)
print(str)

local foo2 = json.decode(str)

print(json.encode(foo2)) -- {"name":"lol",age:-1500000,"foo":"omg :D"}
print(json.encode(nil))
assert(pcall(json.encode, function () print('foo') end) == false)
assert(pcall(json.encode) == false)
assert(pcall(json.encode, {[false]=1}) == false)

local escape = debug.setmetatable(function() end, {__tostring = function() return '"' end})
assert(json.encodeany(escape) == '"\\""')
assert(json.decode(json.encodeany(escape)) == '"')

assert(json.decode('"\\u00AA"') == '\xc2\xaa')
assert(pcall(json.decode, '"\\u00G0"') == false)
assert(json.decode('"a\\u0000b"') == 'a\0b')
assert(pcall(json.decode, '"\\u123"') == false)
assert(pcall(json.decode, '"\\u"') == false)
assert(pcall(json.decode, '"\\ux"') == false)

assert(json.encode('\xc2\xaa') == '"\\u00aa"')
assert(json.encode('\xe2\x82\xac') == '"\\u20ac"')
assert(json.encode('\xf0\x9f\x98\x80') == '"\\ud83d\\ude00"')
assert(json.encode('\xf4\x8f\xbf\xbf') == '"\\udbff\\udfff"')
assert(json.encode('\xf0') == '"\xf0"')
assert(json.encode('\xe2') == '"\xe2"')
assert(json.encode('\xc2') == '"\xc2"')
assert(json.encode('\xc3a') == '"\xc3a"')
assert(json.encode('\x80\xf8') == '"\x80\xf8"')
assert(json.encode('\xc0\x80') == '"\xc0\x80"')
assert(json.encode('\xed\xa0\x80') == '"\xed\xa0\x80"')
assert(json.encode('\xf4\x90\x80\x80') == '"\xf4\x90\x80\x80"')

do
   local t = {}
   for i = 1, 2000 do t[i] = json.null end
   print(#json.encode(t))
end
do
   local t = {}
   for i = 1, 1000 do t[i] = print end
   print(#json.encodeany(t))
end
do
   local node = string.rep('x', 9000)
   for i = 1, 25 do node = { node } end
   print(#json.encode(node))
end
do
   local node = string.rep('x', 9000)
   for i = 1, 25 do node = { k = node } end
   print(#json.encode(node))
end
