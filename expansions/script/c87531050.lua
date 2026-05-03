--虚构的天之月
function c87531050.initial_effect(c)
	
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c87531050.lcheck)
end
function c87531050.lcheck(g,lc)
	if #g<2 then return false end
	local c1=g:GetFirst()
	local c2=g:GetNext()
	return c1:GetLinkAttribute()&c2:GetLinkAttribute()>0 or c1:GetLinkRace()&c2:GetLinkRace()>0
end