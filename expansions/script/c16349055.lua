--究极骑士秘技 飞龙之息
function c16349055.initial_effect(c)
	c:SetUniqueOnField(1,0,16349055)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16349055,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,16349055)
	e1:SetTarget(c16349055.thtg)
	e1:SetOperation(c16349055.thop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16349055,2))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,16349055+1)
	e2:SetCost(c16349055.cost)
	e2:SetTarget(c16349055.target)
	e2:SetOperation(c16349055.activate)
	c:RegisterEffect(e2)
end
function c16349055.tgfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3dc2) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
		and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c16349055.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode(),tp)
end
function c16349055.thfilter(c,code,tp)
	return c:IsSetCard(0x3dc2) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and not c:IsCode(code)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c16349055.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c16349055.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c16349055.tgfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c16349055.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c16349055.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc2=Duel.SelectMatchingCard(tp,c16349055.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode()):GetFirst()
		if tc2 then Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
	end
end
function c16349055.cfilter(c)
	return (c:GetAttack()>0 or c:GetDefense()>0) and c:IsAbleToGraveAsCost()
end
function c16349055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16349055.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c16349055.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local tc=g:GetFirst()
	e:SetLabel(math.min(tc:GetAttack(),tc:GetDefense()))
end
function c16349055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c16349055.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local dg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-num)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end