--永夜抄·上白泽慧音
function c872100014.initial_effect(c)
	c:EnableReviveLimit()
----
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(872100014,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c872100014.condition)
	e1:SetTarget(c872100014.target)
	e1:SetOperation(c872100014.operation)
	c:RegisterEffect(e1)
------
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(872100014,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c872100014.spcon)
	e2:SetTarget(c872100014.sptg)
	e2:SetOperation(c872100014.spop)
	c:RegisterEffect(e2)
end
function c872100014.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c872100014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_HAND)
end
function c872100014.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ct==0 then return end
	local ac=1
	if ct>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(872100014,1))
		ac=Duel.AnnounceNumber(tp,1,2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,ac)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	Duel.ShuffleHand(1-tp)
end
-------
function c872100014.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsReason(REASON_DESTROY)
end
function c872100014.filter2(c,e,tp)
	return c:IsSetCard(0xba1) and c:IsLevelAbove(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c872100014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c872100014.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c872100014.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end