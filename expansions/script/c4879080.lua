local m=4879080
local cm=_G["c"..m]
function cm.initial_effect(c)
aux.AddCodeList(c,4879080)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(m)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.negcon)
	e2:SetTarget(cm.negtg)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
	 local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCondition(cm.spcon1)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.thfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function cm.spcfilter(c)
	return c:IsCode(4879077) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS and Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.pfilter(c)
	return (c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0xae5f)) or (c:IsType(TYPE_MONSTER) and c:IsSetCard(0xae5f))
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.NegateAnyFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	 local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cm.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		local tc1=g:GetFirst()
		if tc1 then
			Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			if tc1:IsType(TYPE_MONSTER) then 
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc1:RegisterEffect(e1)
			end
	end
	end
end