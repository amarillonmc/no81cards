--花信物语 冬之契约
function c16372022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,16372022)
	e1:SetCondition(c16372022.condition)
	e1:SetCost(c16372022.cost)
	e1:SetTarget(c16372022.target)
	e1:SetOperation(c16372022.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(16372022,0))
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e11:SetCondition(c16372022.handcon)
	c:RegisterEffect(e11)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16372022)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c16372022.condition2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c16372022.target2)
	e2:SetOperation(c16372022.activate2)
	c:RegisterEffect(e2)
end
c16372022.fusion_effect=true
function c16372022.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c16372022.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xdc1) and c:IsAbleToGraveAsCost() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
		and c:GetOriginalType()&TYPE_MONSTER>0
end
function c16372022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16372022.cfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c16372022.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c16372022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c16372022.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	local g=Duel.GetMatchingGroup(c16372022.hfilter,tp,LOCATION_SZONE,0,nil):Filter(Card.IsAbleToGrave,nil)
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(16372022,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoGrave(sg,0x40)>0 and sg:GetFirst():IsLocation(LOCATION_GRAVE) then
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
function c16372022.hfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xdc1) and c:GetOriginalType()&TYPE_MONSTER>0
end
function c16372022.handcon(e)
	return Duel.IsExistingMatchingCard(c16372022.hfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,4,nil)
end
function c16372022.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xdc1) and c:GetSequence()<5
end
function c16372022.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c16372022.filter,tp,LOCATION_SZONE,0,3,nil)
end
function c16372022.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c16372022.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c16372022.filter,tp,LOCATION_SZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,2,2,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		if sg:GetFirst():IsLocation(LOCATION_GRAVE) then
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end