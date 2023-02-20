--龙树侵攻
local m=40010932
local cm=_G["c"..m]
cm.named_with_DragonTree=1
function cm.DragonTree(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_DragonTree) or c:IsCode(40010936)
end
function cm.CaLaMity(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_CaLaMity
end
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.aktg)
	e2:SetValue(cm.val)
	c:RegisterEffect(e2)
	--Effect 2
	local e02=Effect.CreateEffect(c)  
	e02:SetDescription(aux.Stringid(m,0))
	e02:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e02:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_FZONE)
	e02:SetCountLimit(1)
	e02:SetCost(cm.thcost)
	e02:SetTarget(cm.thtg)
	e02:SetOperation(cm.thop)
	c:RegisterEffect(e02)  
	--Effect 3
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,1))
	e12:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_CHAINING)
	e12:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	e12:SetRange(LOCATION_FZONE)
	e12:SetCountLimit(1)
	e12:SetCondition(cm.negcon)
	e12:SetTarget(cm.negtg)
	e12:SetOperation(cm.negop)
	c:RegisterEffect(e12)
end
--Effect 1
function cm.aktg(e,c)
	return cm.DragonTree(c)
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:GetAttribute()~=0
end
function cm.val(e,c)
	local g=Duel.GetMatchingGroup(cm.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return aux.GetAttributeCount(g)*300
end
--Effect 2
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.tf(c,tp)
	local shchk=cm.CaLaMity(c) and c:IsAbleToHand()
	return shchk and Duel.IsExistingMatchingCard(cm.tf1,tp,LOCATION_DECK,0,1,c)
end
function cm.tf1(c)
	return cm.DragonTree(c) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tf,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tf,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,cm.tf1,tp,LOCATION_DECK,0,1,1,g:GetFirst(),tp)
	if #g==0 or #tg==0 then return false end
	g:Merge(tg)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
--Effect 3
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMatchingGroupCount(aux.AND(Card.IsFaceup,Card.IsCode),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil,40010936)==0 then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end