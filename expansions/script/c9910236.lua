--天空漫步者-防守
function c9910236.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9910236.condition)
	e1:SetTarget(c9910236.target)
	e1:SetOperation(c9910236.activate)
	c:RegisterEffect(e1)
end
function c9910236.cfilter(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsRace(RACE_PSYCHO))
end
function c9910236.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9910236.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910236.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO)
end
function c9910236.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCurrentChain()>2 then
		e:SetCategory(CATEGORY_TODECK)
	else
		e:SetCategory(0)
	end
end
function c9910236.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetCurrentChain()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetValue(c9910236.efilter)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and ct>2 then
		local g=Group.CreateGroup()
		for i=1,ct do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			local tc=te:GetHandler()
			if tc:IsRelateToEffect(te) and tc:IsAbleToDeck() and tc~=c then
				g:AddCard(tc)
			end
		end
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(9910236,0)) then
			if g:IsExists(Card.IsFacedown,1,nil) then
				local cg=g:Filter(Card.IsFacedown,nil)
				Duel.ConfirmCards(tp,cg)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end
function c9910236.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
