local m=53796068
local cm=_G["c"..m]
cm.name="无面控流者"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and not c:IsPublic() and c:GetRace()~=0
end
function cm.fselect(g)
	return g:GetClassCount(Card.GetRace)==#g
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil)
	end
	e:SetLabel(0)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,1,3)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(sg)
end
function cm.filter(c,g)
	return c:IsAttribute(ATTRIBUTE_WATER) and not g:IsExists(Card.IsRace,1,nil,c:GetRace()) and c:IsAbleToHand()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	local ct=g:GetClassCount(Card.GetRace)
	local rflag=false
	local c=e:GetHandler()
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		if #g>1 then atk=g:Select(tp,1,1,nil):GetFirst() end
		Duel.ConfirmCards(1-tp,atk)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		rflag=true
	end
	if ct>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sp=g:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,false,false)
		if #sp>0 then
			if rflag then Duel.BreakEffect() end
			if Duel.SpecialSummon(sp,0,tp,tp,false,false,POS_FACEUP)~=0 then rflag=true end
		end
	end
	if ct>2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local th=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,g)
		if #th>0 then
			if rflag then Duel.BreakEffect() end
			Duel.SendtoHand(th,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,th)
		end
	end
end
