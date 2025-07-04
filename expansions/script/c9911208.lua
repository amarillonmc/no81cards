--浩瀚开拓者 科学家苔丝
function c9911208.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c9911208.thcost)
	e1:SetTarget(c9911208.thtg)
	e1:SetOperation(c9911208.thop)
	c:RegisterEffect(e1)
	--sset
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9911208)
	e2:SetCost(c9911208.setcost)
	e2:SetTarget(c9911208.settg)
	e2:SetOperation(c9911208.setop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c9911208.indcon)
	e3:SetOperation(c9911208.indop)
	c:RegisterEffect(e3)
end
function c9911208.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c9911208.thfilter(c)
	return c:IsSetCard(0x5958) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c9911208.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911208.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911208.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911208.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9911208.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c9911208.confilter(c)
	return c:IsType(TYPE_TRAP) and c:IsFacedown()
end
function c9911208.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c9911208.confilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return ct>3 and #cg>0 and Duel.IsPlayerCanDiscardDeck(tp,1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=cg:Select(tp,1,ct-3,nil)
	Duel.ConfirmCards(1-tp,sg)
	e:SetLabel(#sg)
end
function c9911208.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c9911208.setop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()+3
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct and Duel.IsPlayerCanDiscardDeck(tp,1) then
		Duel.ConfirmDecktop(tp,ct)
		local g=Duel.GetDecktopGroup(tp,ct)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			if g:IsExists(c9911208.setfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9911208,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local sg=g:FilterSelect(tp,c9911208.setfilter,1,1,nil)
				Duel.SSet(tp,sg)
				g:Sub(sg)
			end
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c9911208.desop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9911208.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9911208)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_ONFIELD,0,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c9911208.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c9911208.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911208,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end
