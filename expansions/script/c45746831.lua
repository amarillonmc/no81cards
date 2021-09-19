--营地的厨师 图坦卡蒙
function c45746831.initial_effect(c)
--link summon
	aux.AddLinkProcedure(c,c45746831.mfilter,1,1)
	c:EnableReviveLimit()
end
function c45746831.mfilter(c)
	return c:IsLinkSetCard(0x88e)
end