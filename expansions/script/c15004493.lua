local m=15004493
local cm=_G["c"..m]
cm.name="始于终世的救赎之核"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,15004493+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--ind
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(LOCATION_PZONE,0)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(aux.TRUE)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,15004494)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x3f40) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousSetCard(0xf40) and c:IsPreviousControler(tp)
end
function cm.c2filter(c)
	return c:IsPreviousSetCard(0x3f40) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ag=eg:Filter(cm.cfilter,nil,tp)
	local b1=(ag:IsExists(cm.c2filter,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)))
	local b2=(ag:IsExists(Card.IsPreviousSetCard,1,nil,0x5f40) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil))
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 then
		s=s+1
	end
	if b2 then
		s=s+2
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
	end
	e:SetLabel(s)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ag=eg:Filter(cm.cfilter,nil,tp)
	local s=e:GetLabel()
	if s==0 then Duel.SelectYesNo(tp,aux.Stringid(m,8)) return end
	if (s==1 or s==3) and (ag:IsExists(cm.c2filter,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc1=ag:FilterSelect(tp,cm.c2filter,1,1,nil):GetFirst()
		if tc1 then
			Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
	if (s==2 or s==3) and (ag:IsExists(Card.IsPreviousSetCard,1,nil,0x5f40) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end