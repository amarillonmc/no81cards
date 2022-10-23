--深空 陷阱
function c72101226.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72101226,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,c72101226)
	e1:SetTarget(c72101226.ngtg)
	e1:SetOperation(c72101226.bgop)
	c:RegisterEffect(e1)

	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c72101226.handcon)
	e2:SetCost(c72101226.handcost)
	c:RegisterEffect(e2)

	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72101226,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_BATTLE_END+TIMING_END_PHASE)
	e3:SetCountLimit(1,72101227)
	e3:SetCondition(c72101226.spcon1)
	e3:SetCost(c72101226.spcost)
	e3:SetTarget(c72101226.sptg)
	e3:SetOperation(c72101226.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCondition(c72101226.spcon2)
	c:RegisterEffect(e4)
	
end

--negate
function c72101226.ngtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.NegateAnyFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c72101226.bgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end

--act in hand
function c72101226.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c72101226.hcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcea) and c:IsAttribute(ATTRIBUTE_DEVINE)
		and c:IsType(TYPE_EFFECT) and c:IsLevel(10) 
end
function c72101226.handcon(e)
	return Duel.IsExistingMatchingCard(c72101226.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c72101226.handcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x7210,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x7210,1,REASON_COST)
end

--token
function c72101226.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil)
end
function c72101226.sprfilter(c)
	return c:IsSetCard(0xcea) and c:IsAbleToRemoveAsCost() and not c:IsCode(72101226)
end
function c72101226.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(c72101226.sprfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c72101226.sprfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local rc=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	e:SetLabel(rc)
end
function c72101226.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetLabel()
	if chk==0 then return 
		Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,72101228,0xcea,TYPES_TOKEN_MONSTER,0,0,7,RACE_MACHINE,rc) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c72101226.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,72101228,0xcea,TYPES_TOKEN_MONSTER,0,0,7,RACE_MACHINE,0) then
		local token=Duel.CreateToken(tp,72101228)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(rc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD -RESET_TOFIELD)
		token:RegisterEffect(e1,true)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c72101226.catg(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,72101228)
end
--quick
function c72101226.czfilter(c)
	return c:IsCode(72101215) and c:IsLocation(LOCATION_GRAVE)
end
function c72101226.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c72101225.czfilter,tp,LOCATION_GRAVE,0,1,nil) and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil)
end
