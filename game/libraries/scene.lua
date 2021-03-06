Map=Object:subclass('Map')

--[[
a list of type of unit and corresponding data
					CategoryID	Mask	Group
item				1			34567
doodad				2			56
player				3			1357
enemy				4			1467
player Missile		5			12357
enemy Missiles		6			12467
dead				7			13456
]]--

cc = {
	item = 1,
	doodad = 2,
	player = 3,
	enemy = 4,
	playermissile = 5,
	enemymissile = 6,
	dead = 7,
	terrain = 8,
	all = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16},
} -- collide category


typeinfo = {
	doodad = {2,{5,6}},
	player = {3,{3,5,7}},
	enemy = {4,{6,7}},
	playerMissile = {5,{3,5,6}},
	enemyMissile = {6,{6,4}},
	dead = {7,{5,6}},
	terrain = {8}
}

function Map:initialize(w,h)
	self.world = love.physics.newWorld()
	self.world:setCallbacks(function(a,b,c)
		table.insert(self.collisionhandle,{'add',a,b,c})
	end
	,nil,nil) 
	self.units = {}
	self.destroys = {}
	self.updatable = {}
	self.waypoints = {}
--	self.aimap = AIMap:new(30,30,40)
	self:registerListener(gamelistener)
	self.count = {}
	self.blood = {}
	self.obstacles = {}
	controller:setLockAvailability(options.aimassist)
	self.unitdict = {}
	self.anim = love.filesystem.load'anim/anim.lua'()
	self.collisionhandle = {}
	--self:loadDefaultCamera()
end

MapBlock = Object:subclass('MapBlock')
function MapBlock:initialize(body,shape,fixture,index)
	self.body,self.shape,self.index = body,shape,index
	self.fixture = fixture
end

function MapBlock:preremove()
	self.fixture:setMask(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
end

function MapBlock:add(b,c)
--	print (b,c)
	if b:isKindOf(Unit) then
		self:notifyListeners({type='add',area=self,index=self.index,unit = b,coll=c})
	end
end

function MapBlock:destroy()
	self.shape:destroy()
	self.fixture:destroy()
	self.body:destroy()
end

function Map:setBlock(x,y,b)
	if b then
		local body = love.physics.newBody(self.world,x,y,'static')
		local shape = love.physics.newRectangleShape(40,40)
		local fixture = love.physics.newFixture(body,shape)
		fixture:setCategory(8)
		fixture:setMask(5,6)
		if b>0 then
			fixture:setSensor(true)
			self.waypoints[b] = {x,y}
		end
		local mb = MapBlock:new(body,shape,fixture,b)
--		self.aimap:setBlock(x,y,mb)
		fixture:setUserData(mb)
		mb:registerListener(gamelistener)
	else
	end	
end

function Map:placeObstacle(x,y,w,h,b,name)
	local body = love.physics.newBody(self.world,x+w/2,y+h/2)
	local shape = love.physics.newRectangleShape(w,h)
	local fixture = love.physics.newFixture(body,shape)
	fixture:setCategory(8)
	fixture:setMask(5,6)
	if b then
		fixture:setSensor(true)
		self.waypoints[b] = {x,y}
	end
	local mb = MapBlock:new(body,shape,fixture,b)
	if name then
		self.obstacles[name]=mb
	end
	fixture:setUserData(mb)
	mb:registerListener(gamelistener)
end

function Map:setObstacleState(b,state)
	local obs = self.obstacles[b]
	assert(obs)
	obs.shape:setSensor(not state)
end

function Map:getBlock(x,y)
--	return self.aimap:getBlock(x,y)
end

function Map:findPath(start,goal)
--	return self.aimap:astar(start,goal)
end


function persist(a,b,c)
--	if map.units[a] and map.units[b] then
	if a and b then
		if a.persist then
			a:persist(b,c)
		end
		if b.persist then
			b:persist(a,c)
		end
	end
--	end
end


function Map:addUnit(...)
	for k,unit in ipairs(arg) do
		self.units[unit] = true
		unit.map = self
		if unit.createBody then unit:createBody(self.world) end
		unit:registerListener(gamelistener)
		local controller = unit.controller or 'default'
		self.count[controller] = self.count[controller] or 0
		self.count[controller] = self.count[controller] + 1
	end
end


function Map:playCutscene(scene)
	self.cutscene = scene
	scene:reset()
end

function Map:addUpdatable(...)
	for k,unit in ipairs(arg) do
		self.updatable[unit] = true
	end
end

function Map:removeUpdatable(...)
	for k,unit in ipairs(arg) do
		self.updatable[unit] = nil
	end
end

function Map:removeUnit(...)
	for k,unit in ipairs(arg) do
		table.insert(self.destroys,unit)
		if unit.preremove then unit:preremove() end
		local controller = unit.controller or 'default'
		assert(self.count[controller])
		self.count[controller] = self.count[controller] - 1
	end
end

function Map:disableAI()
	for unit,v in pairs(self.units) do
		unit.ai = nil
	end
end

function Map:setAIState(state)
	for unit,v in pairs(self.units) do
		if unit.ai and unit.ai.pause then
			unit.ai:pause(state)
		end
	end
end

function Map:update(dt)
	
	if self.cutscene and self.cutscene:update(dt)==STATE_SUCCESS then
		self.cutscene = nil
	end
	if self.timescale then
		dt = self.timescale * dt
	end
	self.anim:update(dt)
	collides = {}
	self.world:update(dt)
	--
	--
	for k,v in pairs(self.destroys) do
		if v.destroy then v:destroy() end
		self.units[v] = nil
	end
	self.destroys = {}
	for unit,v in pairs(self.units) do
		if unit.update then unit:update(dt) end
	end
	for unit,v in pairs(self.updatable) do
		if unit.update then unit:update(dt) end
	end
	if self.background then
		self.background:update(dt)
	end
	if not self.disableBlur then
		Blureffect.update(dt)
	end
	for i,v in ipairs(self.collisionhandle) do
		local t,a,b,c = unpack(v)
			a,b = a:getUserData(),b:getUserData()
			if a and b then
				if a[t] then
					a[t](a,b,c)
				end
				if b[t] then
					b[t](b,a,c)
				end
			end
		
	end
	self.collisionhandle = {}
end

function Map:draw()
	if not self.disableBlur then
		Blureffect.begin()
	end
	if self.camera then self.camera:apply() end
	if self.background then self.background:draw() end
	
	Lighteffect.begin(self.units)
	Lighteffect.finish()
--	if self.camera then self.camera:apply() end
	for unit,v in pairs(self.units) do
		if unit.draw then unit:draw() end
	end
	for unit,v in pairs(self.updatable) do
		if unit.draw then unit:draw() end
	end
	
--	if self.camera then self.camera:revert() end
	local x,y = unpack(GetOrderDirection())
	local px,py = unpack(GetOrderPoint())
	--[[
	if StealthSystem.lastseen then
		love.graphics.circle('fill',StealthSystem.lastseen.x,StealthSystem.lastseen.y,16)
	end]]
	love.graphics.draw(img.cursor,px,py,math.atan2(y,x),1,1,16,16)
	if self.camera then self.camera:revert() end
	if not self.disableBlur then
		Blureffect.finish()
	end
	local u = GetOrderUnit()
	if u then
		local x,y = u.x,u.y
		x,y = map.camera:transform(x,y)
		x,y = x+screen.halfwidth,y+screen.halfheight
		love.graphics.circle('line',x,y,16,30) -- TODO: make a better lock on Image
	end
	
end

function Map:findUnitsInArea(area)
	if area.type == 'circle' then
		return self:findUnitsWithCondition(
			function(unit) 
				return withincirclearea(unit,area.x,area.y,area.range)
		end)
	elseif area.type == 'fan' then
		return self:findUnitsWithCondition(
			function(unit) 
				return withinfanarea(unit,area.x,area.y,area.r,area.angle,area.range)
		end)
	end
end

function Map:findUnitsWithCondition(func)
	result = {}
	for unit,v in pairs(self.units) do
		if unit:isKindOf(Unit) and func(unit) then
			table.insert(result,unit)
		end
	end
	return result
end

function Map:loadUnitFromTileObject(obj)
	print (obj,obj.properties.id)
	local w,h=self.w,self.h
	if loadstring('return '..obj.name)() then
		local object = loadstring('return '..obj.name..':new()')()
		assert(object)
		object.x,object.y=obj.x-w/2,obj.y-h/2
		if obj.properties.controller then
			object.controller = obj.properties.controller
		end
		object.r = obj.properties.angle or math.random(3.14)
		self:addUnit(object)
		if object.controller=='enemy' and object.enableAI then
			object:enableAI()
		end
		if obj.properties.id then
			_G[obj.properties.id]=object
		end
		if obj.properties.drop then
			table.insert(object.drops,loadstring('return '..obj.properties.drop..':new()')())
		end
		return object
	end
end

function Map:loadTiled(tmx)
	local w,h=self.w,self.h
	local loader = require("AdvTiledLoader/Loader")
	loader.path = "maps/"
	local m = loader.load(tmx)
	m.useSpriteBatch=true
	m.drawObjects=false
	local oj = m.objectLayers
	for k,v in pairs(oj) do
		if v.name == 'obstacles' then
			for _,obj in pairs(v.objects) do
				self:placeObstacle(obj.x-w/2,obj.y-h/2,obj.width,obj.height,nil,obj.name)
			end
		elseif v.name == 'areas' then
			for _,obj in pairs(v.objects) do
				self:placeObstacle(obj.x-w/2,obj.y-h/2,obj.width,obj.height,obj.name)
			end
		elseif v.name == 'objects' then
			for _,obj in pairs(v.objects) do
				if obj.properties.phrase then
					local p = obj.properties.phrase
					self.unitdict[p] = self.unitdict[p] or {}
					table.insert(self.unitdict[p],obj)
					
				else
					self:loadUnitFromTileObject(obj,w,h)
				end
				
			end
		end
	end
	self.tiled = m
	return m
end

function Map:splashText(text,img)
	local dws = CutSceneSequence:new()
	self.timescale = 0.25
	local panel2 = goo.object:new()
	local divide = goo.image:new(panel2)
	divide:setPos(screen.width-200,screen.halfheight)
	divide:setImage(img)
	local panel1 = goo.object:new()
	anim:easy(panel1,'x',-300,0,1,'quadInOut')
	anim:easy(panel2,'x',300,0,1,'quadInOut')
	local x,y = 100,screen.halfheight-50
	for c in text:gmatch"." do
		dws:push(ExecFunction:new(function()
			local ib = goo.DWSText:new(panel1)
			ib:setText(c)
			ib:setPos(x,y)
			local textscale = 2
			x = x+ib.w*textscale
			local animsx = anim:new({
				table = ib,
				key = 'xscale',
				start = 5*textscale,
				finish = 2*textscale,
				time = 0.3,
				style = anim.style.linear}
			)
			local animsy = anim:new({
				table = ib,
				key = 'yscale',
				start = 5*textscale,
				finish = 2*textscale,
				time = 0.3,
				style = anim.style.linear}
			)
			local animg = anim.group:new(animsx,animsy)
			animg:play()
			local animwx = anim:new({
				table = ib,
				key = 'xscale',
				start = 2*textscale,
				finish = 1*textscale,
				time = 0.5,
				style = 'elastic'
			})
			local animwy = anim:new({
				table = ib,
				key = 'yscale',
				start = 2*textscale,
				finish = 1*textscale,
				time = 0.5,
				style = 'elastic'
			})
			local animw = anim.group:new(animwx,animwy)
			local animc = anim.chain:new(animg,animw)
			animc:play()
			TEsound.play('sound/thunderclap.wav')
		end),0)
		
		dws:wait(0.1)
	end	
		dws:wait(0.5)
	dws:push(ExecFunction:new(function()
	anim:easy(panel1,'x',0,screen.width,2,'quadInOut')
	anim:easy(panel2,'x',0,-screen.width,2,'quadInOut')
	self.timescale = 1
	end),0)
	dws:push(ExecFunction:new(function()
	panel1:destroy()
	panel2:destroy()
	end),2)
	self:playCutscene(dws)
end

function Map:loadDefaultCamera(leon)
	self.camera = FollowerCamera(leon,
	{
		x1 = -self.w/2 + screen.halfwidth,
		y1 = -self.h/2 + screen.halfheight,
		x2 = self.w/2 + screen.halfwidth,
		y2 = self.h/2 + screen.halfheight,
	})
end

function Map:changeOwner(unit,owner)
	self.count[unit.controller] = self.count[unit.controller] - 1
	unit.controller = owner
	self.count[unit.controller] = self.count[unit.controller] or 0
	self.count[unit.controller] = self.count[unit.controller] + 1
	
end

function normalize(x,y)
	local n = math.sqrt(x*x+y*y)
	if n==0 then return 0,0 end
	return x/n,y/n
end

function withinrectanglearea(unit,x,y,w,h)
	return unit.x>=x and unit.x<=x+w and unit.y>=y and unit.y<=y+h
end

function withincirclearea(unit,x,y,r)
	return getdistance(unit,{x=x,y=y})<r
end

function withinfanarea(unit,x,y,r,angle,range)
	local angle2 = math.atan2(unit.y-y,unit.x-x)
	if angle<0 then
		angle = angle + math.pi*2
	end
	if angle2<0 then
		angle2 = angle2 + math.pi*2
	end
	return getdistance(unit,{x=x,y=y})<r and math.abs(angle2-angle)<range
end

function getdistance(a,b)
	x,y=a.x-b.x,a.y-b.y
	return math.sqrt(x*x+y*y)
end


function anglebetween(b,a)
	x,y=a.x-b.x,a.y-b.y
	return math.atan2(y,x)
end
function displacement(x,y,angle,dis)
	local cos,sin = math.cos(angle),math.sin(angle)
	return x+dis*cos,y+dis*sin
end
