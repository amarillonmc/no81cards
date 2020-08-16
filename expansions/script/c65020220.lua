--天知骑士王 三叉戟海王
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(65020220,"TianZhi")
function cm.initial_effect(c)
	c:EnableReviveLimit(c)
	aux.AddFusionProcCodeFun(c,65010558,cm.fusfilter,1,true,true)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"dr,td","de,dsp",rscon.sumtype("fus"),nil,rsop.target(cm.drfun,"dr"),cm.drop)
	local e2=rsef.QO(c,nil,{m,1},{1,m+100},"dis",nil,LOCATION_MZONE,nil,rscost.cost(cm.rmfilter,"rm",LOCATION_GRAVE),rsop.target(aux.disfilter1,"dis",LOCATION_ONFIELD,LOCATION_ONFIELD),cm.disop)
end
function cm.fusfilter(c,fc)
	return c:IsLevelAbove(5) and c:IsRace(RACE_SEASERPENT)
end
function cm.drfun(e,tp)
	return Duel.GetMatchingGroupCount(Card.IsSummonType,tp,0,LOCATION_MZONE,nil,SUMMON_TYPE_SPECIAL)+1
end
function cm.drop(e,tp)
	local ct=Duel.GetMatchingGroupCount(Card.IsSummonType,tp,0,LOCATION_MZONE,nil,SUMMON_TYPE_SPECIAL)
	if Duel.Draw(tp,ct+1,REASON_EFFECT)==0 then return end
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,ct,ct,nil)
	if ct>0 then
		Duel.BreakEffect()
		if #g>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end 
end
function cm.rmfilter(c)
	return c:IsAbleToRemoveAsCost() and (c:IsType(TYPE_MONSTER) or c:CheckSetCard("TianZhi"))
end
function cm.disop(e,tp)
	rsop.SelectSolve(rshint.dis,tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cm.disfun,e,tp)
end
function cm.disfun(g,e,tp)
	local tc=g:GetFirst()
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1,e2=rscf.QuickBuff({c,tc},"dis,dise")
end