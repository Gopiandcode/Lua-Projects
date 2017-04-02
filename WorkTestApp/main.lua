UI = require 'ui/UI'
Theme = require 'Theme'

function love.load()
	image = love.graphics.newImage("Glogo.png")
	start = UI.Button(10,10, 300,90, {extensions = {Theme.Button}, {draggable = true}})
	shownext = UI.Button(10,110, 300,90, {extensions = {Theme.Shownext}, {draggable = true}})
	show = UI.Button(10,210, 300,90, {extensions = {Theme.Show}, {draggable = true}})
	questions = {}
	answers = {}
	for line in love.filesystem.lines("QUESTIONS.txt") do
		for name,data in line:gmatch("(.-):(.*)") do
			if name == "questions" then
				table.insert(questions, data)
			end
			if name == "answers" then
				table.insert(answers, data)
			end
		end
	end
	starton = false
	answershow = false
	no = 1
end



function love.update(dt)
	start:update(dt)
	shownext:update(dt)
	show:update(dt)
	--if button.enter then button:press() end

	if start.pressed then
		--launch stuff
		for i,v in ipairs(questions) do
			print (v)
		end
		print("*click*")
		starton = true
		no = 1
	end

	if shownext.pressed then
		starton = true
		if no < table.getn(questions) then
			no = no + 1
		else 
			no = 1
		end
		answershow = false
	end

	if show.pressed then
		answershow = true
		if answers[no] == (nil) then
			answershow = false
		end
	end

end

function love.draw()
	love.graphics.setColor(79, 79, 79)
	love.graphics.rectangle('fill', 0, 0, 800, 800)
	UI.registerEvents()
	Theme.Button.draw(start)
	Theme.Shownext.draw(shownext)
	Theme.Show.draw(show)
	love.graphics.setColor(121, 123, 123)
	love.graphics.rectangle('fill', 320, 10, 468, 290)
	love.graphics.rectangle('fill', 320, 310, 468, 280)
	if starton == true then
		love.graphics.setColor(33, 105, 37)
		love.graphics.printf(questions[no], 320, 10, 468, 'left')
	end
	if answershow == true then
		love.graphics.setColor(33, 105, 37)
		love.graphics.printf(answers[no], 320, 310, 468, 'left')
	end
	love.graphics.setColor(225, 225, 225)
	love.graphics.draw(image, 5, 310, 0, 0.38, 0.35)
end