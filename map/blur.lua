

Blureffect = {dt=0,time=0,on=false}
local blurbuffer = {}
for i=1,5 do
	table.insert(blurbuffer,love.graphics.newFramebuffer())
end

local index = 1
local count = 5
function Blureffect.blur(style,arg,interval,time)
	Blureffect.style = style
	Blureffect.arg = arg
	Blureffect.dt = 0
	Blureffect.time = time
	Blureffect.interval = interval
	Blureffect.on = true
	count = 5
end

function Blureffect.begin()
	if not Blureffect.on then return end
	love.graphics.setRenderTarget(blurbuffer[index])
	love.graphics.setBackgroundColor(0,0,0,255)
	love.graphics.clear()
end

function Blureffect.update(dt)
	if not Blureffect.on then return end
	Blureffect.dt = Blureffect.dt + dt
	if Blureffect.dt>Blureffect.time then
		Blureffect.on = false
	end
		if Blureffect.interval == 0 then
		
			index = (index)%5+1
			count = math.min(5,math.ceil((Blureffect.time-Blureffect.dt)*10))
			index = math.min(index,count)
		else
		index = (math.floor(Blureffect.dt/Blureffect.interval))%5+1
		count = math.min(5,math.ceil((Blureffect.time-Blureffect.dt)*10))
		index = math.min(index,count)
	end
end

function Blureffect.finish()
	if not Blureffect.on then return end
	love.graphics.setRenderTarget()
	love.graphics.setColor(255,255,255,280-35*count)
	if Blureffect.style == 'zoom' then
		local scalefactor = 2
		for i = index+1,count do
			love.graphics.draw(blurbuffer[i],screen.halfwidth,screen.halfheight,0,scalefactor,scalefactor,screen.halfwidth,screen.halfheight)
			scalefactor = scalefactor - 0.2
		end
		for i = 1,index-1 do
			love.graphics.draw(blurbuffer[i],screen.halfwidth,screen.halfheight,0,scalefactor,scalefactor,screen.halfwidth,screen.halfheight)
			scalefactor = scalefactor - 0.2
		end
	elseif Blureffect.style == 'motion' then
		for i = index+1,count do
			love.graphics.draw(blurbuffer[i])
		end
		for i = 1,index-1 do
			love.graphics.draw(blurbuffer[i])
		end
	end
	love.graphics.draw(blurbuffer[index])
	

end