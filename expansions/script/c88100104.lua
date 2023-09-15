--逻辑蓝莓
function c88100104.initial_effect(c)
	aux.AddLinkProcedure(c,c88100104.mfilter,2,2,c88100104.lcheck)
	c:EnableReviveLimit()
end
function c88100104.mfilter(c)
	return c:IsLevelAbove(1)
end
function c88100104.lcheck(g,lc)
	return g:GetClassCount(Card.GetLevel)==1
end