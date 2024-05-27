--樱色的一等星 尽所有的光辉
function c28366214.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28366214,2))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,28366214+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c28366214.target)
	e1:SetOperation(c28366214.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28366214,3))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,28366214+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c28366214.cost)
	e2:SetTarget(c28366214.target)
	e2:SetOperation(c28366214.activate2)
	c:RegisterEffect(e2)
	--illumination maho
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCountLimit(1,28366214)
	e3:SetCondition(c28366214.thcon)
	e3:SetTarget(c28366214.thtg)
	e3:SetOperation(c28366214.thop)
	c:RegisterEffect(e3)
	--illumination SetCode
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ADD_SETCODE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e4:SetValue(0x283)
	c:RegisterEffect(e4)
end
function c28366214.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c28366214.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x284)
end
function c28366214.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c28366214.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28366214.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c28366214.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if not g:GetFirst():IsAttribute(ATTRIBUTE_FIRE) then
		Duel.SetTargetParam(1)
	end
end
function c28366214.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x284)
end
function c28366214.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local num=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c28366214.cfilter,tp,LOCATION_MZONE,0,nil)
		local atk=g:GetSum(Card.GetRank)+g:GetSum(Card.GetLevel)
		if atk>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk*100)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(0,1)
		e2:SetLabelObject(tc)
		e2:SetValue(1)
		e2:SetCondition(c28366214.actcon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28366214,4))
		if num==1 then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
			e3:SetTargetRange(LOCATION_MZONE,0)
			e3:SetTarget(c28366214.atktg)
			e3:SetLabel(tc:GetFieldID())
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c28366214.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local num=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c28366214.cfilter,tp,LOCATION_MZONE,0,nil)
		local atk=g:GetSum(Card.GetRank)+g:GetSum(Card.GetLevel)
		if atk>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk*100)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(0,1)
		e2:SetLabelObject(tc)
		e2:SetValue(1)
		e2:SetCondition(c28366214.actcon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c28366214.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28366214,4))
		if num==1 then
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
			e4:SetTargetRange(LOCATION_MZONE,0)
			e4:SetTarget(c28366214.atktg)
			e4:SetLabel(tc:GetFieldID())
			e4:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e4,tp)
		end
	end
end
function c28366214.actcon(e)
	return Duel.GetAttacker()==e:GetLabelObject()
end
function c28366214.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end
function c28366214.atktg(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c28366214.thcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	return eg:IsContains(e:GetHandler()) and re:GetHandler():IsType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x284)
end
function c28366214.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,e:GetHandler():GetLocation())
end
function c28366214.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=true
	local b2=c:IsRelateToEffect(e)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(28366214,0)},
		{b2,aux.Stringid(28366214,1)})
	if op==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RANK)
		Duel.RegisterEffect(e2,tp)
	else
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
