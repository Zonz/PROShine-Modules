--[[					Timer module - Created by Zonz

-- Creates a new timer with a time of 5 seconds
local myTimer = timer.new(5)

-- Starts the timer
myTimer:start()

if myTimer.done then -- 5 seconds have passed since starting the timer
	myTimer:reset() -- Stops the timer and resets it
end

myTimer:reset(10) -- Stops the timer, resets it, and sets its time to 10 seconds

myTimer:stop() -- Stops the timer, pausing its countdown until start is called again

-- Inline calls are fine
local myTimer = timer.new(5):start()
myTimer:reset():start()

-- "Stopwatch" works too
local stopwatch = timer.new():start()
stopwatch.elapsed -- Amount of time since the stopwatch was started

]]


local timer = {}

local timerProperties = {}

function timerProperties:done()
	if self.seconds <= 0 then
		return true
	elseif not self.started then
		return false
	elseif self.stopped then
		return self.stopTime > self.endTime
	end
	return self.endTime < os.time()
end

function timerProperties:elapsed()
	if not self.started then
		return 0
	elseif self.stopped then
		return math.round(self.stopTime - self.startTime, 2)
	end
	return math.round(os.time() - self.startTime, 2)
end

local timer_meta =
{
	__index = function(self, key)		
		if timerProperties[key] then
			return timerProperties[key](self)
		end
		return timer[key]
	end,
	__newindex = function(self, key, value)
		assert(not timerProperties[key] and not timer[key], "Timer fields are read only. (Tried to set " .. tostring(key) .. " to " .. tostring(value) .. ")")
		rawset(self, key, value)
	end,
}

function timer.new(seconds)
	local new = {}
	new.seconds = seconds or 0
	new.startTime = 0
	new.endTime = 0
	new.stopTime = 0
	new.started = false
	new.stopped = true
	return setmetatable(new, timer_meta)
end

function timer:start()
	if self.started then
		if self.stopped then
			self.startTime = os.time() - self.stopTime + self.startTime
			self.endTime = self.startTime + self.seconds
			self.stopped = false
		end
	else
		self.startTime = os.time()
		self.endTime = self.startTime + self.seconds
		self.started = true
		self.stopped = false
	end
	return self
end

function timer:stop()
	if self.started and not self.stopped then
		self.stopTime = os.time()
		self.stopped = true
	end
	return self
end

function timer:reset(newSeconds)
	self.seconds = newSeconds or self.seconds
	self.started = false
	self.stopped = true
	return self
end

_G.timer = timer

return timer
