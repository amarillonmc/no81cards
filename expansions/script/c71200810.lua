--深渊的呼唤VIII “伊始新篇”
local cm, m = GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71200800)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cos1(1))
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(cm.con2)
	e2:SetCost(cm.cos1(2))
	e2:SetTarget(cm.tg2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+100)
	e3:SetCondition(cm.con3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
--e1
function cm.cos1(n)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,n,REASON_COST) end
		e:GetHandler():RemoveOverlayCard(tp,n,n,REASON_COST)
	end
end
function cm.e1f1(c,e)
	return c:IsCanBeEffectTarget(e) and aux.NegateMonsterFilter(c) 
		and c:IsLocation(LOCATION_MZONE) and c:IsCanTurnSet()
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = Duel.GetMatchingGroup(cm.e1f1,tp,0,LOCATION_MZONE,nil,e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	g = g:Select(tp,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	if not (tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e)) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	tc:RegisterEffect(e2)
	if tc:IsType(TYPE_TRAPMONSTER) then
		local e3=e1:Clone()
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		tc:RegisterEffect(e3)
	end
	Duel.AdjustInstantly()
	Duel.NegateRelatedChain(tc,0)
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rc = re:GetHandler()
	if chkc then return false end
	if chk==0 then return cm.e1f1(rc,e) and rc:IsRelateToEffect(re) end
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,rc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,rc,1,0,0)
end
--e3
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.e3f1(c)
	return c:IsSetCard(0x899) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = Duel.GetMatchingGroup(cm.e3f1,tp,LOCATION_GRAVE,0,nil)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 and e:GetHandler():IsAbleToExtra() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	g = g:Select(tp,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0
		and c:IsLocation(LOCATION_EXTRA) and tc:IsRelateToEffect(e) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
	end
end
