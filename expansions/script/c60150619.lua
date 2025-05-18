--天玲 暴走疾行
function c60150619.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_FUSION),2,2,c60150619.lcheck)
	c:EnableReviveLimit()
	--
	--local e12=Effect.CreateEffect(c)
	--e12:SetType(EFFECT_TYPE_SINGLE)
	--e12:SetCode(60150618)
	--c:RegisterEffect(e12)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--cannot target
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_SINGLE)
	--e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e2:SetRange(LOCATION_MZONE)
	--e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	--e2:SetValue(c60150619.tgvalue)
	--c:RegisterEffect(e2)
	--indes
	--local e5=Effect.CreateEffect(c)
	--e5:SetType(EFFECT_TYPE_SINGLE)
	--e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--e5:SetRange(LOCATION_MZONE)
	--e5:SetValue(1)
	--c:RegisterEffect(e5)
	
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c60150619.e3f)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60150619,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetCondition(c60150619.condition2)
	e4:SetOperation(c60150619.operation)
	c:RegisterEffect(e4)
	--remove
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(60150619,0))
	e6:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1)
	--e6:SetCost(c60150619.negcost)
	e6:SetTarget(c60150619.tdtg)
	e6:SetOperation(c60150619.tdop)
	c:RegisterEffect(e6)
end
function c60150619.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3b21)
end
function c60150619.mfilter(c)
	return c:IsType(TYPE_FUSION)
end
function c60150619.e3f(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c60150619.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c60150619.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3b21) 
		and ((c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)) or c:IsLocation(LOCATION_DECK+LOCATION_EXTRA))
end
function c60150619.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60150619.cfilter,1,nil,tp) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_FUSION)
end
function c60150619.tgfilter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_PENDULUM)
end
function c60150619.gfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
end
function c60150619.gfilter2(c)
	return c:IsAbleToGrave()
end
function c60150619.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60150619.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150619,1)) then
		local g2=g:Filter(c60150619.gfilter,nil)
		local g3=g:Filter(c60150619.gfilter2,nil)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150616,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150619,5))
			local sg=g2:Select(tp,1,1,nil)
			Duel.Hint(HINT_CARD,0,60150619)
			Duel.SendtoExtraP(sg,nil,REASON_EFFECT)
		elseif g3:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g3:Select(tp,1,1,nil)
			Duel.Hint(HINT_CARD,0,60150619)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		else 
			return false
		end
	end
end
function c60150619.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60150619.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b21) and c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave()
end
function c60150619.filter2(c)
	return c:IsAbleToDeck() or c:IsType(TYPE_PENDULUM)
end
function c60150619.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150619.filter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsExistingMatchingCard(c60150619.filter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c60150619.filter,tp,LOCATION_EXTRA,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150619.gfilter3(c)
	return c:IsAbleToDeck()
end
function c60150619.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60150619.filter,tp,LOCATION_EXTRA,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local ct=Duel.GetOperatedGroup():GetCount()
		local dg=Duel.GetMatchingGroup(c60150619.filter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
		if ct>0 and dg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150619,2))
			local rg=dg:Select(tp,1,ct,nil)
			Duel.HintSelection(rg)
			local g2=rg:Filter(c60150619.gfilter,nil)
			if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150619,4)) then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150619,3))
				local sg=g2:Select(tp,1,g2:GetCount(),nil)
				local tc=sg:GetFirst()
				while tc do
					rg:RemoveCard(tc)
					tc=sg:GetNext()
				end
				Duel.SendtoExtraP(sg,nil,REASON_EFFECT)
			end
			Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
		end
	end
end