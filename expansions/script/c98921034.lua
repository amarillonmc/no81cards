--先史遗产-地动仪
function c98921034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98921034+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c98921034.target)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c98921034.reptg)
	e2:SetValue(c98921034.repval)
	e2:SetOperation(c98921034.repop)
	c:RegisterEffect(e2)
end
function c98921034.tgfilter(c)
	return c:IsSetCard(0x70) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAttackAbove(1)
end
function c98921034.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(c98921034.tgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(98921034,0)) then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c98921034.activate)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c98921034.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x70)
end
function c98921034.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsAttack(0) then
		local g=Duel.GetMatchingGroup(c98921034.filter,tp,LOCATION_MZONE,0,nil)
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-val)
		tc:RegisterEffect(e1)
		if tc:IsAttack(0) then Duel.Destroy(tc,REASON_EFFECT) end
	end
end
function c98921034.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x70) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c98921034.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c98921034.repfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(98921034,0)) then
		local g=eg:Filter(c98921034.repfilter,nil,tp)
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function c98921034.repval(e,c)
	return c98921034.repfilter(c,e:GetHandlerPlayer())
end
function c98921034.repop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject() 
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT+REASON_REPLACE)
	Duel.SendtoHand(tg,nil,REASON_EFFECT+REASON_REPLACE)
	Duel.ConfirmCards(1-tp,tg)
end