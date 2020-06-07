--星辉之女神 阿斯忒西亚
function c9910601.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9910601.spcon)
	e1:SetOperation(c9910601.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910601)
	e2:SetCondition(c9910601.discon)
	e2:SetCost(c9910601.discost)
	e2:SetTarget(c9910601.distg)
	e2:SetOperation(c9910601.disop)
	c:RegisterEffect(e2)
end
function c9910601.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,c)
end
function c9910601.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c9910601.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c9910601.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9910601.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<7 then return false end
		local g=Duel.GetDecktopGroup(tp,7)
		return g:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==7
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c9910601.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=re:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<7 then return end
	Duel.ConfirmDecktop(tp,7)
	local g=Duel.GetDecktopGroup(tp,7)
	if g:GetCount()==0 then return end
	if g:GetClassCount(Card.GetCode)==g:GetCount() then
		if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
			ec:CancelToGrave()
			Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
	else
		if c:IsAbleToRemove(tp,POS_FACEDOWN) and c:IsRelateToEffect(e) then g:AddCard(c) end
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
