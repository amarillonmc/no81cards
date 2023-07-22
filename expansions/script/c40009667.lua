--魔惧会男孩 伊登
local m=40009667
local cm=_G["c"..m]
cm.named_with_Diablotherhood=1
function cm.Diablotherhood(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Diablotherhood
end
function cm.initial_effect(c)
	 --Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.actcon)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e4) 
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(cm.negcon)
	e2:SetCost(cm.ngcost)
	e2:SetTarget(cm.negtg)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
end
function cm.dfilter(c)
	return c:IsFaceup() and c:IsCode(40010230)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,40009560)>0 or Duel.IsExistingMatchingCard(cm.dfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tfilter(c,tp)
	return ((c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() and c:IsControler(tp)) or c:IsLocation(LOCATION_GRAVE)) and cm.Diablotherhood(c)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(cm.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function cm.ngcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,1))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,1))
	Duel.RegisterFlagEffect(tp,40009560,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end