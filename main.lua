function getColor()
	return love.math.random(221), love.math.random(221), love.math.random(221)
end

function lerp(from, to, t)
	return from + math.max(0, math.min(t, 1)) * (to - from)
end

local width, height = 800, 600
local defaultTimer = 5
local timeRemaining = defaultTimer
local r, g, b = getColor()
local nr, ng, nb = getColor()
local chordsBackground
local chordsOffset = 50
local chordsFont
local chordName
local chordIndex

-- CHORDS

local Chord = {}
Chord.__index = Chord

function Chord.new(name, fingers, down)
	local new = {
		name = name,
		down = down,
		fingers = fingers
	}
	setmetatable(new, Chord)
	return new
end

Chord.draw = function (self)
	local chordsWidth = chordsBackground:getWidth()
	local chordsHeight = chordsBackground:getHeight()

	chordName:set(self.name)
	love.graphics.draw(chordName, width * 0.5, height * 0.5, 0, 1, 1, chordName:getWidth() * 0.5, chordsHeight * 0.5 - chordsOffset + 100)

	if self.down then
		chordName:set(self.down)
		love.graphics.draw(chordName, width * 0.5, height * 0.5, 0, 1, 1, chordName:getWidth() * 0.5 + 50, chordsHeight * 0.5 - chordsOffset + chordsHeight / 5 * 1.5)
	end

	for _, finger in ipairs(self.fingers) do
		local x = width * 0.5 - chordsWidth * 0.5 + finger[2] * (chordsWidth / 3)
		x = finger[2] == 0 and x + 5 or (finger[2] == 3 and x - 4 or x) -- adjust x if the finger should be placed on the first or last chord
		local y = height * 0.5 - chordsHeight * 0.5 + chordsOffset + finger[1] * chordsHeight / 5 + chordsHeight / 5 * 0.5
		love.graphics.circle('fill', x, y, 20, 100)
	end
end

local chords = {}

-- END CHORDS

function love.load()
	love.math.setRandomSeed(love.timer.getTime())

	love.window.setMode(width,height)
	love.graphics.setBackgroundColor(r, g, b)

	chordsBackground = love.graphics.newImage('chords.png')
	chordsFont = love.graphics.newFont('Opificio.ttf', 46)
	chordName = love.graphics.newText(chordsFont, '')

	-- yes, it's hard coded. Is that a problem?
	table.insert(chords, Chord.new('A', {{0, 1}, {1, 0}}))
	table.insert(chords, Chord.new('A7', {{0, 1}}))
	table.insert(chords, Chord.new('A7sus4', {{1, 1}}))
	table.insert(chords, Chord.new('Am', {{1, 0}}))
	table.insert(chords, Chord.new('Am5', {{1, 0}, {1, 2}, {2, 3}}))
	table.insert(chords, Chord.new('Am/C', {{1, 0}, {2, 3}}))
	table.insert(chords, Chord.new('Am7', {{2, 2}, {2, 3}, {3, 1}}))
	table.insert(chords, Chord.new('Asus4', {{1, 0}, {1, 1}}))
	table.insert(chords, Chord.new('B', {{1, 2}, {1, 3}, {2, 1}, {3, 0}}))
	table.insert(chords, Chord.new('B7', {{1, 0}, {1, 2}, {1, 3}, {2, 1}}))
	table.insert(chords, Chord.new('Bb', {{0, 2}, {0, 3}, {1, 1}, {2, 0}}))
	table.insert(chords, Chord.new('Bbm', {{0, 0}, {0, 1}, {0, 2}, {0, 3}, {2, 0}}))
	table.insert(chords, Chord.new('Bm', {{1, 0}, {1, 1}, {1, 2}, {1, 3}, {3, 0}}))
	table.insert(chords, Chord.new('Bm7', {{1, 0}, {1, 1}, {1, 2}, {1, 3}}))
	table.insert(chords, Chord.new('C', {{2, 3}}))
	table.insert(chords, Chord.new('C+', {{0, 0}, {2, 3}}))
	table.insert(chords, Chord.new('C#7', {{0, 0}, {0, 1}, {0, 2}, {1, 3}}))
	table.insert(chords, Chord.new('C#m7', {{0, 0}, {0, 1}, {1, 3}}))
	table.insert(chords, Chord.new('C7', {{0, 3}}))
	table.insert(chords, Chord.new('Cm', {{2, 1}, {2, 2}, {2, 3}}))
	table.insert(chords, Chord.new('Cmaj7', {{1, 3}}))
	table.insert(chords, Chord.new('Csus4', {{0, 2}, {2, 3}}))
	table.insert(chords, Chord.new('D', {{1, 0}, {1, 1}, {1, 2}, {4, 3}}))
	table.insert(chords, Chord.new('D#', {{1, 0}, {1, 1}, {1, 2}, {4, 3}}, 3))
	table.insert(chords, Chord.new('D7', {{1, 0}, {1, 1}, {1, 2}, {2, 3}}))
	table.insert(chords, Chord.new('Dm', {{0, 2}, {1, 0}, {1, 1}}))
	table.insert(chords, Chord.new('E', {{1, 0}, {1, 1}, {1, 2}, {4, 3}}, 4))
	table.insert(chords, Chord.new('E7', {{0, 0}, {1, 1}, {1, 3}}))
	table.insert(chords, Chord.new('Ebdim', {{1, 0}, {1, 2}, {2, 1}, {2, 3}}))
	table.insert(chords, Chord.new('Em', {{1, 3}, {2, 2}, {3, 1}}))
	table.insert(chords, Chord.new('Em7', {{1, 1}, {1, 3}}))
	table.insert(chords, Chord.new('F', {{0, 2}, {1, 0}}))
	table.insert(chords, Chord.new('F/C', {{0, 2}, {1, 0}, {2, 3}}))
	table.insert(chords, Chord.new('F#', {{0, 0}, {0, 1}, {0, 2}, {0, 3}, {1, 2}, {2, 0}}))
	table.insert(chords, Chord.new('F#dim7', {{1, 0}, {1, 2}, {2, 1}}))
	table.insert(chords, Chord.new('F#m', {{0, 1}, {1, 0}, {1, 2}}))
	table.insert(chords, Chord.new('Fm', {{0, 0}, {0, 2}, {2, 3}}))
	table.insert(chords, Chord.new('Fmaj7', {{0, 2}, {1, 0}, {3, 1}}))
	table.insert(chords, Chord.new('Fsus2', {{0, 2}}))
	table.insert(chords, Chord.new('G', {{1, 1}, {1, 3}, {2, 2}}))
	table.insert(chords, Chord.new('G#', {{2, 0}, {2, 1}, {2, 2}, {2, 3}, {3, 2}, {4, 0}}))
	table.insert(chords, Chord.new('G#m', {{0, 0}, {0, 1}, {0, 2}, {0, 3}, {1, 3}, {2, 1}, {3, 2}}))
	table.insert(chords, Chord.new('G5', {{0, 1}, {1, 3}, {2, 2}}))
	table.insert(chords, Chord.new('G7', {{0, 2}, {1, 1}, {1, 3}}))
	table.insert(chords, Chord.new('Gadd9', {{1, 1}}))
	table.insert(chords, Chord.new('Gm', {{0, 3}, {1, 1}, {2, 2}}))
	table.insert(chords, Chord.new('Gsus4', {{1, 1}, {1, 3}, {2, 2}, {2, 3}}))

	chordIndex = love.math.random(#chords)
end

function love.update()
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

	timeRemaining = timeRemaining - love.timer.getDelta()
	
	if timeRemaining <= 1 then
		timeRemaining = math.max(0, timeRemaining)
		love.graphics.setBackgroundColor(lerp(nr, r, timeRemaining),
										 lerp(ng, g, timeRemaining),
										 lerp(nb, b, timeRemaining))
		
		if timeRemaining == 0 then
			timeRemaining = defaultTimer
			r, g, b, nr, ng, nb = nr, ng, nb, getColor()
			chordIndex = love.math.random(#chords)
		end
	end
end

function love.draw()
	local w, h = chordsBackground:getWidth(), chordsBackground:getHeight()
	love.graphics.draw(chordsBackground,
					   width * 0.5,
					   height * 0.5,
					   0, 1, 1,
					   w * 0.5,
					   h * 0.5 - chordsOffset)

	chords[chordIndex]:draw()
end