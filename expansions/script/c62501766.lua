--蚀痕无命 律之古则
function c62501766.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c62501766.cost)
	e1:SetOperation(c62501766.activate)
	c:RegisterEffect(e1)
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(c62501766.effectfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(c62501766.effectfilter)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,62501766)
	e4:SetTarget(c62501766.cttg)
	e4:SetOperation(c62501766.ctop)
	c:RegisterEffect(e4)
	c62501766.remove_event_effect=e4
end
function c62501766.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=0
	for i=1,6 do
		local g=Duel.GetDecktopGroup(tp,i)
		if g:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)~=i then break end
		ct=i
	end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil,tp,POS_FACEDOWN)
	if chk==0 then return #g+ct>=6 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(62501766,1))
	local sg=g:CancelableSelect(tp,6-ct,6,nil)
	local dg=Duel.GetDecktopGroup(tp,6)
	if sg then
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		dg=Duel.GetDecktopGroup(tp,6-sg:GetCount())
	end
	if dg:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.Remove(dg,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c62501766.thfilter(c)
	return c:IsSetCard(0xea4) and not c:IsCode(62501766) and (c:IsFacedown() or c:IsLocation(LOCATION_DECK)) and c:IsAbleToHand()
end
function c62501766.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c62501766.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(62501766,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c62501766.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:GetHandler():IsSetCard(0xea4)
end
function c62501766.ctfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c62501766.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501766.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c62501766.ctfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c62501766.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local tc=Duel.SelectMatchingCard(tp,c62501766.ctfilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		Duel.GetControl(tc,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_DECKBOT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1)
	end
end
