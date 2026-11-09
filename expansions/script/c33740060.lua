--天地颠倒的谐谑曲
function c33740060.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c33740060.accon)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(c33740060.reptg)
	e1:SetValue(c33740060.repval)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c33740060.tdcon)
	e2:SetOperation(c33740060.tdop)
	c:RegisterEffect(e2)
	--reflect damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_REFLECT_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,1)
	e3:SetValue(c33740060.refval)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33740060,0))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c33740060.tgtg)
	e4:SetOperation(c33740060.tgop)
	c:RegisterEffect(e4)
	--lp
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetOperation(c33740060.lpop)
	c:RegisterEffect(e5)
end
function c33740060.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end
function c33740060.repfilter(c)
	return c:GetDestination()==LOCATION_HAND and c:IsLocation(LOCATION_DECK)
end
function c33740060.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c33740060.repfilter,nil)
	if chk==0 then return bit.band(r,REASON_DRAW)==0 and #g>0 end
	if true then
		Duel.RegisterFlagEffect(tp,33740060,RESET_CHAIN,0,1)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	return true
	else return false end
end
function c33740060.repval(e,c)
	local res=Duel.GetFlagEffect(e:GetHandlerPlayer(),33740060)~=0
	Duel.ResetFlagEffect(e:GetHandlerPlayer(),33740060)
	return res
end
function c33740060.ctfilter(c,p)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(p) or c:IsPreviousLocation(LOCATION_GRAVE) and c:IsPreviousControler(p)
end
function c33740060.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33740060.ctfilter,1,nil,0) or eg:IsExists(c33740060.ctfilter,1,nil,1)
end
function c33740060.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,33740060)
	for p in aux.TurnPlayers() do
		local ct=eg:FilterCount(c33740060.ctfilter,nil,p)
		if ct>0 then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_GRAVE,0,ct,ct,nil)
			if #g>0 then
				Duel.HintSelection(g)
				if #g==1 then
					Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
				else
					aux.PlaceCardsOnDeckBottom(p,g)
				end
				Duel.DiscardDeck(p,ct,REASON_EFFECT)
			end
		end
	end
end
function c33740060.refval(e,re,ev,r,rp,rc)
	return bit.band(r,REASON_EFFECT)~=0
end
function c33740060.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,2000)
end
function c33740060.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
		Duel.BreakEffect()
		Duel.Recover(1-tp,2000,REASON_EFFECT)
	end
end
function c33740060.lpop(e,tp,eg,ep,ev,re,r,rp)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	Duel.SetLP(tp,lp2)
	Duel.SetLP(1-tp,lp1)
end
