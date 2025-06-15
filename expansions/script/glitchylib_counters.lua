--Library for Counter mods
if GLITCHYLIB_COUNTERS then return end

GLITCHYLIB_COUNTERS = true

FLAG_HAD_COUNTER_GLITCHY = 33720395

local _AddCounter = Card.AddCounter

function Card.AddCounter(c,ctype,ct,...)
	if not c:HasFlagEffectLabel(FLAG_HAD_COUNTER_GLITCHY,ctype) then
		c:RegisterFlagEffect(FLAG_HAD_COUNTER_GLITCHY,RESET_EVENT|RESETS_STANDARD,0,1,ctype)
	end
	return _AddCounter(c,ctype,ct,...)
end