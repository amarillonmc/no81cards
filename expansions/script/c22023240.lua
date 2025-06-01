--人理之诗 13号星期五
function c22023240.initial_effect(c)
	aux.AddCodeList(c,22023230) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22023240.condition)
	e1:SetTarget(c22023240.target)
	e1:SetOperation(c22023240.activate)
	c:RegisterEffect(e1)
	--lv
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023240,7))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,22023241)
	e2:SetCondition(c22023240.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22023240.thtg)
	e2:SetOperation(c22023240.thop)
	c:RegisterEffect(e2)
end
function c22023240.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c22023240.filter(c)
	return c:IsFaceup() and c:GetFlagEffect(22023240)==0
end
function c22023240.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023240.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SelectOption(tp,aux.Stringid(22023240,2))
	Duel.SelectOption(tp,aux.Stringid(22023240,3))
	Duel.SelectOption(tp,aux.Stringid(22023240,4))
end
function c22023240.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(22023240,1))
		e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(c22023240.atkop)
		tc:RegisterEffect(e1)
		if not tc:IsType(TYPE_EFFECT) then
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ADD_TYPE)
			e4:SetValue(TYPE_EFFECT)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
		end
		tc:RegisterFlagEffect(22023240,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22023240,0))
		tc=g:GetNext()
	end
end
function c22023240.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
	Duel.SelectOption(tp,aux.Stringid(22023240,5))
		local atk=c:GetAttack()
		local atk=c:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
		if (atk~=0 and c:IsAttack(0)) or (def~=0 and c:IsDefense(0)) then
			Duel.SelectOption(tp,aux.Stringid(22023240,6))
			Duel.Hint(HINT_CARD,0,22023230)
			Duel.Destroy(c,REASON_EFFECT)
			Duel.Recover(1-tp,500,REASON_EFFECT)
		end
	end
end
function c22023240.cfilter(c)
	return c:IsFaceup() and c:IsCode(22023230)
end
function c22023240.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22023240.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22023240.filter1(c)
	return c:IsCode(22023250) and c:IsAbleToHand()
end
function c22023240.filter2(c)
	return c:IsSetCard(0xff1) and not c:IsCode(22023240) and c:IsAbleToHand()
end
function c22023240.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c22023240.filter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(c22023240.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c22023240.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c22023240.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c22023240.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
