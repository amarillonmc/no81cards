--战车道计策·盲点侦察
function c9910142.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910142)
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
function c9910142.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9958)
end
function c9910142.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910142.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
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
	if Duel.SelectYesNo(tp,aux.Stringid(9910142,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c9910142.acdistg1)
		e1:SetLabel(ac)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c9910142.acdiscon)
		e2:SetOperation(c9910142.acdisop)
		e2:SetLabel(ac)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(c9910142.acdistg2)
		e3:SetLabel(ac)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
	Duel.ShuffleHand(1-tp)
end
function c9910142.acdistg1(e,c)
	local ac=e:GetLabel()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsOriginalCodeRule(ac)
	else
		return c:IsOriginalCodeRule(ac) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
	end
end
function c9910142.acdistg2(e,c)
	local ac=e:GetLabel()
	return c:IsOriginalCodeRule(ac)
end
function c9910142.acdiscon(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	return re:GetHandler():IsOriginalCodeRule(ac)
end
function c9910142.acdisop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c9910142.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetCurrentChain()>=2
end
function c9910142.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local dt=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
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
