--蚀刻的黑骑士 妮可莉那
function c64800147.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64800147,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,64800147)
	e1:SetCost(c64800147.cost)
	e1:SetTarget(c64800147.target)
	e1:SetOperation(c64800147.operation)
	c:RegisterEffect(e1)
end

function c64800147.cfilter0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp)
end
function c64800147.cfilter1(c)
	return c:IsAbleToRemoveAsCost()
end
function c64800147.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64800147.cfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c64800147.cfilter1,tp,LOCATION_GRAVE,0,1,2,nil,tp)
	e:SetLabel(g1:GetCount())
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c64800147.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local gc=Duel.GetMatchingGroupCount(c64800147.cfilter0,tp,LOCATION_GRAVE,LOCATION_GRAVE+LOCATION_REMOVED,nil,e,tp)
	local gf=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if chk==0 then return gc>0 and gf>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c64800147.operation(e,tp,eg,ep,ev,re,r,rp)
	local spc=e:GetLabel()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then spc=1 end
	local gc=Duel.GetMatchingGroupCount(c64800147.cfilter0,tp,LOCATION_GRAVE,LOCATION_GRAVE+LOCATION_REMOVED,nil,e,tp)
	local gf=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if gc>gf then gc=gf end
	if gc>spc then gc=spc end
	if gc==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c64800147.cfilter0,tp,LOCATION_GRAVE,LOCATION_GRAVE+LOCATION_REMOVED,1,gc,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE) and Duel.SelectYesNo(tp,aux.Stringid(64800147,1)) then
			local tdg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g:GetCount(),nil)
			if tdg:GetCount()>0 then
				Duel.HintSelection(tdg)
				Duel.SendtoDeck(tdg,nil,2,REASON_EFFECT)
			end
		end
	end
end