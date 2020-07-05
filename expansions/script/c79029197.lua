--罗德岛·近卫干员-断罪者
function c79029197.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetRange(LOCATION_HAND)
	c:RegisterEffect(e1)	
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c79029197.negcon)
	e2:SetCost(c79029197.negcost)
	e2:SetOperation(c79029197.negop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetCode(EVENT_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c79029197.spcon)
	e3:SetTarget(c79029197.sptg)
	e3:SetOperation(c79029197.spop)
	c:RegisterEffect(e3)  
end
function c79029197.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp 
end
function c79029197.negcost(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c79029197.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(2061963,0)) then
		Duel.Hint(HINT_CARD,0,79029197)
		if Duel.NegateEffect(ev) then
		Duel.SendtoDeck(e:GetHandler(),1-tp,0,REASON_EFFECT)
	end
end
end
function c79029197.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	return eg:IsContains(c)
end
function c79029197.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ht1=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and (ht<=4 or ht1<=4) end
end
function c79029197.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(1-tp,aux.Stringid(1474910,0)) then
	if Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST) then 
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		Duel.Draw(p,4-ht,REASON_EFFECT)
	local ht1=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
		Duel.Draw(1-tp,4-ht1,REASON_EFFECT)
end
end
end