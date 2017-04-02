camera = {}
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0
scenes = {}
scenes.img = love.graphics.newImage("enemy.jpg")
scenes.img.scale = 1




function camera:set()
	love.graphics.push() --pushes the camera on the draw stack
	love.graphics.rotate(-self.rotation) --rotates the image
	love.graphics.scale(1/self.scaleX, 1/self.scaleY) --scales it
	love.graphics.translate(-self.x, -self.y) -- do I really need to say it?
end

function camera:unset()
	love.graphics.pop()
end

function camera:move(dx, dy)
	self.x = self.x + (dx or 0)
	self.y = self.y + (dy or 0)
end

function camera:rotate(dr)
	self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
	sx = sx or 1
	self.scaleX = self.scaleX * sx
	self.scaleY = self.scaleY * (sy or sx)
end

function camera:setPosition(x, y)
	self.x = x or self.x
	self.y = y or self.y
end

function camera:setScale(sx, sy)
	self.scaleX = sx or self.scaleX
	self.scaleY = sy or self.scaleY
end


function camera:newLayer(scale, func)
	table.insert(self.layers, {draw = func, scale = scale})
	table.sort(self.layers, function(a, b) return a.scale < b.scale end)
end

function camera:draw()
	local bx, by = self.x, self.y

	for _, v in ipairs(self.layers) do
		self.x = bx * v.scale
		self.y = by * v.scale
		camera:set()
		v.draw()
		camera:unset()
	end
end



function love.load()
	camera.layers = {}
	objects = {}
	--camera code
	camera:newLayer(i, function()
		for _, v in ipairs(scenes) do
			love.graphics.draw(v, 100, 100)
		end
	end)

	love.window.setMode(640, 640) -- window dimensions and stuff
end





function love.update(dt)
	
	
	--keyboard events

	if love.keyboard.isDown("right") then
		camera:move(1, 0)
		
	end
	if love.keyboard.isDown("left") then
		camera:move(-1, 0)
	end
	if love.keyboard.isDown("up") then
		camera:move(0, 1)
	end

end

function love.draw()
	camera:draw()
end


function love.focus(f)
end

function love.quit()
end





















--function love.draw()
--	love.graphics.print("hello World", 300, 400)
--end
