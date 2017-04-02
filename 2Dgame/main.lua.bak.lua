require('camera')
	player = {}
function love.load()
	tidal = require 'src'

	placeholder = love.graphics.newImage("enemy.jpg")


	map = assert(tidal.load('Test.tmx'))




	camera:setBounds(0, 0, map.width * map.tilewidth - love.graphics.getWidth(), map.height * map.tileheight - love.graphics.getHeight())

	
	player.x = 0
	player.y = 0
	player.xvel = 0
	player.yvel = 0
	player.width = placeholder:getWidth()
	player.height = placeholder:getHeight()
	player.speed = 10
	player.friction = 50
	player.airresist = 10
	player.STANDING = false;
	player.COLLISION = false;

	world = {

		gravity = 2
	}

end


function player:update(dt)
	if player.x > map.tilewidth * map.width then
		player.x = (map.tilewidth * map.width)
		player.xvel = 0
	end
	if player.x < 0 then
		player.x = 0
		player.xvel = 0
	end
	if player.y > map.tileheight * map.height then
		player.y = (map.tileheight * map.height)
		player.yvel = 0
	end
	if player.y < 0 then
		player.y = 0
		player.yvel =0
	end
	local testx, testy = self.x, self.y
	while testx + testy < self.x + self.y + math.abs(self.xvel) +  math.abs(self.yvel) do
		player:iscollision(testx, testy, "Gamelayer")
		if self.COLLISION then
			self.y = self.y - self.yvel
			--self.x = self.x - self.xvel
			--self.xvel = 0
			self.yvel = 0
			self.STANDING = true
			return
		end
		testx = testx + 1
		testy = testy + 1
	end
		self.y = self.y + self.yvel
		self.x = self.x + self.xvel
	if self.STANDING then
		self.xvel = self.xvel * (1-(1/self.friction))
	elseif not self.STANDING then
		self.yvel = self.yvel + world.gravity
		self.xvel = self.xvel * (1-(1/self.airresist))
	end
end

function player:jump(force)
	self.yvel = self.yvel + self.speed*force
	self.STANDING = false
end

function player:iscollision(x,y,tilelayer)
	local layer = map.layers[tilelayer]
	local tx, ty = math.floor(x/map.tilewidth), math.floor(y/map.tileheight)
	local tile = layer.cells[tx][ty]
	if (tile == nil) then 
		self.COLLISION = false
	elseif not (tile == nil) then
		self.COLLISION = true
	end
end

function love.update(dt)
	player:update(dt)
	if love.keyboard.isDown("left") then
		if not (player.x >  map.width * map.tilewidth -780) then
			if not (player.x < 0) then
				player.xvel = player.xvel + 1
			end
		end
	end

	if love.keyboard.isDown("right") then
		if not (player.x > map.tilewidth * map.width) then
			if not (player.x < 0) then
				player.xvel = player.xvel - 1
			end
		end
	end

	if love.keyboard.isDown("up") then
		if player.STANDING then
			player:jump(1)
		end
	end

	if love.keyboard.isDown("down") then

	end
	camera:setPosition( player.x - (love.graphics.getWidth()/2), player.y - (love.graphics.getHeight()/2))
	map:update(dt)
	print(player.y - (love.graphics.getHeight()/2))
	print("PlayerX coords",math.floor(player.x/map.tilewidth),"PlayerY coords",math.floor(player.y/map.tileheight))

end

function love.draw()
	camera:set()

	map:draw(0,0)
	love.graphics.draw(placeholder, player.x, player.y)



	camera:unset()

end
