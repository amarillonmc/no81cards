--煌牙之骑士 加尔莫尔
function c40009090.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c40009090.mfilter,8,2,c40009090.ovfilter,aux.Stringid(40009090,0),2,nil)
	c:EnableReviveLimit() 
	--ATK Up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009090,1))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c40009090.atkcon)
	e1:SetCost(c40009090.thcost)
	e1:SetTarget(c40009090.tdtg)
	e1:SetOperation(c40009090.tdop)
	c:RegisterEffect(e1) 
   --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009090,2))
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,40009090)
	e2:SetOperation(c40009090.atkop)
	c:RegisterEffect(e2) 
end
function c40009090.mfilter(c)
	return c:IsRace(RACE_BEAST)
end
function c40009090.ovfilter(c)
	return c:IsFaceup() and c:IsCode(40009089)
end
function c40009090.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c40009090.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c40009090.tdfilter(c)
	return c:IsRace(RACE_BEAST) and c:IsAbleToDeck()
end
function c40009090.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c40009090.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c40009090.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c40009090.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c40009090.tdfilter,p,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		local d=math.floor(ct/3)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function c40009090.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dd=c:GetOverlayCount()*2
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	if ct>dd then ct=dd end
	local t={}
	for i=1,ct do t[i]=i end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.ConfirmDecktop(tp,ac)
	local g=Duel.GetDecktopGroup(tp,ac)
	local ct2=g:FilterCount(Card.IsRace,nil,RACE_BEAST)
	Duel.ShuffleDeck(tp)
	local d=math.floor(ac/2)
	Duel.BreakEffect()
	c:RemoveOverlayCard(tp,d,d,REASON_EFFECT)
	if ct2>1 then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetCode(EFFECT_UPDATE_ATTACK)
	   e1:SetTargetRange(LOCATION_MZONE,0)
	   e1:SetValue(ct2*300)
	   e1:SetReset(RESET_PHASE+PHASE_END)
	   Duel.RegisterEffect(e1,tp)
	end
	if ct2>=3 then
	   local e2=Effect.CreateEffect(c)
	   e2:SetType(EFFECT_TYPE_SINGLE)
	   e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	   e2:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	   e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	   c:RegisterEffect(e2)
	end
end