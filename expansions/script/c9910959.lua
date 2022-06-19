--永夏的释怀
function c9910959.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910959+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910959.target)
	e1:SetOperation(c9910959.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9910959,ACTIVITY_CHAIN,c9910959.chainfilter1)
	Duel.AddCustomActivityCounter(9910960,ACTIVITY_CHAIN,c9910959.chainfilter2)
	Duel.AddCustomActivityCounter(9910961,ACTIVITY_CHAIN,c9910959.chainfilter3)
end
function c9910959.chainfilter1(re,tp,cid)
	return not re:GetHandler():IsType(TYPE_MONSTER)
end
function c9910959.chainfilter2(re,tp,cid)
	return not re:GetHandler():IsType(TYPE_SPELL)
end
function c9910959.chainfilter3(re,tp,cid)
	return not re:GetHandler():IsType(TYPE_TRAP)
end
function c9910959.rmfilter(c,tp)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5954)
		and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c9910959.thfilter(c,tp)
	local b1=Duel.GetCustomActivityCount(9910959,1-tp,ACTIVITY_CHAIN)~=0 and c:IsType(TYPE_MONSTER)
	local b2=Duel.GetCustomActivityCount(9910960,1-tp,ACTIVITY_CHAIN)~=0 and c:IsType(TYPE_SPELL)
	local b3=Duel.GetCustomActivityCount(9910961,1-tp,ACTIVITY_CHAIN)~=0 and c:IsType(TYPE_TRAP)
	return c:IsSetCard(0x5954) and c:IsAbleToHand() and (b1 or b2 or b3)
end
function c9910959.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c9910959.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.IsExistingMatchingCard(c9910959.thfilter,tp,LOCATION_DECK,0,1,nil,tp)
	if chk==0 then return b1 or b2 end
end
function c9910959.gcheck(g)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<=1
end
function c9910959.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c9910959.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,tp)
	local g2=Duel.GetMatchingGroup(c9910959.thfilter,tp,LOCATION_DECK,0,nil,tp)
	local b1=#g1>0 and Duel.IsPlayerCanDraw(tp,2)
	local b2=#g2>0
	if not (b1 or b2) then return end
	local lab=0
	if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(9910959,0),aux.Stringid(9910959,1))==0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g1:Select(tp,1,1,nil)
		if rg:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,rg)
		end
		if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)~=0 then Duel.Draw(tp,2,REASON_EFFECT) end
		lab=1
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g2:SelectSubGroup(tp,c9910959.gcheck,false,1,3)
		if sg then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
		lab=2
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetLabel(lab)
	e1:SetCountLimit(1)
	e1:SetCondition(c9910959.regcon)
	e1:SetOperation(c9910959.regop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910959.regcon(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c9910959.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsPlayerCanDraw(tp,2) and e:GetLabel()==2
	local b2=Duel.IsExistingMatchingCard(c9910959.thfilter,tp,LOCATION_DECK,0,1,nil,tp) and e:GetLabel()==1
	return b1 or b2
end
function c9910959.regop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(9910959,2)) then return end
	Duel.Hint(HINT_CARD,0,9910959)
	local g1=Duel.GetMatchingGroup(c9910959.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,tp)
	local g2=Duel.GetMatchingGroup(c9910959.thfilter,tp,LOCATION_DECK,0,nil,tp)
	if e:GetLabel()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g1:Select(tp,1,1,nil)
		if rg:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,rg)
		end
		if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)~=0 then Duel.Draw(tp,2,REASON_EFFECT) end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g2:SelectSubGroup(tp,c9910959.gcheck,false,1,3)
		if sg then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
