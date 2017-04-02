require('camera')
robot = {}
viewport = 0
devtool = 0
moveform = 0 --0 for manual and 1 for auto
seenobs = love.graphics.newImage( "Seenobs.png" )
seenblan = love.graphics.newImage( "Seenblan.png" )

--[[function tilestoobj()
	local x,y = 0,0
	local layer = map.layers["realworld"]
	while x < map.width do
		while y < map.height do
			if not (layer.cells[x][y] == nil) then
			_G[""..x.."&"..y.."body"] = love.physics.newBody(world, x*map.tilewidth, y*map.tileheight, "static")
			_G[""..x.."&"..y.."shape"] = love.physics.newRectangleShape(x*map.tilewidth, y*map.tileheight, map.tilewidth, map.tileheight, 0)
			_G[""..x.."&"..y.."fixture"] = love.physics.newFixture(_G[""..x.."&"..y.."body"], _G[""..x.."&"..y.."shape"], 1)
			end
			y = y + 1
		end
		x = x + 1
	end

end]]



--here begins new code


cfont = love.graphics.newImageFont("Imagefont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")

function gridtotile(x,y)
	nx = math.ceil(x/map.tilewidth)
	ny = math.ceil(y/map.tileheight)
	return nx,ny
end

function tiletonum(x,y)
	num =((y-1)*map.width)+x
	return num
end

function numtotile(num)
	by=math.ceil(num/map.width)
	bx=num-((by-1)*map.width)
	return bx,by
end

function tiletogrid(x,y)
	ax=x*map.tilewidth
	ay=y*map.tilewidth
	return ax,ay
end

function gridtonum(x,y)
	dx,dy = gridtotile(x,y)
	num = tiletonum(dx,dy)
	return num
end

function numtogrid(num)
	qx,qy = numtotile(num)
	jx,jy = tiletogrid(qx,qy)
	return jx+(map.tilewidth/2),jy+(map.tileheight/2)
end

function drawline(table)
	love.graphics.setPointSize(30)
	for i,v in ipairs(table) do
		jx,jy = numtogrid(v)
		love.graphics.point(jx,jy)
	end
end

function numtogoal(num)
	bx,by = numtogrid(num)
	dx = targetx-bx
	dy = targety-by
	return math.sqrt((dx*dx)+(dy*dy))
end

function lowestnumtogoal(table)
	x = 1
	j=1
	while x < #table do
		if numtogoal(table[x]) < numtogoal(table[j]) then
			j = x
		end
		x = x+1
	end 
	return j
end

--here ends new code

function scansurroundfull(layer, name, sx, sy)
					if (layer.cells[sx+1][sy].tileset == name) then
						return sx+1, sy
					elseif (layer.cells[sx+1][sy+1].tileset == name) then
					 	return sx+1, sy+1
					elseif (layer.cells[sx+1][sy-1].tileset == name) then
						return sx+1, sy-1
					elseif (layer.cells[sx][sy+1].tileset == name) then
						return sx,sy+1
					elseif (layer.cells[sx][sy-1].tileset == name) then
						return sx, sy-1
					elseif (layer.cells[sx-1][sy+1].tileset == name) then
						return sx-1, sy+1
					elseif (layer.cells[sx-1][sy-1].tileset == name) then
						return sx-1, sy-1
					elseif (layer.cells[sx-1][sy].tileset == name) then
						return sx-1, sy
					else
						return
					end
end

function scansurroundlite(layer, name, sx, sy)
					if (layer.cells[sx+1][sy].tileset == name) then
						return true
					elseif (layer.cells[sx+1][sy+1].tileset == name) then
					 	return true
					elseif (layer.cells[sx+1][sy-1].tileset == name) then
						return true
					elseif (layer.cells[sx][sy+1].tileset == name) then
						return true
					elseif (layer.cells[sx][sy-1].tileset == name) then
						return true
					elseif (layer.cells[sx-1][sy+1].tileset == name) then
						return true
					elseif (layer.cells[sx-1][sy-1].tileset == name) then
						return true
					elseif (layer.cells[sx-1][sy].tileset == name) then
						return true
					else
						return false
					end
end

function gridcordtotilecord(x,y, opt)
	if opt == nil or not (opt == 1) then opt = 0 end
	nx = math.ceil(x/map.tilewidth)
	ny = math.ceil(y/map.tileheight)
	if opt == 0 then
		return (((ny-1)*map.width)+nx) --a number coressponding to each and every tile
	end
	if opt == 1 then
		return nx, ny
	end 
end

function tilecordtotilenum(x, y)
	return (((y-1)*map.width)+x)
end

function tilenumtotilecord(num)
	ty = math.ceil(num/map.width)
	tx = num-((ty-1)*map.width)
	return tx, ty
end

function tilecoords(tile, layer)
	local x,y = 0,0

	while x < map.width do
		while y < map.height do
			if (layer.cells[x][y] == tile) then
				return ((y*map.width)+x)
			end
			y = y+1
		end
		y = 0
		x = x+1
	end
end
        
function coordstotile(num, layer, opt)
	if opt == nil or not (opt == 1) then opt = 0 end
	local y = math.floor(num/map.width)
	local x = num - (y*map.width)
	producedtile = layer.cells[x][y]
	if opt == 0 then
		return x,y
	end
	if opt == 1 then
		return producedtile
	end	
end

function low()
    local x = 0
    local y = g_score[openset[x]]
    while x < table.getn(openset)-1 do
    	print ("openset:"..x.."")
        x = x+1
        if g_score[openset[x]] < y and not (g_score[openset[x]] == nil) then
            y = g_score[openset[x]]
                lowest = x
            end
            
    end
    return lowest
end

function neighbourset(x,y)
    local mx, my = x-1, y-1
    local q,w = 0,0
    neighbours = {}
    while my < y + 1 do
        while mx < x + 1 do
            local temp = layer.cells[mx][my]
            table.insert(neighbours, temp)
            mx = mx + 1
        end
        mx = x-1
        my = my+1
    end
    return neighbours
end


function nodecalculator()
	local sx,sy = 0,0
	while sx < map.width do
			while sy < map.height do
				if not (scansurround(nodelayercalc, "Seenobs", sx, sy) == nil) then
					local tx,ty = scansurround(nodelayercalc, "Seenobs", sx, sy)

				end
				sy = sy +1
			end
		sy = 0
		sx = sx + 1
	end
end

function inTable(table, item)
    for key, value in pairs(table) do
        if value == item then return true end
    end
    return false
end


function love.load()
	tidal = require 'src'
	love.graphics.setFont(cfont)
	map = assert(tidal.load('map.tmx'))
	ref = assert(tidal.load('ref.tmx'))
	targetset = map.tilesets["Green"]
	layer = map.layers["realworld"]
	reference = ref.layers["Reference"]
	nodelayercalc = map:newTileLayer({
		name = "Calculation layer",
		properties = {considered = 0},
		opacity = 0.4,
		})

	local sx = 0
	local sy = 0
	(function ()
		while sx < map.width do
			while sy < map.height do
				if not (layer.cells[sx][sy] == nil) then
					if layer.cells[sx][sy].tileset.name == "Green" then 
						target = layer.cells[sx][sy]
						print (sx, sy)
						return
					end
				end
				sy = sy +1
			end
			sy = 0
			sx = sx + 1
		end
	end
	)()



		--[[
			target = targetset.tiles[0]
			targetquad = target.quad
			targetx, targety, targetwidth, targetheight = targetquad:getViewport()
			print (targetx, targety, targetwidth, targetheight)
		]]--
	targetx, targety = sx*map.tilewidth + (map.tilewidth/2), sy*map.tileheight + (map.tileheight/2)
	print (targetx, targety)
	scanlayer = map:newTileLayer()
	goaltile = map.layers["realworld"].cells[sx][sy]


	robot.x = 160
	robot.y = 160
	robot.width = 32
	robot.height = 32
	robot.scanradius = 30
--[[
	world = love.physics.newWorld(0, 0, false)

	scanshape = love.physics.newCircleShape(robot.x, robot.y, robot.scanradius)
	scanbody = love.physics.newBody(world, robot.x, robot.y, "dynamic")
	scanfixture = love.physics.newFixture(scanbody, scanshape, 1)

	charshape = love.physics.newRectangleShape(robot.width, robot.height)
	charbody = love.physics.newBody(world, robot.x, robot.y, "dynamic")
	charfixture = love.physics.newFixture(charbody, charshape, 1)
]]
	--tilestoobj()

end

function isscanned()
	local x,y = robot.x - (robot.scanradius/2), robot.y - (robot.scanradius/2)
	local layer = map.layers["realworld"]
	while x < (robot.x + (robot.scanradius/2) + robot.width) do

		while y < (robot.y + (robot.scanradius/2) + robot.height) do
			
				if not (layer.cells[math.floor(x/map.tilewidth)][math.floor(y/map.tileheight)] == nil) then
					scanlayer:setTile(math.floor(x/map.tilewidth), math.floor(y/map.tileheight), layer.cells[math.floor(x/map.tilewidth)][math.floor(y/map.tileheight)])
					nodelayercalc:setTile(math.floor(x/map.tilewidth), math.floor(y/map.tileheight), reference.cells[0][0])
				else
					nodelayercalc:setTile(math.floor(x/map.tilewidth), math.floor(y/map.tileheight), reference.cells[1][0])
				end
			y = y + 20
			--print("y="..y)
		end
		
		x = x + 20
		--print("x="..x)
		y = robot.y - (robot.scanradius/2)
		
	end
end

function drawscanned()
	local x,y = robot.x - (robot.scanradius/2), robot.y - (robot.scanradius/2)
	local layer = map.layers["realworld"]
			love.graphics.setColor(120, 100, 25, 10)
			love.graphics.rectangle("fill", x, y, robot.scanradius + robot.width , robot.scanradius + robot.height)
end

function targetdistance()
	local xd, yd = targetx-robot.x, targety-robot.y
	local d = math.sqrt((xd*xd) + (yd*yd))
	return d
end

function distancefromtarget(sx,sy)
	local dx = targetx - sx
	local dy = targety - sy
	j = math.sqrt((dx*dx)+(dy*dy))
	return j
end

function distancetweentargets(sx, sy, bx, by)
	local dx = sx-bx
	local dy = sy-by
	j = math.sqrt((dx*dx)+(dy*dy))
	return j
end

function movebot(side)
	local mx,my = 0,0
	local layer = map.layers["realworld"]
	if side == "up" then
		my = -map.tileheight
	end
	if side == "down" then
		my = map.tileheight
	end
	if side == "left" then
		mx = -map.tilewidth
	end
	if side == "right" then
		mx = map.tilewidth
	end

	if (layer.cells[math.floor((robot.x + mx)/map.tilewidth)][math.floor((robot.y + my)/map.tileheight)] == nil) and (robot.x + mx > 0) and (robot.y + my > 0) then
		robot.x = robot.x + mx
		robot.y = robot.y + my
	else
		return "collision"
	end

end

function movetowardtarget(dt)
	local layer = map.layers["realworld"]
	local queue = {}
	if moveform == 1 then


		moveform = 0
	end
end


function Astar()
	print ("initialised")
	closed = {}
	open = {}
	start = gridtonum(robot.x, robot.y)
	print ("robotx:", robot.x, "roboty:", robot.y, "tilewidth:", map.tilewidth)
	print(start)
	goal = gridtonum(targetx, targety)
	table.insert(open, start)
	from = {}
	from[start] = nil
	print("loaded")
	noruns = 0
	while not (#open <= 0) do
		noruns = noruns + 1
		print ("runtimes", noruns)
		print("running")
	  	x = open[1]
	  	print("open[1] is ", x)
	  	print("before: ", #open)
	  	print("tilenum", x)
	  currentx,currenty = numtotile(x)
	  print ("generated x:", currentx,"generatedy:", currenty)
		q=0
		i=0
		while q<3 do
			i = 0
			while i<3 do
				--print ("is", tilecordtotilenum(((currentx-1)+i),((currenty-1)+q)), "<=",  (map.width*map.height))
				if (tiletonum(((currentx-1)+i),((currenty-1)+q)) <= (map.width*map.height)) and (tiletonum(((currentx-1)+i),((currenty-1)+q)) >= 0) and (((currentx-1)+i) < map.width) and (((currenty-1)+q) <= map.height) then
					if (layer.cells[(currentx-1)+i][(currenty-1)+q] == nil) then 
						if inTable(open, tiletonum(((currentx-1)+i),((currenty-1)+q))) == false and inTable(closed, tiletonum(((currentx-1)+i),((currenty-1)+q))) == false then
							print ("tilenum:",tiletonum(((currentx-1)+i),((currenty-1)+q)))
							table.insert(open, tiletonum(((currentx-1)+i),((currenty-1)+q)))
							from[tiletonum(((currentx-1)+i),((currenty-1)+q))] = tiletonum(currentx,currenty)
							print ("from value:", from[tiletonum(((currentx-1)+i),((currenty-1)+q))])

							for i,v in ipairs(open) do
								print ("opentable index", i, "value:", v)
							end
						end
					end
				else
					print ("for", tilecordtotilenum(((currentx-1)+i),((currenty-1)+q)), "no!")
				end
				--[[if (layer.cells[(currentx-1)+i][(currenty-1)+q].tileset.name == "Green") then
					from[tilecordtotilenum(((currentx-1)+i),((currenty-1)+q))] = tilecordtotilenum(currentx,currenty)
					break
				end ]]--
				print ("i equals:", i)
				i = i + 1
			end
			q = q + 1
			print ("q equals:", q)
		end
		print ("after: ", #open)
		table.insert(closed, open[1])
		table.remove(open, 1)
end		
	
	for i,v in ipairs(from) do
		print("the value",i,"comes from the value",v)
	end
	print (#from)
end




function Bstar()
	closed = {}
	open = {}
	considered = {}
	start = gridtonum(robot.x, robot.y)
	goal = gridtonum(targetx, targety)
	table.insert(open, start)
	from = {}
	from[start] = nil
	while not (#open <= 0) do
	  	x = open[1]
	  	if x == goal then break end
	  currentx,currenty = numtotile(x)

		q=0
		i=0
		while q<3 do
			i = 0
			while i<3 do
				--print ("is", tilecordtotilenum(((currentx-1)+i),((currenty-1)+q)), "<=",  (map.width*map.height))
				if (tiletonum(((currentx-1)+i),((currenty-1)+q)) <= (map.width*map.height)) and (tiletonum(((currentx-1)+i),((currenty-1)+q)) >= 0) and (((currentx-1)+i) < map.width) and (((currenty-1)+q) <= map.height) then
					if (layer.cells[(currentx-1)+i][(currenty-1)+q] == nil) then 
						if inTable(open, tiletonum(((currentx-1)+i),((currenty-1)+q))) == false and inTable(closed, tiletonum(((currentx-1)+i),((currenty-1)+q))) == false then
							
							table.insert(considered, tiletonum(((currentx-1)+i),((currenty-1)+q)))
							from[tiletonum(((currentx-1)+i),((currenty-1)+q))] = tiletonum(currentx,currenty)
						

							for i,v in ipairs(open) do
								
							end
						end
					end
				else
					
				end
				--[[if (layer.cells[(currentx-1)+i][(currenty-1)+q].tileset.name == "Green") then
					from[tilecordtotilenum(((currentx-1)+i),((currenty-1)+q))] = tilecordtotilenum(currentx,currenty)
					break
				end ]]--
				
				i = i + 1
			end
			q = q + 1	
		end
		table.insert(open, considered[lowestnumtogoal(considered)])
		for k in pairs(considered) do
			considered[k] = nil
		end
		table.insert(closed, open[1])
		table.remove(open, 1)
end		
	
	for i,v in ipairs(from) do
		
	end
	
end





function reconstruct_path(camefrom,current)

end
function love.update(dt)
	isscanned()
	movetowardtarget(dt)

		if love.keyboard.isDown("up") then
			movebot("up")
			
		elseif love.keyboard.isDown("down") then
			movebot("down")
			
		elseif love.keyboard.isDown("left") then
			movebot("left")
			
		elseif love.keyboard.isDown("right") then
			movebot("right")
			
		end


	if love.keyboard.isDown("a") then
		viewport = 1
	elseif love.keyboard.isDown("f") then
		viewport = 2

	else
		viewport = 0
	end

	if love.keyboard.isDown("d") then
		moveform = 1
		Bstar()
	else
		moveform = 0
	end

	scal = 1
	if love.keyboard.isDown("r") then
		scal = scal + 0.1
	end
	if love.keyboard.isDown("t") then
		scal = scal - 0.1	
	end
	openlist = false
	closedlist =false
	draw = false
	if love.keyboard.isDown("h") then
		draw = true
	else
		draw = false
	end

	if love.keyboard.isDown("j") then
		openlist = true
	else
		openlist = false
	end

	if love.keyboard.isDown("k") then
		closedlist = true
	else
		closedlist = false
	end

	if love.keyboard.isDown("s") then
		devtool = 1
		camera:scale(scal,scal)
	else
		devtool = 0
		camera:scale(1,1)
	end

end

function love.draw()
	local layer = map.layers["realworld"]
	
		camera:set()
		camera:setPosition( robot.x - (love.graphics.getWidth()/2), robot.y - (love.graphics.getHeight()/2))
		
		local x,y = 0,0 
	--[[
		while x < map.width do
			while y < map.height do
				if not (layer.cells[x][y] == nil) then
				
					local x1,y1,x2,y2 = _G[""..x.."&"..y.."shape"]:computeAABB(0,0,0,1)
					_G[""..x.."&"..y.."poly"] = love.graphics.polygon("fill", x1, y1, x2, y2)
				end
				y = y + 1
			end
			x = x + 1
		end
	]]
	if viewport == 0 then
		map.layers["realworld"]:draw(0,0)
	elseif viewport == 1 then
		scanlayer:draw(0,0)
	elseif viewport == 2 then
		nodelayercalc:draw(0,0)
	end

	if draw == true then
		love.graphics.setPointSize(10)
		for i,v in ipairs(closed) do
			if not (from[v] == nil)  then
			vx,vy = numtogrid(from[v])
			q = numtogoal(v)
			love.graphics.point(vx,vy)
			love.graphics.print(math.floor(q/10),vx,vy)
			end
		end
	end

	if openlist == true then
		drawline(open)
	end

	if closedlist == true then
		drawline(closed)
	end

	if devtool == 1 then
		drawscanned()
	end

	love.graphics.setColor(255, 200, 100)
		love.graphics.rectangle("fill", robot.x, robot.y, robot.width, robot.height)

		--map.layers["Back"]:draw(0,0)

		camera:unset()

end



function love.quit()

end