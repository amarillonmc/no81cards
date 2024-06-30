--匪魔的犯罪预备
function c9910191.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910191)
	e1:SetTarget(c9910191.target)
	e1:SetOperation(c9910191.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910191,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910191)
	e2:SetCondition(c9910191.descon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910191.destg)
	e2:SetOperation(c9910191.desop)
	c:RegisterEffect(e2)
end
function c9910191.chkfilter(c)
	return c:IsSetCard(0x3954) and c:IsAbleToGrave()
end
function c9910191.setfilter(c,check)
	return c:IsSSetable() and (not c:IsType(TYPE_FIELD) or check)
end
function c9910191.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.IsExistingMatchingCard(c9910191.chkfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910191.setfilter,tp,LOCATION_HAND,0,1,nil,check) end
end
function c9910191.activate(e,tp,eg,ep,ev,re,r,rp)
	local count=3
	while count>0 do
		local check=Duel.IsExistingMatchingCard(c9910191.chkfilter,tp,LOCATION_DECK,0,1,nil)
		if Duel.IsExistingMatchingCard(c9910191.setfilter,tp,LOCATION_HAND,0,1,nil,check) and
			(count==3 or Duel.SelectYesNo(tp,aux.Stringid(9910191,0))) then
			if count<3 then Duel.BreakEffect() end
			local g=Duel.SelectMatchingCard(tp,Card.IsSSetable,tp,LOCATION_HAND,0,1,1,nil)
			local tc=g:GetFirst()
			if tc and Duel.SSet(tp,tc,tp,false)>0 then
				local g1=Group.CreateGroup()
				if tc:IsOnField() and not tc:IsLocation(LOCATION_FZONE) then
					g1:AddCard(tc)
					local g2=tc:GetColumnGroup()
					if #g2>0 then g1:Merge(g2) end
				end
				local g3=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x3954)
				if #g3>0 then g1:Merge(g3) end
				if g1:IsExists(Card.IsAbleToGrave,1,aux.ExceptThisCard(e)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local sg=g1:FilterSelect(tp,Card.IsAbleToGrave,1,1,aux.ExceptThisCard(e))
					Duel.SendtoGrave(sg,REASON_EFFECT)
				end
			end
			count=count-1
		else
			count=0
		end
	end
end
function c9910191.cfilter(c,tp)
	return (c:IsRace(RACE_FIEND) or c:IsType(TYPE_TRAP)) and c:IsControler(tp)
end
function c9910191.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910191.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c9910191.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9910191.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
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
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
