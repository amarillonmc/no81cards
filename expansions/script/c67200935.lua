--镜花黄泉·鸦杀荧惑
function c67200935.initial_effect(c)
	c:EnableCounterPermit(0x67a)
	c:SetCounterLimit(0x67a,1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c67200935.handcon)
	c:RegisterEffect(e2)  
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_REPLACE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c67200935.damval)
	c:RegisterEffect(e3)
	--local e4=e1:Clone()
	--e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	--c:RegisterEffect(e4)
	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67200935,0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,67200935)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCost(c67200935.tecost)
	e5:SetTarget(c67200935.tetg)
	e5:SetOperation(c67200935.teop)
	c:RegisterEffect(e5)
end
function c67200935.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 and rp==1-e:GetOwnerPlayer()
		and c:IsCanAddCounter(0x67a,1) and c:GetFlagEffect(67200935)==0 then
		c:AddCounter(0x67a,1)
		c:RegisterFlagEffect(67200935,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		return 0
	end
	return val
end
--
function c67200935.tecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x67a,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x67a,1,REASON_COST)
end
function c67200935.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x567a) and c:IsFaceup() and c:IsAbleToHand()
end
function c67200935.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200935.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c67200935.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200935.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)	
		if Duel.ConfirmCards(1-tp,g)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,67200933))
			e1:SetValue(500)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)  
		end
	end
end
--
function c67200935.handcon(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)
	return (g:GetCount()>=3 and g:IsExists(c67200935.cfilter,3,nil)) or Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,67200933)
end
function c67200935.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x567a) and c:IsType(TYPE_PENDULUM)
end