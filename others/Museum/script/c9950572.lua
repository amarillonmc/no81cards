--召唤之夜
function c9950572.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,9950572+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9950572.target)
	e1:SetOperation(c9950572.activate)
	c:RegisterEffect(e1)
 --act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c9950572.handcon)
	c:RegisterEffect(e2)
end
function c9950572.spfilter(c,e,tp)
	return c:IsSetCard(0xba5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950572.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(c9950572.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return dg:GetClassCount(Card.GetCode)>=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9950572.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9950572.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or g:GetClassCount(Card.GetCode)<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	if #sg>0 then
		Duel.ConfirmCards(1-tp,sg)
		local tc=sg:RandomSelect(1-tp,1):GetFirst()
		Duel.ConfirmCards(tp,tc)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetRange(LOCATION_MZONE)
		e3:SetAbsoluteRange(tp,1,0)
		e3:SetTarget(c9950572.splimit)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3,true)
		Duel.ShuffleDeck(tp)
	end
end
function c9950572.splimit(e,c)
	return not c:IsSetCard(0xba5) and c:IsLocation(LOCATION_EXTRA)
end
function c9950572.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
