requireImage( "assets/part1.png",'part1' )
requireImage( "assets/cloud.png",'cloud2' )
requireImage( "assets/square.png",'square' )
requireImage( "assets/sparkle.png",'sparkle' )
systems = {}
local p = love.graphics.newParticleSystem(img.part1, 1000)
p:setEmissionRate(options.particlerate*100)
p:setSpeed(100, 100)
p:setGravity(0)
p:setSizes(2, 1)
p:setColors(255, 255, 255, 255, 58, 128, 255, 0)
p:setPosition(400, 300)
p:setLifetime(1)
p:setParticleLife(1)
p:setDirection(0)
p:setSpread(360)
p:setRadialAcceleration(0)
p:setTangentialAcceleration(250)
p:stop()
table.insert(systems, p)

p = love.graphics.newParticleSystem(img.cloud2, 1000)
p:setEmissionRate(options.particlerate*100)
p:setSpeed(200, 250)
p:setGravity(100, 200)
p:setSizes(1, 1)
p:setColors(16, 81, 229, 255, 176, 16, 229, 0)
p:setPosition(400, 300)
p:setLifetime(1)
p:setParticleLife(1)
p:setDirection(180)
p:setSpread(20)
--p:setRadialAcceleration(-200, -300)
p:stop()
table.insert(systems, p)		

p = love.graphics.newParticleSystem(img.square, 1000)
p:setEmissionRate(options.particlerate*60)
p:setSpeed(200, 250)
p:setGravity(100, 200)
p:setSizes(1, 2)
p:setColors(240, 3, 176, 255, 204, 240, 3, 0)
p:setPosition(400, 300)
p:setLifetime(1)
p:setParticleLife(2)
p:setDirection(90)
p:setSpread(0)
p:setSpin(300, 800)
p:stop()
table.insert(systems, p)		

p = love.graphics.newParticleSystem(img.part1, 1000)
p:setEmissionRate(options.particlerate*1000)
p:setSpeed(300, 400)
p:setSizes(2, 1)
p:setColors(220, 105, 20, 255, 194, 30, 18, 0)
p:setPosition(400, 300)
p:setLifetime(0.1)
p:setParticleLife(0.2)
p:setDirection(0)
p:setSpread(360)
p:setTangentialAcceleration(1000)
p:setRadialAcceleration(-2000)
p:stop()
table.insert(systems, p)	

p = love.graphics.newParticleSystem(img.part1, 1000)
p:setEmissionRate(options.particlerate*200)
p:setSpeed(300, 400)
p:setSizes(1, 2)
p:setColors(255, 255, 255, 255, 255, 128, 128, 0)
p:setPosition(400, 300)
p:setLifetime(1)
p:setParticleLife(2)
p:setDirection(0)
p:setSpread(360)
p:setTangentialAcceleration(2000)
p:setRadialAcceleration(-8000)
p:stop()
table.insert(systems, p)

p = love.graphics.newParticleSystem(img.sparkle, 1000)
p:setEmissionRate(options.particlerate*150)
p:setGravity(0,0)
p:setSpeed(-100, 100)
p:setSizes(1, 1)
p:setColors(255, 255, 255, 255, 255, 255, 255, 0)
--p:setPosition(400, 300)
p:setLifetime(1)
p:setParticleLife(2)
p:setDirection(0)
p:setSpread(360)
p:setTangentialAcceleration(0)
p:setRadialAcceleration(0)
p:stop()
table.insert(systems, p)

requireImage( 'assets/pulse.png','pulse' )

requireImage('assets/mastery/missile/birdmissile.png','crane')
particlemanager = {
	goldensparkle = function()
	local p = love.graphics.newParticleSystem(img.sparkle, 1000)
		p:setEmissionRate(options.particlerate*150)
		p:setGravity(0,0)
		p:setSpeed(-100, 100)
		p:setSizes(0.5, 0.5)
		p:setColors(255, 255, 255, 255, 255, 255, 255, 0)
		--p:setPosition(400, 300)
		p:setLifetime(1)
		p:setParticleLife(1)
		p:setDirection(0)
		p:setSpread(360)
		p:setTangentialAcceleration(0)
		p:setRadialAcceleration(0)
		p:stop()
		return p
	end,
	cranes = function()
		local p = love.graphics.newParticleSystem(img.part1, 1000)
		p:setEmissionRate(options.particlerate*150)
		p:setGravity(0,0)
		p:setSpeed(-300, 300)
		p:setSizes(2, 2)
		p:setColors(255, 255, 255, 255, 255, 255, 255, 0)
		p:setLifetime(1)
		p:setParticleLife(1)
		p:setDirection(0)
		p:setSpread(360)
		p:setTangentialAcceleration(-1000)
		p:setRadialAcceleration(360)
		p:stop()
		return p
	end,
	meteor = function()
		local p = love.graphics.newParticleSystem(img.sparkle,1000)
		p:setEmissionRate(options.particlerate*150)
		p:setGravity(0,0)
		p:setSpeed(-50, 50)
		p:setSizes(0.4, 0.2)
		p:setColors(255, 255, 255, 255, 255, 255, 255, 0)
		p:setLifetime(5)
		p:setParticleLife(1)
		p:setDirection(0)
		p:setSpread(360)
		p:setTangentialAcceleration(-100)
		p:setRadialAcceleration(100)
		p:stop()
		return p
	end,
	fire = function()
	
		local p = love.graphics.newParticleSystem(img.part1, 1000)
		p:setEmissionRate(options.particlerate*1000)
		p:setSpeed(300, 400)
		p:setSizes(2, 1)
		p:setColors(220, 105, 20, 255, 194, 30, 18, 0)
		p:setPosition(400, 300)
		p:setLifetime(0.1)
		p:setParticleLife(0.2)
		p:setDirection(0)
		p:setSpread(360)
		p:setTangentialAcceleration(1000)
		p:setRadialAcceleration(-2000)
		p:stop()
		return p
	end,
	
	mistycloud = function()
	
		local p = love.graphics.newParticleSystem(requireImage('assets/buff/mistycloud.png','mistycloudbuff'), 1000)
		p:setEmissionRate(options.particlerate*5)
		p:setSpeed(50, 100)
		p:setSizes(1, 1)
		p:setColors(255, 255, 255, 255, 255, 255, 255, 0)
		p:setPosition(400, 300)
		p:setLifetime(0.1)
		p:setParticleLife(3)
		p:setDirection(0)
		p:setSpread(360)
		p:setTangentialAcceleration(0)
		p:setRadialAcceleration(-100)
		p:stop()
		return p
	end,
	
	catalyst = function()
		local p = love.graphics.newParticleSystem(requireImage('assets/buff/catalyst.png','catalystbuff'),1000)
		p:setEmissionRate(options.particlerate*150)
		p:setGravity(0,0)
		p:setSpeed(-50, 50)
		p:setSizes(0.2, 1)
		p:setColors(255, 255, 255, 125, 255, 255, 255, 0)
		p:setLifetime(5)
		p:setParticleLife(1)
		p:setDirection(0)
		p:setSpread(360)
		p:setTangentialAcceleration(-50)
		p:setRadialAcceleration(50)
		p:stop()
		return p
	end,
	
	
	troll = function()
	
		local p = love.graphics.newParticleSystem(requireImage'assets/buff/troll.png', 1000)
		p:setEmissionRate(options.particlerate*5)
		p:setSpeed(50, 100)
		p:setSizes(1, 1)
		p:setColors(255, 255, 255, 255, 255, 255, 255, 0)
		p:setPosition(400, 300)
		p:setLifetime(0.1)
		p:setParticleLife(3)
		p:setDirection(0)
		p:setSpread(360)
		p:setTangentialAcceleration(0)
		p:setRadialAcceleration(-100)
		p:stop()
		return p
	end,
	
	smallfire = function()
		local p = love.graphics.newParticleSystem(img.part1, 1000)
		p:setEmissionRate(options.particlerate*150)
		p:setSpeed(100, 200)
		p:setSizes(1, 0.5)
		p:setColors(220, 105, 20, 255, 194, 30, 18, 0)
		p:setPosition(400, 300)
		p:setLifetime(0.1)
		p:setParticleLife(0.2)
		p:setDirection(0)
		p:setSpread(360)
		p:setTangentialAcceleration(1000)
		p:setRadialAcceleration(-2000)
		p:stop()
		return p
	end,
}
function particlemanager.getsystem(name)
	assert(particlemanager[name])
	return particlemanager[name]()
end

UnitTrail = Object:subclass('UnitTrail')
function UnitTrail:initialize(b,name,time,decay)
	self.bullet = b
	self.p = particlemanager.getsystem(name)
	self.dt = 0
	self.time = time
	self.p:setLifetime(time-decay)
--	self.p:setParticleLife(time-decay)
	self.p:start()
end

function UnitTrail:update(dt)
	self.dt = self.dt + dt
	self.p:setPosition(self.bullet.x,self.bullet.y)
	if self.bullet.getAngle then
		self.p:setDirection(self.bullet:getAngle() or 0)
	end
	if self.dt>self.time then
		map:removeUpdatable(self)
	end
	self.p:update(dt)
end

function UnitTrail:draw()
	love.graphics.draw(self.p)
end

Trail = Object:subclass('Trail')
function Trail:initialize(x,y,sx,sy)
	self.x,self.y = x,y
	self.sx,self.sy = sx,sy
	local p = love.graphics.newParticleSystem(img.pulse,1000)
	
	p:setEmissionRate(options.particlerate*20)
	p:setSpeed(0, 0)
	p:setGravity(0)
	p:setSizes(0.2,0.2)
	p:setColors(255, 255, 255, 255, 255, 255, 255, 0)
	p:setPosition(400, 300)
	p:setLifetime(1)
	p:setParticleLife(1)
	p:stop()
	self.system=p
	self.xcoord = 0
end
function Trail:update(dt)
	local x,y = self:getPosition(dt)
	self.system:setPosition(x,y)
	self.system:start()
	self.system:update(dt)
end

function Trail:draw()
	love.graphics.draw(self.system,0,0)
end

WaypointTrail = Trail:subclass('WaypointTrail')
function WaypointTrail:initialize(x,y,waypoints,speed,sx,sy)
	self.waypoints,self.speed = waypoints,speed
	super.initialize(self,x,y,sx,sy)
	
	self.index = 1
	self.dx,self.dy=0,0
end
--[[
function WaypointTrail:calculate()
	self.dx,self.dy = unpack(self.waypoints[1])
end]]--

function WaypointTrail:getPosition(dt)
	local tx,ty = unpack(self.waypoints[self.index])
	local x,y = self.dx,self.dy
	if (tx-x)*(tx-x)+(ty-y)*(ty-y)<=self.speed*self.speed*dt*dt then
--		print ('hit',self.stop)
		self.index = self.index + 1
		if self.index > #self.waypoints then
			if self.stop then self:stop() end
			self.index = 1
			self.dx,self.dy = unpack(self.waypoints[1])
		end
	else
		local dx,dy = normalize(tx-x,ty-y)
		dx,dy = dx*dt*self.speed,dy*dt*self.speed
		self.dx,self.dy = self.dx+dx,self.dy+dy
	end
	return self.x+self.dx*self.sx,self.y+self.dy*self.sy
end
