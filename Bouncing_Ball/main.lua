function love.load()
	love.physics.setMeter(64) -- 1 meter ingame = 64px
	world = love.physics.newWorld(0, 9.81*64, true) -- world in which objects exist (horz grav of 0 and vert grav of 9.81)

objects = {}

objects.ground = {}
objects.ground.body = love.physics.newBody(world, 650/2, 650-50/2) -- the shape we create next anchors from center, thus it has to be moved

objects.ground.shape = love.physics.newRectangleShape(650, 50) --rectangle of w & h stated

objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape) -- apparently, bodies are the things that physics acts on, thus they have to be attatched to bodies

objects.ball = {}

objects.ball.body = love.physics.newBody(world, 650/2, 650/2, "dynamic") --bod in the middle
objects.ball.shape = love.physics.newCircleShape(20) --shape radius, self-explained
objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1)
objects.ball.fixture:setRestitution(0.01) --ball will now bounce, bouncy bouncy bounce


objects.block1 = {}
objects.block1.body = love.physics.newBody(world, 200, 550, "dynamic")
objects.block1.shape = love.physics.newRectangleShape(0, 0, 50, 100)
objects.block1.fixture = love.physics.newFixture(objects.block1.body, objects.block1.shape, 5) -- more density more mass


love.graphics.setBackgroundColor(104, 136, 248) -- color of bg
love.window.setMode(650, 650) -- window dimensions and stuff
end

function love.update(dt)
	world:update(dt) -- updates the world on update method
	local i = 0
	--keyboard events

	if love.keyboard.isDown("right") then
		objects.ball.body:applyForce(400, 0)
	end
	if love.keyboard.isDown("left") then
		objects.ball.body:applyForce(-400, 0)
	end
	if love.keyboard.isDown("up") then
			
		while i < 4 do
			objects.ball.body:applyForce(0, -50)
			i = i + 1
		end
	end
end

function love.draw()
	love.graphics.setColor(72, 160, 14) -- set color green for ground
	love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))  --a polygon is filled using the coords from ground

	love.graphics.setColor(193, 47, 14) -- color for ball
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius()) --A circle is made with the pos and rad of circle

	love.graphics.setColor(50,50,50)
	love.graphics.polygon("fill", objects.block1.body:getWorldPoints(objects.block1.shape:getPoints()))
end


function love.focus(f)
end

function love.quit()
end





















--function love.draw()
--	love.graphics.print("hello World", 300, 400)
--end
