--肉盾型异生兽 古兰特拉
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000042)
function cm.initial_effect(c)
	rssb.SummonCondition(c) 
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_HAND,rscon.excard(Card.IsFacedown,LOCATION_REMOVED,0,5),nil,rssb.sstg,rssb.ssop)
	local e2=rsef.FV_CANNOT_BE_TARGET(c,"effect",aux.tgoval,cm.tg,{LOCATION_MZONE,0})
end
function cm.tg(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND+RACE_WARRIOR)
end
