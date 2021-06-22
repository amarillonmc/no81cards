--深层思考
local m=33711702
local cm=_G["c"..m]
function cm.initial_effect(c)
   --activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1) 
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.discon)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	--leav effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return Duel.CheckLPCost(tp,800) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local num=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil)
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,4000)/800)
	if m>num then
		m=num
	end
	local t={}
	for i=1,m do
		t[i]=i*800
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,ac/800,ac/800,nil)
	Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
end
function cm.remfilter(c)
	return c:GetFlagEffect(m)<1
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(cm.remfilter,nil)
	return sg:GetCount()>0
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local num=Duel.Remove(eg:Filter(cm.remfilter,nil),POS_FACEDOWN,REASON_RULE)
	if num<1 then return end
	local tg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local sg=tg:Filter(Card.IsAbleToHand,nil)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=sg:RandomSelect(tp,1)
		local tc=tg:GetFirst()
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOHAND,0,0)
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(e:GetHandlerPlayer(),500*Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil),REASON_EFFECT)
end