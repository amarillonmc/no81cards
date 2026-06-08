--合辛的猫人长姐
function c17337704.initial_effect(c)
	--material redirect-hoshin
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_HAND)
	e0:SetCondition(c17337704.redcon)
	c:RegisterEffect(e0)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17337704,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,17337704)
	e1:SetCondition(c17337704.spcon)
	e1:SetTarget(c17337704.sptg)
	e1:SetOperation(c17337704.spop)
	c:RegisterEffect(e1)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,17337704+1)
	e2:SetCondition(c17337704.icon)
	e2:SetCost(c17337704.atkcost)
	e2:SetTarget(c17337704.atktg)
	e2:SetOperation(c17337704.atkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c17337704.qcon)
	c:RegisterEffect(e3)
end
function c17337704.redcon(e)
	local c=e:GetHandler()
	return c:IsOnField() and c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_SYNCHRO)
end
function c17337704.chkfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0x3f51)
end
function c17337704.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c17337704.chkfilter,1,nil,tp)
end
function c17337704.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c17337704.thfilter(c)
	return c:IsCode(17337706) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c17337704.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) and Duel.IsExistingMatchingCard(c17337704.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(17337704,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c17337704.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c17337704.icon(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.IsPlayerAffectedByEffect(tp,17337721)~=nil and e:GetHandler():IsOriginalSetCard(0x3f51))
end
function c17337704.qcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,17337721)~=nil and e:GetHandler():IsOriginalSetCard(0x3f51)
end
function c17337704.costfilter(c)
	return c:IsSetCard(0x3f51) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function c17337704.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17337704.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,c17337704.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_COST)
end
function c17337704.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c17337704.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	local preatk=tc:GetAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-2000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	if preatk~=0 and tc:IsAttack(0) then Duel.Destroy(tc,REASON_EFFECT) end
end
