--黑天蓝莓
function c88100103.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c,c88100103.mfilter,c88100103.xyzcheck,2,2)
	c:EnableReviveLimit()
end
function c88100103.mfilter(c,xyzc)
	return c:IsLevelAbove(1)
end
function c88100103.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end