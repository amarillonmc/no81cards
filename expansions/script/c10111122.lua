function c10111122.initial_effect(c)
	c:SetUniqueOnField(1,0,10111122)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c10111122.activate)
	c:RegisterEffect(e1)
	--effect gain
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10111122,2))
	e7:SetCategory(CATEGORY_DRAw)
	e7:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_BATTLE_START)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c10111122.ctcon)
	e7:SetTarget(c10111122.cttg)
	e7:SetOperation(c10111122.ctop)
	--grant effect
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e8:SetRange(LOCATION_SZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c10111122.eftg)
	e8:SetLabelObject(e7)
	c:RegisterEffect(e8)
    	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,10111122)
	e4:SetCondition(c10111122.spcon)
	e4:SetTarget(c10111122.sptg)
	e4:SetOperation(c10111122.spop)
	c:RegisterEffect(e4)
end
function c10111122.thfilter(c)
	return c:IsCode(15543940,90173539) and c:IsAbleToHand()
end
function c10111122.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10111122.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10111122,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c10111122.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c or Duel.GetAttackTarget()==c
end
function c10111122.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetChainLimit(c10111122.chlimit)
end
function c10111122.chlimit(e,ep,tp)
	return tp==ep
end
function c10111122.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-800)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
        Duel.BreakEffect()
	end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c10111122.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x11a)
end
function c10111122.cfilter2(c,tp)
	return c:IsSetCard(0x11a) and c:IsReason(REASON_DESTROY)
		and (c:IsReason(REASON_BATTLE) or c:GetReasonPlayer()==1-tp and c:IsReason(REASON_DESTROY))
		and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c10111122.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10111122.cfilter2,1,nil,tp)
end
function c10111122.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x11a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10111122.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10111122.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10111122.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10111122.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10111122.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end