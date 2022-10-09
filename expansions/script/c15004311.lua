local m=15004311
local cm=_G["c"..m]
cm.name="劫恶虺·乌鲁塔赫"
function cm.initial_effect(c)
	--replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.cbcon)
	e1:SetOperation(cm.cbop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.cecon)
	e2:SetOperation(cm.ceop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,15004311)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.cptg)
	e3:SetOperation(cm.cpop)
	c:RegisterEffect(e3)
end
function cm.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.GetAttacker():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	ag:RemoveCard(at)
	return Duel.GetAttacker():IsControler(1-tp) and at:IsControler(tp)
		and #ag~=0 and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cbop(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.GetAttacker():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	ag:RemoveCard(at)
	if ag:GetCount()~=0 and Duel.GetFlagEffect(tp,15004311)==0 and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.Hint(HINT_CARD,1-tp,15004311)
		local bg=ag:Select(tp,1,1,nil)
		Duel.HintSelection(bg)
		Duel.ChangeAttackTarget(bg:GetFirst())
		Duel.RegisterFlagEffect(tp,15004311,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
	end
end
function cm.cecon(e,tp,eg,ep,ev,re,r,rp)
	if e==re or rp~=1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsLocation(LOCATION_MZONE) and Duel.IsExistingMatchingCard(cm.cefilter,tp,LOCATION_MZONE,0,1,tc,ev,tc) and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cefilter(c,ct,oc)
	return oc~=c and Duel.CheckChainTarget(ct,c)
end
function cm.ceop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local ag=Duel.GetMatchingGroup(cm.cefilter,tp,LOCATION_MZONE,0,tg,ev,tg:GetFirst())
	if ag:GetCount()~=0 and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.Hint(HINT_CARD,1-tp,15004311)
		local bg=ag:Select(tp,1,1,nil)
		Duel.HintSelection(bg)
		Duel.ChangeTargetCard(ev,bg)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFacedown() and e:GetHandler():IsCanChangePosition() end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function cm.sfilter(c)
	return c:IsSetCard(0xf3b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(15004311)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	local x=Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	if x<=2 and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end