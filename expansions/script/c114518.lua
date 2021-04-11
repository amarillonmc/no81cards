--盲目痴愚之混沌·阿撒托斯
if not pcall(function() require("expansions/script/c114500") end) then require("script/c114500") end
local m,cm = rscf.DefineCard(114518)
function cm.initial_effect(c)
	local e1 = rscf.SetSummonCondition(c,false,aux.FALSE)
	local e2 = rscf.AddSpecialSummonProcdure(c,rsloc.hg,cm.sprcon,nil,cm.sprop)
	local e3 = rsef.STF(c,EVENT_SPSUMMON_SUCCESS,"pos",nil,"pos",nil,nil,nil,rsop.target(Card.IsCanTurnSet,"dpd"),cm.posop)
	local e4 = rsef.STO_Flip(c,"rm",nil,"rm,atk","de",nil,nil,rsop.target(cm.rmfilter,"rm",LOCATION_GRAVE,LOCATION_GRAVE,true),cm.rmop)
	local e5 = rsef.SC_Easy(c,EVENT_FLIP,"cd",nil,cm.regop)
	local e6 = rsef.FV_Card(c,"code",m,aux.TRUE,{rsloc.og,rsloc.og},"sa",LOCATION_MZONE,cm.codecon)
end
function cm.codecon(e,tp)
	return e:GetHandler():GetFlagEffect(m) > 0
end
function cm.regop(e,tp)
	e:GetHandler():RegisterFlagEffect(m,rsrst.std,0,1)
end
function cm.rmcfilter(c,e,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.rmop(e,tp)
	local c = rscf.GetFaceUpSelf(e)
	local g = Duel.GetMatchingGroup(cm.rmcfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if #g <= 0 or Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)<=0 then return end
	local og = Duel.GetOperatedGroup():Filter(cm.afilter,nil)
	if #og <= 0 then return end
	local atk = og:GetSum(Card.GetAttack)
	local def = og:GetSum(Card.GetDefense)
	if c then
		rscf.QuickBuff(c,"atk+",atk+def)
	end
end
function cm.afilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_REMOVED)
end
function cm.posop(e,tp)
	local c = rscf.GetFaceUpSelf(e)
	if c then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
function cm.rmfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_FLIP) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.check(g,tp)
	return g:GetClassCount(Card.GetCode) == #g and Duel.GetMZoneCount(tp,g,tp) > 0
end
function cm.sprcon(e,c,tp)
	local g = Duel.GetMatchingGroup(cm.rmfilter,tp,rsloc.mg,0,c)
	return g:CheckSubGroup(cm.check,5,#g,tp)
end
function cm.sprop(e,tp)
	local g = Duel.GetMatchingGroup(cm.rmfilter,tp,rsloc.mg,0,e:GetHandler())
	rsgf.SelectRemove(g,tp,{aux.TRUE,cm.check},5,#g,nil,{ POS_FACEDOWN,REASON_COST },tp)
end