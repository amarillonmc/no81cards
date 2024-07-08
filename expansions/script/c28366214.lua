--樱色的一等星 尽所有的光辉
function c28366214.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,28366214+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c28366214.target)
	e1:SetOperation(c28366214.activate)
	c:RegisterEffect(e1)
	--illumination maho
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCondition(c28366214.thcon)
	e2:SetTarget(c28366214.thtg)
	e2:SetOperation(c28366214.thop)
	c:RegisterEffect(e2)
	--illumination SetCode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetValue(0x283)
	c:RegisterEffect(e3)
end
function c28366214.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x284)
end
function c28366214.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c28366214.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28366214.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c28366214.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c28366214.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
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
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		Duel.RegisterEffect(e2,tp)
		if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28366214,2)) then
			Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetValue(c28366214.efilter)
			e3:SetOwnerPlayer(tp)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28366214,3))
		if not tc:IsAttribute(ATTRIBUTE_FIRE) then
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
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
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
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetCondition(c28366214.adcon)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetOperation(c28366214.adop)
		e1:SetLabelObject(c)
		Duel.RegisterEffect(e1,tp)
		table.insert(c28366214.et,{e1})
	else
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c28366214.adcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28366214.adf,tp,LOCATION_MZONE,0,1,nil,e)
end
function c28366214.adop(e,tp,eg,ep,ev,re,r,rp)
	local c,g= e:GetLabelObject(),Duel.GetMatchingGroup(c28366214.adf,tp,LOCATION_MZONE,0,nil,e)
	for xc in aux.Next(g) do
		local x
		if xc:GetLevel()>0 then x=EFFECT_UPDATE_LEVEL
		elseif xc:GetRank()>0 then x=EFFECT_UPDATE_RANK end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(x)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetValue(1)
		xc:RegisterEffect(e1)
		table.insert(c28366214.get(e),xc)
	end
end
c28366214.et = { }
function c28366214.get(v)
	for _,i in ipairs(c28366214.et) do
		if i[1]==v then return i end
	end
end
function c28366214.ck(e,c)
	local t = c28366214.get(e)
	for _,v in ipairs(t) do
		if v == c then return false end
	end
	return true
end
function c28366214.adf(c,e)
	return c:IsSetCard(0x284) and (c:GetLevel()>0 or c:GetRank()>0) and c28366214.ck(e,c)
end
