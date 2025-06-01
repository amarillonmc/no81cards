--人理之诗 往昔的多塞特沿岸
function c22023150.initial_effect(c)
	aux.AddCodeList(c,22023140) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023150,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,22023150)
	e2:SetTarget(c22023150.distg)
	e2:SetOperation(c22023150.disop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023150,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,22023150)
	e3:SetCondition(c22023150.setcon)
	e3:SetTarget(c22023150.settg)
	e3:SetOperation(c22023150.setop)
	c:RegisterEffect(e3)
end
function c22023150.filter(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c22023150.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c22023150.filter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct end
end
function c22023150.filter2(c)
	return c:IsSetCard(0xff1)
end
function c22023150.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c22023150.filter,tp,LOCATION_MZONE,0,nil)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return end
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.ConfirmCards(tp,g)
	local num=g:FilterCount(c22023150.filter2,nil)
	if num>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local sg=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,num,nil)
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		while tc do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
			end
			tc=sg:GetNext()
		end
		Duel.DisableShuffleCheck()
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
function c22023150.setfilter(c)
	return c:IsCode(22023140) and c:IsFaceup()
end
function c22023150.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22023150.setfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22023150.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c22023150.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-500)
	Duel.SSet(tp,c)
end
