--方舟骑士-暴行
function c29065527.initial_effect(c)
	c:SetSPSummonOnce(29065527)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c29065527.matfilter,1,1)
end
function c29065527.matfilter(c)
	return c:IsLinkSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)
end