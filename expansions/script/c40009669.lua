--王冠圣域的圣决
local m=40009669
local cm=_G["c"..m]
cm.named_with_KeterSanctuary=1
function cm.KeterSanctuary(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_KeterSanctuary
end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1) 
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,40009670)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)   
end
function cm.cdisfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(8) 
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cdisfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetCategory(CATEGORY_NEGATE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsOnField() then
		local g=rc:GetColumnGroup()
		g:AddCard(rc)
		g=g:Filter(cm.tdfilter,nil,1-tp)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	end
end
function cm.tdfilter(c,tp)
	return c:IsControler(tp) and c:IsAbleToDeck() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and rc:IsOnField() then
		local g=rc:GetColumnGroup()
		g:AddCard(rc)
		g=g:Filter(cm.tdfilter,nil,1-tp)
		Duel.BreakEffect()
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function cm.cfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToRemoveAsCost()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.thfilter(c)
	return cm.KeterSanctuary(c) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsLevelAbove(8)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	e:SetLabel(0)
	if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) then e:SetLabel(1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if #g<=0 then return end
	local ct=1
	if e:GetLabel()==1 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	Duel.SendtoHand(sg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg1)
end
