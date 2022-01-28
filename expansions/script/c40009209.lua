--时机降神 神工巨匠
function c40009209.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,3,c40009209.ovfilter,aux.Stringid(40009209,3),3,c40009209.xyzop)
	c:EnableReviveLimit()
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.xyzlimit)
	c:RegisterEffect(e0)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009209,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c40009209.cost)
	e3:SetCondition(c40009209.setcon1)
	e3:SetTarget(c40009209.destg)
	e3:SetOperation(c40009209.desop)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCost(c40009209.nnegcost)
	e5:SetCondition(c40009209.setcon2)
	c:RegisterEffect(e5) 
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009209,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,40009209)
	e2:SetCondition(c40009209.tdcon1)
	e2:SetTarget(c40009209.tdtg)
	e2:SetOperation(c40009209.tdop)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCost(c40009209.nnegcost)
	e4:SetCondition(c40009209.tdcon2)
	c:RegisterEffect(e4) 
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009209,2))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c40009209.rettg)
	e1:SetOperation(c40009209.retop)
	c:RegisterEffect(e1)
end
function c40009209.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf1c) and c:IsType(TYPE_XYZ)
end
function c40009209.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40009209)==0 end
	Duel.RegisterFlagEffect(tp,40009209,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c40009209.nnegcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xf2c,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xf2c,3,REASON_COST)
end
function c40009209.setcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,40009208) or (Duel.GetCurrentChain()<1 and Duel.IsPlayerAffectedByEffect(tp,40009208))
end
function c40009209.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0 and Duel.IsPlayerAffectedByEffect(tp,40009208)
end
function c40009209.cfilter(c)
	return c:IsAbleToGraveAsCost()
end
function c40009209.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009209.cfilter,tp,LOCATION_REMOVED,0,12,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c40009209.cfilter,tp,LOCATION_REMOVED,0,12,12,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c40009209.tdfilter(c)
	return c:IsAbleToDeck()
end
function c40009209.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3)
		 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,6,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c40009209.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c40009209.tdfilter,tp,LOCATION_GRAVE,0,6,6,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,3,REASON_EFFECT)
		c:RegisterFlagEffect(40009209,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
end
function c40009209.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return (not Duel.IsPlayerAffectedByEffect(tp,40009208) or (Duel.GetCurrentChain()<1 and Duel.IsPlayerAffectedByEffect(tp,40009208))) and e:GetHandler():GetFlagEffect(40009209)~=0
end
function c40009209.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0 and Duel.IsPlayerAffectedByEffect(tp,40009208) and e:GetHandler():GetFlagEffect(40009209)~=0
end
function c40009209.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetChainLimit(c40009209.chlimit)
end
function c40009209.chlimit(e,ep,tp)
	return tp==ep
end
function c40009209.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,3,nil)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
end
function c40009209.tdfilter(c)
	return  c:IsAbleToRemove()
end
function c40009209.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c40009209.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	if c:IsLocation(LOCATION_EXTRA) then
	local sg=Duel.GetDecktopGroup(tp,12)
		if sg:GetCount()>0 then
			Duel.DisableShuffleCheck()
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end