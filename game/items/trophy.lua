
files = love.filesystem.enumerate('items/trophy/')
for i,v in ipairs(files) do
	local f = 'items/trophy/'..v
	if love.filesystem.isFile(f) then
		table.insert(itemlist,love.filesystem.load (f)())
	end
end