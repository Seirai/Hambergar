
PeacockFeather = Item:subclass('PeacockFeather')
requireImage( 'assets/item/feather.png','feather' )

function PeacockFeather:initialize(x,y)
	super.initialize(self,'trophy',x,y)
	self.name = "Peacock Feather"
	self.stack = 1
	self.maxstack = 1
	self.maxhp = 10
	self.maxmp = 10
	self.movementspeedbuffpercent = 0.5
	self.damage = 20
end

function PeacockFeather:equip(unit)
super.equip(self,unit)
	unit.movementspeedbuffpercent = self.movementspeedbuffpercent + unit.movementspeedbuffpercent
	unit.maxhp = self.maxhp + unit.maxhp
	unit.maxmp = self.maxmp + unit.maxmp
end

function PeacockFeather:unequip(unit)
super.unequip(self,unit)
	unit.movementspeedbuffpercent = unit.movementspeedbuffpercent -self.movementspeedbuffpercent 
	unit.maxhp =  unit.maxhp - self.maxhp
	unit.maxmp =  unit.maxmp - self.maxmp
end

function PeacockFeather:getPanelData()
	return {
		title = LocalizedString(self.name),
		type = LocalizedString(self.type),
		attributes = {
			{text="Given as a token of graditute by one of River's greatest companion."},
			{data=self.maxhp,image=icontable.life,text="HP Bonus"},
			{data=self.maxmp,image=icontable.mind,text="Energy Bonus"},
			{image=nil,text="Movement Speed Bonus",data=string.format("0/%.1f%%",self.movementspeedbuffpercent*100)},
		--	{image=nil,text="Armor",data=self.armor},
		}
	}
end

function PeacockFeather:update(dt)
end

function PeacockFeather:draw(x,y)
	if not x then x,y = self.body:getPosition() end
	love.graphics.draw(img.feather,x,y,0,1,1,24,24)
end


return PeacockFeather
