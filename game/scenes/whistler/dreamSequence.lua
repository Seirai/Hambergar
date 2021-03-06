preload('assassin','commonenemies','tibet','vancouver','stealth','whistler')
local kingedbg={
	dt = 0,
}

function kingedbg:update()
end
function kingedbg:draw()
	love.graphics.push()
	love.graphics.translate(-map.w/2,-map.h/2)
	self.m:draw()
	love.graphics.pop()
	love.graphics.push()
	love.graphics.translate(-map.w*3/2,-map.h/2)
	self.m:draw()
	love.graphics.pop()
	love.graphics.push()
	love.graphics.translate(map.w/2,-map.h/2)
	self.m:draw()
	love.graphics.pop()
	love.graphics.push()
	love.graphics.translate(-map.w/2,-map.h*3/2)
	self.m:draw()
	love.graphics.pop()
	love.graphics.push()
	love.graphics.translate(-map.w/2,map.h/2)
	self.m:draw()
	love.graphics.pop()
end

local lightsource = {x = 0,y=0,sx = 1.2,sy = 1.2}
function lightsource:update(dt)
	self.x,self.y = GetCharacter().x,GetCharacter().y
	self.x = self.x/5 - self.dx
	self.y = self.y/5 - self.dy
end

function lightsource:setShift(x,y,t)
	self.dx,self.dy = x,y
end

DreamMaze = Map:subclass'DreamMaze'
function DreamMaze:initialize()
	local w = 3328
	local h = w
	self.w,self.h=w,h
	super.initialize(self,w,h)
	local m = self:loadTiled'crossroad.tmx'
	
	kingedbg.m = m
	self.background = kingedbg
	self.savedata = {
--		map = 'scenes.whistler.station',
	}
--	assert (utilitybox)
--	traily = map.waypoints.trail[2]
--	stationcount = stationcount + 1
--	assert(stationcount<2)
end

function DreamMaze:load()
	
end


function DreamMaze:loadCheckpoint(checkpoint)
	if checkpoint == 'opening' then
		self:checkpoint1_load()
	end
end

function DreamMaze:checkpoint1_load()
	local x,y = unpack(map.waypoints.chr)
	local leon = Assassin:new(x,y,32,10)
	leon.direction = {0,-1}
	leon.controller = 'player'
	leon.skills.stim:setLevel(5)
	leon.HPRegen = 1000
	SetCharacter(leon)
--	leon:gotoState'stealth'
	map:addUnit(leon)
	map.camera = FollowerCamera:new(leon,{
		x1 = -self.w+screen.halfwidth,
		y1 = -self.h+screen.halfheight,
		x2 = self.w-screen.halfwidth,
		y2 = self.h-screen.halfheight
	})
	GetGameSystem().bottompanel:fillPanel(GetCharacter():getSkillpanelData())
	GetGameSystem().bottompanel:setPos(screen.halfwidth-512,screen.height - 140)
	leon:pickUp(Theravada())
	self:checkpoint1_loaded()
end

function DreamMaze:checkpoint1_enter()
	local leon = GetCharacter()
	local x,y = unpack(map.waypoints.chr)
	leon.x,leon.y = x,y
	leon.direction = {0,-1}
	leon.controller = 'player'
--	leon.HPRegen = 1000
	SetCharacter(leon)
	leon:gotoState'stealth'
	map:addUnit(leon)
	map.camera = FollowerCamera:new(leon,{
		x1 = -self.w+screen.halfwidth,
		y1 = -self.h+screen.halfheight,
		x2 = self.w-screen.halfwidth,
		y2 = self.h-screen.halfheight
	})
--	GetGameSystem().bottompanel:fillPanel(GetCharacter():getSkillpanelData())
--	GetGameSystem().bottompanel:setPos(screen.halfwidth-512,screen.height - 140)
	self:checkpoint1_loaded()
end

function DreamMaze:destroy()
	self.exitTrigger:destroy()
end

local dirs = {
	'left',
	'right',
	'top',
	'bottom',
}

function DreamMaze:checkpoint1_loaded()
	self.correctcount = 0
	self.maxcount = 1
	self.exitTrigger = Trigger(function(trig,event)
		if table.exist(dirs,event.index) and event.unit == GetCharacter() then
			trig:close()
			Timer(1,1,function()trig:open()end)
			print (event.index,self.destination)
			if event.index == self.destination then
				self.correctcount = self.correctcount + 1
				if self.correctcount > self.maxcount then
					self:finish()
				else	
					self:puzzle(event.index)
				end
			else
				self.correctcount = 0
				self:spawnEnemies()
				self:puzzle(event.index)
			end
		end
	end)
	self.exitTrigger:registerEventType'add'
	self.destination = 'left'
	lightsource:setShift(300,0)
	self:spawnEnemies()
	Lighteffect.lightOn(lightsource)
	anim:easy(GetGameSystem().fader,'opacity',255,0,1,'linear')
end

function DreamMaze:update(dt)
	super.update(self,dt)
	lightsource:update(dt)
end

function DreamMaze:finish()
	anim:easy(GetGameSystem().fader,'opacity',0,255,1,'linear')
	Timer(2,1,function()
	self:destroy()
	self.update = function()
			self:destroy()
			map = require 'scenes.whistler.train'
			map:load()
			map:checkpoint1_enter()
		end
	end)
end

function DreamMaze:puzzle(index)
	self.destination = dirs[math.random(4)]
	local x,y = GetCharacter().body:getPosition()
	if index == 'left' then
		x = x + map.w - 512
	elseif index == 'right' then
		x = x - map.w + 512
	elseif index == 'top' then
		y = y + map.h - 512
	else
		y = y - map.h + 512
	end
	if self.destination == 'left' then
		lightsource:setShift(300,0)
	elseif self.destination == 'right' then
		lightsource:setShift(-300,0)
	elseif self.destination == 'top' then
		lightsource:setShift(0,300)
	else
		lightsource:setShift(0,-300)
	end
	GetCharacter().body:setPosition(x,y)
end

function DreamMaze:spawnEnemies()
	for i = 1,3 do
		local u = SkeletonMagician:new(math.random(300)-150,math.random(300)-150,'enemy')
		u:enableAI()
		map:addUnit(u)
	end
	for i = 1,2 do
		local u = SkeletonSwordsman:new(math.random(300)-150,math.random(300)-150,'enemy')
		u:enableAI()
		map:addUnit(u)
	end
end
