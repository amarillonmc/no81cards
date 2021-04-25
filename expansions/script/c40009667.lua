--魔惧会男孩 伊登
function c40009667.initial_effect(c)
	 --Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009667,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40009632+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c40009667.actcon)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e4) 
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009667,2))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(c40009667.negcon)
	e2:SetCost(c40009667.ngcost)
	e2:SetTarget(c40009667.negtg)
	e2:SetOperation(c40009667.negop)
	c:RegisterEffect(e2)
end
function c40009667.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,40009560)>0
end
function c40009667.tfilter(c,tp)
	return ((c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() and c:IsControler(tp)) or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0xcf1b)
end
function c40009667.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c40009667.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c40009667.ngcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c40009667.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(40009667,1))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(40009667,1))
	Duel.RegisterFlagEffect(tp,40009560,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c40009667.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end