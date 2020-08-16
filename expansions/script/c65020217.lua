--「触及梦想的瞬间」户山香澄
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(65020217)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,5,false)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())
end