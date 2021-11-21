--异端剿灭
if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rk.set(16104224)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"des",nil,cm.con,nil,rsop.target(cm.desfilter,"des",0,LOCATION_ONFIELD,true),cm.act)
end
function cm.cfilter1(c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x3ccd) and c:IsFaceup()
end
function cm.cfilter2(c)
	return c:IsFaceup() and not c:IsRace(RACE_WARRIOR)
end 
function cm.con(e,tp)
	return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function cm.desfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_WARRIOR)
end
function cm.act(e,tp)
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end