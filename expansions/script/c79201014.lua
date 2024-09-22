--星钢羽蛇
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,s.synfilter,aux.NonTuner(s.synfilter),1)
	c:EnableReviveLimit()
	--td
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--re
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.remcost)
	e2:SetTarget(s.remtg)
	e2:SetOperation(s.remop)
	c:RegisterEffect(e2)
end
function s.synfilter(c,e,tp)
	return c:IsSetCard(0x10e3) and c:IsType(TYPE_MONSTER)
end
function s.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x10e3) and c:IsType(TYPE_SYNCHRO)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and c:IsAbleToDeck() and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,g,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP) then
			tc:CompleteProcedure()
			--Add
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,3))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(s.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
function s.remcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SendtoDeck(e:GetHandler(),tp,SEQ_DECKSHUFFLE,REASON_COST)  
end
function s.refilter(c,e,tp)
	return c:IsSetCard(0x10e3) and c:IsFaceup() and c:IsAbleToHand()
end
function s.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.refilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.remop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,s.refilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end