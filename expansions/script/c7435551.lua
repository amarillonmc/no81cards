--叛骨装剑 盖加斯瓦尔格尔
local s,id,o=GetID()
--string
s.named_with_Rebellion_Skull=1
--s.named_with_Skullize=1
--SETCARD_REBELLION_SKULL =0xdce
--SETCARD_SKULLIZE =0xdce
--string check
function s.Rebellion_Skull(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Rebellion_Skull) or (SETCARD_REBELLION_SKULL and c:IsSetCard(SETCARD_REBELLION_SKULL))
end
function s.Skullize(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Skullize) or (SETCARD_SKULLIZE and c:IsSetCard(SETCARD_SKULLIZE))
end
--
function s.initial_effect(c)
	aux.AddCodeList(c,7435503)
end
