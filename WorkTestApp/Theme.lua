local Theme = {}

Theme.Button = {}
Theme.Button.draw = function(self)
	love.graphics.setColor(64, 64, 64)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	love.graphics.setColor(122, 133, 54)
	love.graphics.setNewFont(43)
	love.graphics.printf("Click to start", (self.x+(0.025*self.w)), (self.y+(0.25*self.h)), self.w, "left")
	if self.down then
		love.graphics.setColor(32, 32, 32)
		love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
		love.graphics.setColor(64, 87, 24)
		love.graphics.setNewFont(43)
		love.graphics.printf("Click to start", (self.x+(0.025*self.w)), (self.y+(0.25*self.h)), self.w, "left")
	end
	love.graphics.setColor(255, 255, 255)
end

Theme.Shownext = {}
Theme.Shownext.draw = function(self)
	love.graphics.setColor(64, 64, 64)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	love.graphics.setColor(122, 133, 54)
	love.graphics.setNewFont(30)
	love.graphics.printf("Click to show next", (self.x+(0.025*self.w)), (self.y+(0.25*self.h)), self.w, "left")
	if self.down then
		love.graphics.setColor(32, 32, 32)
		love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
		love.graphics.setColor(64, 87, 24)
		love.graphics.setNewFont(30)
		love.graphics.printf("Click to show next", (self.x+(0.025*self.w)), (self.y+(0.25*self.h)), self.w, "left")
	end
	love.graphics.setColor(255, 255, 255)
end

Theme.Show = {}
Theme.Show.draw = function(self)
	love.graphics.setColor(64, 64, 64)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	love.graphics.setColor(122, 133, 54)
	love.graphics.setNewFont(27)
	love.graphics.printf("Click to show answer", (self.x+(0.025*self.w)), (self.y+(0.35*self.h)), self.w, "left")
	if self.down then
		love.graphics.setColor(32, 32, 32)
		love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
		love.graphics.setColor(64, 87, 24)
		love.graphics.setNewFont(27)
		love.graphics.printf("Click to show answer", (self.x+(0.025*self.w)), (self.y+(0.35*self.h)), self.w, "left")
	end
	love.graphics.setColor(255, 255, 255)
end


return Theme