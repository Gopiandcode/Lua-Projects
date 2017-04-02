require('camera')
	player = {}
	world = {}
	GAME = 1
function love.load()
	tidal = require 'src'

	placeholder = love.graphics.newImage("SeniorMan.png")

	map = assert(tidal.load('Test.tmx'))

	camera:setBounds(0, 0, map.width * map.tilewidth - love.graphics.getWidth(), map.height * map.tileheight - love.graphics.getHeight())

	
	player.x = 200
	player.y = 1000
	player.xvel = 0
	player.yvel = 1
	player.width = placeholder:getWidth()
	player.height = placeholder:getHeight()
	player.speed = 0.5
	player.friction = 30
	player.airresist = 10
	player.STANDING = false;
	--player.COLLISION = false;

	world.gravity = -1
	foreground = map.layers["Foreground"]

end

function player:iscollision(x,y,tilelayer)
	local layer = map.layers[tilelayer]
	local tx, ty = math.floor(x/map.tilewidth), math.floor(y/map.tileheight)
	local tile = layer.cells[tx][ty]
	return not(tile == nil)

end

function player:checksidecollision(side, offset)
	if side == left then
		i = self.y
		while (i < self.y+self.height-2) do
			if self:iscollision(self.x - offset, i, "Gamelayer") then return true end
			i = i + 1
		end
		return false
	end
	if side == right then
		i = self.y
		while (i < self.y+self.height-2) do
			if self:iscollision(self.x+self.width+offset, i, "Gamelayer") then 
				print("collision right") 
				return true 
			end
			i = i + 1
		end
		return false
	end
	if side == top then
		i = self.x
		while ( i < self.x+self.width) do
			if self:iscollision(i, self.y-offset, "Gamelayer") then return true end
			i = i + 1
		end
		return false
	end
	if side == bottom then
				i = self.x
		while ( i < self.x+self.width) do
			if self:iscollision(i, self.y+self.height+offset, "Gamelayer") then return true end
			i = i + 1
		end
		return false
	end
end

function player:update(dt)
	--player position
	if player.x < 5 then
		player.x = 5
	end
	if player.xvel < 0 then
		if (not self:checksidecollision(left, 0) == true) then
			if (player.x > 5) then
				player.x = player.x + player.xvel
			end
		end
	end
	if player.xvel > 0 then
		if (not self:checksidecollision(right, 0) == true) then
			player.x = player.x + player.xvel
		end
	end
	player.xvel = player.xvel * (1-(1/self.friction))
	if player.STANDING == false then
		player.y = player.y + player.yvel
		
		player.yvel = player.yvel - world.gravity

	end
	--collision detection
	player:topleftcol()
	player:toprightcol()
	player:bottomleftcol()
	player:bottomrightcol()
	player:floored()
	--collission resolution

	--input
	if love.keyboard.isDown("left") then
		--if (not self:checksidecollision(left, 1) == true) then
			if player.STANDING then
				player.xvel = player.xvel - player.speed
			else
				player.xvel = player.xvel - player.speed*0.6
			end
		--end
	end

	if love.keyboard.isDown("right") then
		--if (not self:checksidecollision(right, 1) == true) then
			if player.STANDING then
				player.xvel = player.xvel + player.speed
			else
				player.xvel = player.xvel + player.speed*0.6
			end
		--end
	end

	if love.keyboard.isDown("up") then
		player:jump(10)
	end

	if love.keyboard.isDown("down") then
	end
end

function player:topleftcol()
	if self:iscollision(self.x,self.y, "Gamelayer") then
		self.xvel = 0
		while self:iscollision(self.x,self.y, "Gamelayer") do
			self.x = self.x + 1
		end
		print("collision! tl")
		return true
	else
		print("no collision! tl")
		return false
	end
end

function player:toprightcol()
	if self:iscollision(self.x + self.width,self.y, "Gamelayer") then
		self.xvel = 0
		while self:iscollision(self.x + self.width,self.y, "Gamelayer") do
			self.x = self.x - 1
		end
		print("collision! tr")
		return true
	else
		print("no collision! tr")
		return false
	end
end

function player:bottomleftcol()
	if self:iscollision(self.x,self.y+self.height, "Gamelayer") then
		while self.y > (self.y-self.yvel) do
			self.y = self.y - 1
			if (not self:iscollision(self.x,self.y+self.height, "Gamelayer")) then break end
		end
		self.yvel = 0
		self.STANDING = true
		while self.x < self.x+self.xvel do
			self.x = self.x + 1
			if (not self:iscollision(self.x,self.y+self.height, "Gamelayer")) then break end
		end
		--self.xvel = 0
		print("collision! bl")
		return true
	else
		print("no collision! bl")
		return false
	end
end


function player:bottomrightcol()
	if self:iscollision(self.x+self.width,self.y+self.height, "Gamelayer") then
		while self.y > (self.y-self.yvel) do
			self.y = self.y - 1
			if (not self:iscollision(self.x+self.width,self.y+self.height, "Gamelayer")) then break end
		end
		self.yvel = 0
		self.STANDING = true
		while self.x > self.x-self.xvel do
			self.x = self.x - 1
			if (not self:iscollision(self.x+self.width,self.y+self.height, "Gamelayer")) then break end
		end
		--self.xvel = 0
		print("collision! br")
		return true
	else
		print("no collision! br")
		return false
	end
end

function player:floored()
	if (not self:iscollision(self.x+self.width,self.y+self.height+2, "Gamelayer")) and (not self:iscollision(self.x,self.y+self.height+2, "Gamelayer")) then
		player.STANDING = false
	else
		player.STANDING = true
	end
end

function player:jump(force)
	if self.STANDING then
		player.yvel = player.yvel + (force*world.gravity)
		print ("jumping")
		player.STANDING = false
	else
		print ("not jumping")
		return
	end

end



function love.update(dt)
	player:update(dt)
	camera:setPosition( player.x - (love.graphics.getWidth()/2), player.y - (love.graphics.getHeight()/2))
	map:update(dt)
	print("PlayerX coords",math.floor(player.x/map.tilewidth),"PlayerY coords",math.floor(player.y/map.tileheight))
end

function love.draw()
	if GAME == 1 then
		camera:set()
		map.layers["Sky"]:draw(0,0)
		map.layers["Background"]:draw ((0-(player.x/20)), (0))
		map.layers["Staticobj"]:draw(0,0)
		map.layers["Gamelayer"]:draw(0,0)
		love.graphics.draw(placeholder, player.x, player.y)
		foreground:draw ((0-(player.x/40)), (0+(player.y/40)))
		camera:unset()
	end
end
