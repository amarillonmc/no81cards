--煌龙 拉维亚
function c11771465.initial_effect(c)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11771465)
	e1:SetCondition(c11771465.discon)
	e1:SetTarget(c11771465.distg)
	e1:SetOperation(c11771465.disop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DICE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,11771465+1)
	e2:SetTarget(c11771465.sptg)
	e2:SetOperation(c11771465.spop)
	c:RegisterEffect(e2)
end
function c11771465.spfilter(c,e,tp)
	return c:IsCode(11771460) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP)
end
function c11771465.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11771465.spfilter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c11771465.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DICE)
	local ac=Duel.AnnounceNumber(tp,1,2,3,4,5,6)
	local dc=Duel.TossDice(tp,1)
	if ac==dc then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11771465.spfilter),tp,0x13,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			g:GetFirst():CompleteProcedure()
		end
	end
end
function c11771465.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev)
end
function c11771465.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,3)
end
function c11771465.disop(e,tp,eg,ep,ev,re,r,rp)
	local ct1,ct2,ct3=Duel.TossDice(tp,3)
	local dc=ct1+ct2+ct3
	if dc>=6 then
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		end
	end
	if  dc>=12 then
		local g=Duel.GetMatchingGroup(c11771465.tdfilter,tp,0,LOCATION_ONFIELD,nil)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	if dc==18 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c11771465.tdfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end