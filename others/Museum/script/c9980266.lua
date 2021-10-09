--不死姬·觉醒之狐
function c9980266.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9980266+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9980266.target)
	e1:SetOperation(c9980266.activate)
	c:RegisterEffect(e1)
	 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980266,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c9980266.spcon)
	e2:SetTarget(c9980266.sptg)
	e2:SetOperation(c9980266.spop)
	c:RegisterEffect(e2)
end
function c9980266.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c9980266.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingMatchingCard(c9980266.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingTarget(c9980266.tgfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=1
	if Duel.IsExistingTarget(c9980266.tgfilter,tp,0,LOCATION_ONFIELD,2,nil) then ct=2 end
	local g=Duel.GetMatchingGroup(c9980266.cfilter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=Duel.SelectTarget(tp,c9980266.tgfilter,tp,0,LOCATION_ONFIELD,#sg,#sg,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,0,0)
end
function c9980266.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c9980266.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c9980266.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3bcc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9980266,0x10db,0x11,0,0,c:GetLevel(),RACE_ZOMBIE,ATTRIBUTE_DARK)
end
function c9980266.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9980266.spfilter(chkc,e,tp) end
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.IsExistingTarget(c9980266.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9980266.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c9980266.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9980266,0x10db,0x11,0,0,tc:GetLevel(),RACE_ZOMBIE,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_NORMAL,0,0,tc:GetLevel(),0,0)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
