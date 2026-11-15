--乐士奏音 《怦然心动之梦》
function c19209703.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c19209703.target)
	e1:SetOperation(c19209703.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209703,2))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c19209703.atktg)
	e2:SetOperation(c19209703.atkop)
	c:RegisterEffect(e2)
end
function c19209703.tffilter(c,tp)
	return c:IsCode(19209696) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c19209703.cfilter(c)
	return c:IsCode(19209701) and c:IsFaceup()
end
function c19209703.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c19209703.tffilter,tp,LOCATION_DECK,0,1,nil,tp)
	local b2=false
	local ct=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,19209701) and ct and ct>=1 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)~=0 then
		local te,p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_CONTROLER)
		if p~=tp and te:IsActiveType(TYPE_MONSTER) and te:GetActivateLocation()==LOCATION_MZONE and te:GetHandler():GetBaseAttack()<=1400 then b2=true end
	end
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(19209703,0)},
		{b2,aux.Stringid(19209703,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(0)
	elseif op==2 then
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		local te=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,Group.FromCards(te:GetHandler()),1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	end
end
function c19209703.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c19209703.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tc=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND,0,1,1,nil,19209701):GetFirst()
		if tc then
			Duel.ConfirmCards(1-tp,tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(66)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		local ct=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
		if Duel.NegateActivation(ct-1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			if #g==0 then return end
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c19209703.tfilter(c)
	return c:GetBaseAttack()<=1400 and c:IsFaceup()
end
function c19209703.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c19209703.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19209703.tfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c19209703.tfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c19209703.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToChain() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
