Mat = Unit:subclass'Mat'

function Mat:initialize(...)
	super.initialize(self,...)
	self.controller = 'player'
end

local meditation1 = require 'scenes.vancouver.meditation'
function Mat:interact(unit)
	if unit:isKindOf(Assassin) then
		meditation1(self)
	end
end

function Mat:createBody(world)
	super.createBody(self,world)
	self.fixture:setSensor(true)
end

requireImage('assets/vancouver/mat.png','mat')
function Mat:draw()
	love.graphics.draw(img.mat,self.x,self.y,0,1,1,64,64)
end

-- Potion Master

PotionMaster = Unit:subclass'PotionMaster'
function PotionMaster:initialize(...)
	super.initialize(self,...)
	self.controller = 'player'
	self.inventory = Shop(self)
	local inv = self.inventory
	inv:addItem(FiveSlash())
	inv:addItem(PeacockFeather:new())
	inv:addItem(BigHealthPotion:new())
end

local potion = require 'scenes.vancouver.potion'
requireImage('assets/vancouver/tom.png','tom')
function PotionMaster:interact(unit)
	potion(self)
end

function PotionMaster:draw()
	love.graphics.draw(img.tom,self.x,self.y,0,2,2,6,7)
end

local armory = require 'scenes.vancouver.armory'
Brandon = Unit:subclass'Brandon'
function Brandon:initialize(x,y)
	super.initialize(self,x,y,16,10)
	self.controller = 'player'
	self.inventory = Shop(self)
	local inv = self.inventory
	inv:addItem(FiveSlash())
	inv:addItem(PeacockFeather:new())
	inv:addItem(BigHealthPotion:new())
end

requireImage('assets/vancouver/brandon.png','brandon')
function Brandon:interact(unit)
	armory(self)
end

function Brandon:draw()
	love.graphics.draw(img.brandon,self.x,self.y,0,2,2,6,7)
end
