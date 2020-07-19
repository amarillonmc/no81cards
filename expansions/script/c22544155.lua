--强欲而纤维之壶
function c22544155.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,225441550+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22544155.cost)
	e1:SetTarget(c22544155.target)
	e1:SetOperation(c22544155.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22544155,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMING_ATTACK)
	e2:SetCountLimit(1,225441551)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c22544155.drawtg)
	e2:SetOperation(c22544155.drawop)
	c:RegisterEffect(e2)
end
function c22544155.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,0x3e,0,e:GetHandler())
	if chk==0 then return g:FilterCount(Card.IsAbleToDeckOrExtraAsCost,nil)>=0
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.ShuffleDeck(tp)
end
function c22544155.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetChainLimit(aux.FALSE)
	
end
function c22544155.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and e:GetHandler():IsLocation(LOCATION_ONFIELD) then return end
	e:GetHandler():RegisterFlagEffect(22544155,RESET_EVENT+RESETS_STANDARD,0,0)
end 
function c22544155.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,2) and c:GetFlagEffect(22544155)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetChainLimit(aux.FALSE)
end
function c22544155.drawop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(c,nil,1,REASON_EFFECT)~=0 then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.SetLP(tp,4000)
	Duel.Draw(p,d,REASON_EFFECT)
end
