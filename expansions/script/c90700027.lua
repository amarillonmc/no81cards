local m=90700027
local cm=_G["c"..m]
cm.name="多元霜火骑士"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.actcon)
	e1:SetOperation(cm.actop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	c90700027.act=e1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90700027,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE+LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)	
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)>0-- and not e:GetHandler():IsForbidden() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.actfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToGrave()
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc
	if e:GetLabel()==1 then
		tc=eg:GetFirst()
	else
		tc=e:GetHandler()
	end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_MONSTER+TYPE_EFFECT)
	tc:RegisterEffect(e2)
	tc:AddCounter(0x5ac0,2)
	Duel.BreakEffect()
	local ffcount=Duel.GetCounter(tp,LOCATION_SZONE,0,0x5ac0)
	local field=Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst()
	if field then
		ffcount=ffcount-field:GetCounter(0x5ac0)
	end
	if ffcount>=5 and Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(90700027,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function cm.thfilter(c)
	return c:IsSetCard(0x5ac0) and not c:IsCode(90700006) and c:IsPosition(POS_FACEUP)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:IsActiveType(TYPE_SPELL) and not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	  Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end