CutscenePlayer = Object:subclass'CutscenePlayer'
function CutscenePlayer:initialize(c)
	self.dt = 0
	self.options = 
	{
		DialogOption(100,screen.height-100,{58,119,16},'A'),
		DialogOption(150,screen.height-150,{221,75,47},'B'),
		DialogOption(50,screen.height-150,{69,96,148},'X'),
		DialogOption(100,screen.height-200,{240,207,76},'Y'),
	}
	self.convdt = 0
	self:play(c)
	self.timers = {}
end

function CutscenePlayer:play(c,forcereplay)
	if #c>0 then
		c = c[math.random(#c)]
	end
	if forcereplay or c~=self.c then
		c.camera = CutsceneCamera()
		self.c = c
		self.dt = 0
	end
end

function CutscenePlayer:addGameTimer(...)
	for k,unit in ipairs(arg) do
		self.timers[unit] = true
	end
end

function CutscenePlayer:removeGameTimer(...)
	for k,unit in ipairs(arg) do
		self.timers[unit] = nil
	end
end

function CutscenePlayer:setChoiceTime(t)
	self.choicetime = self.dt + t
end

function CutscenePlayer:update(dt)
	self.dt = self.dt + dt
	self.convdt = self.convdt + dt
	if self.c then
		self.c:jumpToFrame(self.dt)
	end
	if self.dt > self.choicetime then
		
		if self.onFinish then
			self:onFinish()
		else
			popsystem()
		end
	end
	self.choice = nil
	for i,v in ipairs(self.options) do
		v:update(dt)
		if v.isOn then
			self.choice = v.text
			escaped = false
			for i,v in ipairs(self.options) do
				v:fadeOut()
			end
			v.state = 'fadeoutbig'
			return
		end
	end
	for unit,v in pairs(self.timers) do
		if unit.update then unit:update(dt) end
	end
	if self.convtime then
		self.convtime = self.convtime - dt
		if self.convtime <= 0 then
			self.convtime = nil
		end
	end
end

function CutscenePlayer:keypressed(k)
	if k=='escape' then
		if not self:isChoosing() then
			escaped = true
			self:playConversation()
			self:setChoiceTime(0)
		end
	end
end

function CutscenePlayer:playConversation(conv,speaker,time)
	if type(speaker) == 'number' then
		time,speaker = speaker,time
	end
	self.speaker = speaker
	
	if speaker then
		self.conv = speaker..LocalizedString' : '..conv
	else
		self.conv = conv
	end
	if conv then
		self.convtime = time or 10000
	else
		self.convtime = 0.1
	end
end

function CutscenePlayer:draw()
	love.graphics.push()
	self.c:draw()
	love.graphics.pop()
	love.graphics.setFont(fonts.oldsans24)
--	for i,v in pairs(self.conv) do
--		if self.convdt>=i and self.convdt<=v[2]+i then
		local v = self.conv
		if v and self.convtime then
			local font = love.graphics.getFont()
			love.graphics.setColor(0,0,0,220)
			local w,h = font:getWidth(v)+10,select(2,fontGetWrap(font,v,624))*font:getHeight()+10
			love.graphics.rectangle('fill',screen.halfwidth - w/2,screen.height - 105 ,w,h)
			love.graphics.setColor(255,255,255,225)
--			print (v)
			pfn(v,200,screen.height - 100,624,'center')
		end
--	end
	sfn(fonts.oldsans12)
	for i,v in ipairs(self.options) do
		v:draw()
	end
end

function CutscenePlayer:setChoice(t)
	if self.options[1].state == 'hidden' then
	self.t = t
		for i,v in ipairs(self.t) do
			self.options[i].text = v
			self.options[i]:fadeIn()
		end
	end
end

function CutscenePlayer:isChoosing()
	return self.options[1].state == 'normal'
end

function CutscenePlayer:getChoice()
	return self.choice
end

CutsceneObject = Object:subclass'CutsceneObject'
function CutsceneObject:initialize(begin,frame,img,ox,oy,quad)
	self.transformations = {}
	self.begin = begin
	self.frame = frame
	self.img = img
	self.quad = quad
	self.ox,self.oy = ox,oy
end

function CutsceneObject:applyFrame(f)
	if f<self.begin or f>self.begin+self.frame then
		self.invis = true
		return
	end
	self.invis = false
	f = f-self.begin
	if f>0 then
		for i,v in ipairs(self.transformations) do
			v:applyFrame(self,f)
		end
	end
end

function CutsceneObject:addTransformation(trans)
	assert(trans)
	table.insert(self.transformations,trans)
end

function CutsceneObject:draw()
	if self.invis then return end
	if self.img then
		if self.quad then
			love.graphics.draw(self.img,self.quad,self.x,self.y,self.r,self.sx,self.sy,self.ox,self.oy)
		else
			love.graphics.draw(self.img,self.x,self.y,self.r,self.sx,self.sy,self.ox,self.oy)
		end
	else
		-- TODO
	end
end

CutsceneCamera = CutsceneObject:subclass('CutsceneCamera')
function CutsceneCamera:initialize()
	self.x,self.y = -screen.halfwidth,-screen.halfheight
	self.sx,self.sy = 1,1
	self.r = 0
	self.ox,self.oy = 0,0
	self.transformations = {}
end

function CutsceneCamera:applyFrame(f)
	for i,v in ipairs(self.transformations) do
		v:applyFrame(self,f)
	end
end
function CutsceneCamera:draw()
	love.graphics.translate(self.x*self.sx,self.y*self.sy)
	love.graphics.scale(self.sx,self.sy)
	love.graphics.rotate(self.r)
	love.graphics.translate((self.ox+screen.halfwidth)/self.sx,(self.oy+screen.halfheight)/self.sy)
end

ObjectTransformation = Object:subclass'ObjectTransformation'
function ObjectTransformation:initialize(arg)
	self.transformarg = arg
end

function ObjectTransformation:applyFrame(obj,f)
	assert(self.transformarg)
	local delay = self.transformarg.delay or 0
	f = f-delay
	local total = self.transformarg.total
	if f<0 or f>total then return end
	local prop = self.transformarg.prop
	local vi,vf,style = self.transformarg.vi,self.transformarg.vf,self.transformarg.style or style.linear
	obj[prop] = style(f,vi,vf,total)
end

function ObjectTransformation:draw()
	
end


Cutscene = Object:subclass'Cutscene'
function Cutscene:initialize(length)
	self.objs = {}
	self.frame = 0
	self.camera = CutsceneCamera()
	self.dt = 0
	self.path = ''
	self.imgs = {}
	self.life = length
end

function Cutscene:getFrame(n)
end

function Cutscene:jumpToFrame(n)
	self.frame = n
	for i,v in ipairs(self.objs) do
		v:applyFrame(n)
	end
	self.camera:applyFrame(n)
end

function Cutscene:delta(dt)
	self.dt = self.dt + dt
end

function Cutscene:draw()
	self.camera:draw()
	for i,v in ipairs(self.objs) do
		v:draw()
	end
end
function Cutscene:getCutsceneImage(path)
	if not self.imgs[path] then
		self.imgs[path] = love.graphics.newImage(self.path..path)
	end
	return self.imgs[path]
end

function Cutscene:addObject(obj)
	assert(obj)
	obj.begin = obj.begin+self.dt
	table.insert(self.objs,obj)
end

requireImage('assets/dot.png','dot')
DialogOption = Object:subclass('DialogOption')
function DialogOption:initialize(x,y,color,text)
	color = color or {0,0,0,204}
	self.x,self.y = x,y
	self.text = text
	self.color = color
	self.dt = 0
	self.state = 'hidden'
	self.sx,self.sy = 50,50
end

function DialogOption:fadeIn()
if self.state == 'normal' then return end
	self.dt = 0
	self.state = 'fadein'
	self.isOn = nil
	self.sx,self.sy = 50,50
end

function DialogOption:fadeOut()
	if self.state == 'hidden' then return end
	self.dt = 0
	self.state = 'fadeout'
	self.isOn = nil
end

function DialogOption:update(dt)
	if self.state == 'normal' then
		if love.mouse.isDown('l') then
			local x,y = love.mouse.getPosition()
			if math.abs(x-self.x)+math.abs(y-self.y)<=25 then
				self.isOn = true
			end
		end
		return
	end
	if self.state ~= 'hidden' then
		self.dt = self.dt + dt
		if self.dt >= 1 then
			if self.state == 'fadein' then
				self.state = 'normal'
			else
				self.state = 'hidden'
			end
		end
	end
end

function DialogOption:draw()
	if self.state=='normal' then
		self.color[4] = 204
	elseif self.state == 'hidden' then
		self.color[4] = 0
	elseif self.state == 'fadein' then
		self.color[4] = self.dt * 204
	elseif self.state == 'fadeout' then
		self.color[4] = 204 - 204 * self.dt
	elseif self.state == 'fadeoutbig' then
		self.color[4] = 204 - 204 * self.dt
		self.sx = 50 * self.dt + 50
		self.sy = self.sx
	end
	love.graphics.setColor(self.color)
	love.graphics.draw(img.dot,self.x,self.y,math.pi/4,self.sx,self.sy,0.5,0.5)
	love.graphics.setColor(255,255,255,self.color[4])
	pfn(self.text,self.x-50,self.y-6,100,'center')
end