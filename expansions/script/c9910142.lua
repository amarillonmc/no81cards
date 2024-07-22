--战车道计策·盲点侦察
function c9910142.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910142.target)
	e1:SetOperation(c9910142.activate)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910142)
	e2:SetCondition(c9910142.discon)
	e2:SetCost(c9910142.discost)
	e2:SetTarget(c9910142.distg)
	e2:SetOperation(c9910142.disop)
	c:RegisterEffect(e2)
end
function c9910142.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c9910142.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9958)
end
function c9910142.disfilter(c,typ)
	return aux.NegateAnyFilter(c) and c:IsType(typ)
end
function c9910142.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct1=Duel.GetMatchingGroupCount(c9910142.filter,tp,LOCATION_MZONE,0,nil)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ct1==0 or ct2==0 then return end
	local num={}
	local i=1
	while i<=ct1 and i<=ct2 do
		num[i]=i
		i=i+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910142,0))
	local ac=Duel.AnnounceNumber(tp,table.unpack(num))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,ac)
	Duel.ConfirmCards(tp,g)
	local sg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local tg=Duel.GetMatchingGroup(c9910142.disfilter,tp,0,LOCATION_ONFIELD,sg,tc:GetType()&0x7)
		if #tg>0 then
			tg:AddCard(tc)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910142,1))
			local sc=tg:Select(tp,1,1,nil):GetFirst()
			if not g:IsContains(sc) then sg:AddCard(sc) end
		end
	end
	Duel.ShuffleHand(1-tp)
	if #sg==0 then return end
	Duel.HintSelection(sg)
	for nc in aux.Next(sg) do
		Duel.NegateRelatedChain(nc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		nc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		nc:RegisterEffect(e2)
		if nc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			nc:RegisterEffect(e3)
		end
	end
end
function c9910142.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetCurrentChain()>=2
end
function c9910142.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local dt=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if chk==0 then return c:IsAbleToRemoveAsCost() and dt>0 and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	local ct=Duel.RemoveOverlayCard(tp,1,0,1,dt,REASON_COST)
	e:SetLabel(ct)
end
function c9910142.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,e:GetLabel(),tp,LOCATION_DECK)
end
function c9910142.disop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetDecktopGroup(1-tp,ct):Filter(Card.IsAbleToHand,nil,tp)
	if Duel.NegateEffect(ev) and ct>0 and #g==ct then
		Duel.DisableShuffleCheck()
		if Duel.SendtoHand(g,tp,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(tp)
		end
	end
end
