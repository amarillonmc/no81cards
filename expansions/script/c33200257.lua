--机略纵横 郭公则
function c33200257.initial_effect(c)
	c:SetUniqueOnField(1,1,33200257)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(3,33200250+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c33200257.atkcon)
	e1:SetTarget(c33200257.atktg)
	e1:SetOperation(c33200257.atkop)
	c:RegisterEffect(e1)   
	--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetCondition(c33200257.handcon)
	c:RegisterEffect(e4) 
	--spsm
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c33200257.smtg)
	e2:SetOperation(c33200257.smop)
	c:RegisterEffect(e2) 
	--rth
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,33200257+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c33200257.rthcon)
	e3:SetOperation(c33200257.rthop)
	c:RegisterEffect(e3)
end

--e1
function c33200257.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_END
end
function c33200257.disfilter(c)
	return c:IsFaceup() and (c:IsAttackAbove(1) or aux.disfilter1(c))
end
function c33200257.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c33200257.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33200257.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c33200257.disfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c33200257.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local cp=c:GetControler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetAttack()>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCountLimit(1)   
		e4:SetOperation(c33200257.dmgop)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CONTROL+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
	end
end
function c33200257.dmgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,33200257)
	Duel.Damage(1-tp,2000,REASON_EFFECT)
end


--e2
function c33200257.cfilter(c)
	return c:GetSequence()<5
end
function c33200257.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33200250,0,0x4011,1000,1000,2,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33200257.smop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,33200250,0,0x4011,1000,1000,2,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP_ATTACK) then return end
	local token=Duel.CreateToken(tp,33200248)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33200257.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33200257.splimit(e,c)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_WARRIOR)) and c:IsLocation(LOCATION_EXTRA) 
end

--e3
function c33200257.rthcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetPreviousControler()==tp and e:GetHandler():IsAbleToHand()
		and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil)
end
function c33200257.rthop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) then return end
	if e:GetHandler():IsRelateToEffect(e) then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,sg)
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end

--act in hand
function c33200257.ihfilter(c)
	return c:IsCode(33200250) and c:IsFaceup()
end
function c33200257.handcon(e)
	return Duel.IsExistingMatchingCard(c33200257.ihfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end