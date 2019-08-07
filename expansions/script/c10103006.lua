--界限龙王 蒂雅玛特
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10103006
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"rm,dr","tg,de",nil,nil,rstg.target2(cm.fun,Card.IsAbleToRemove,"rm",LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE),cm.rmop)
	local e2=rsef.FTO(c,EVENT_PHASE+PHASE_STANDBY,{m,1},{1,m+100},"sp,rm,ga",nil,LOCATION_MZONE,nil,nil,nil,cm.effop)
end
function cm.effop(e,tp)
	local e1=rsef.FC({e:GetHandler(),tp},EVENT_PHASE+PHASE_STANDBY,{m,3},1)
	rsef.RegisterSolve(e1,cm.effcon,nil,nil,cm.effop2)
	e1:SetLabel(Duel.GetTurnCount())
end
function cm.effcon(e,tp)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if Duel.GetTurnCount()==e:GetLabel() then return false end
	if (b1 or b2) then return true
	else 
		e:Reset()
		return false
	end
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.effop2(e,tp)
	Duel.Hint(HINT_CARD,0,m)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local op=rsof.SelectOption(tp,b1,{m,4},b2,{m,5})
	if op==1 then
		rsof.SelectHint(tp,"rm")
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	elseif op==2 then
		rsof.SelectHint(tp,"sp")
		local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.HintSelection(sg) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	e:Reset()
end
function cm.fun(g,e,tp)
	if g:GetFirst():IsFaceup() and g:GetFirst():IsSetCard(0x337) then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function cm.rmop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_REMOVED) and tc:IsSetCard(0x337) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end