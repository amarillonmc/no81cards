--邪魂 暗之祭坛
function c30012000.initial_effect(c)
	c:EnableCounterPermit(0x920)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(c30012000.ctop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c30012000.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--Atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
	e5:SetCondition(c30012000.atkcon)
	e5:SetValue(c30012000.atkval)
	c:RegisterEffect(e5)
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(30012000,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c30012000.thcon)
	e6:SetTarget(c30012000.thtg)
	e6:SetOperation(c30012000.thop)
	c:RegisterEffect(e6)
	local e16=e6:Clone()
	e16:SetType(EFFECT_TYPE_QUICK_O)
	e16:SetCode(EVENT_FREE_CHAIN)
	e16:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e16:SetCondition(c30012000.thcon2)
	c:RegisterEffect(e16)
	--5 counter
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(30012000,1))
	e7:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e7:SetCondition(c30012000.condition1)
	e7:SetCost(c30012000.cost1)
	e7:SetTarget(c30012000.target1)
	e7:SetOperation(c30012000.operation1)
	c:RegisterEffect(e7)
	local e17=e7:Clone()
	e17:SetType(EFFECT_TYPE_QUICK_O)
	e17:SetCode(EVENT_FREE_CHAIN)
	e17:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e17:SetCondition(c30012000.condition2)
	c:RegisterEffect(e17)
	--7 counter
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(30012000,2))
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_FZONE)
	e8:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e8:SetCondition(c30012000.condition1)
	e8:SetCost(c30012000.cost2)
	e8:SetTarget(c30012000.target2)
	e8:SetOperation(c30012000.operation2)
	c:RegisterEffect(e8)
	local e18=e8:Clone()
	e18:SetType(EFFECT_TYPE_QUICK_O)
	e18:SetCode(EVENT_FREE_CHAIN)
	e18:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e18:SetCondition(c30012000.condition2)
	c:RegisterEffect(e18)
	--10 counter
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(30012000,3))
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_FZONE)
	e9:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e9:SetCondition(c30012000.condition1)
	e9:SetCost(c30012000.cost3)
	e9:SetTarget(c30012000.target3)
	e9:SetOperation(c30012000.operation3)
	c:RegisterEffect(e9)
	local e19=e9:Clone()
	e19:SetType(EFFECT_TYPE_QUICK_O)
	e19:SetCode(EVENT_FREE_CHAIN)
	e19:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e19:SetCondition(c30012000.condition2)
	c:RegisterEffect(e19)
end
function c30012000.ctfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function c30012000.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c30012000.ctfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x920,ct)
	end
end
function c30012000.indcon(e)
	return e:GetHandler():GetCounter(0x920)>=3
end
function c30012000.atkcon(e)
	return e:GetHandler():GetCounter(0x920)>=5
end
function c30012000.atkval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED)*100
end
function c30012000.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x920)>=7 and not Duel.IsPlayerAffectedByEffect(tp,30000010)
end
function c30012000.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x920)>=7 and Duel.IsPlayerAffectedByEffect(tp,30000010)
end
function c30012000.thfilter(c)
	return c:IsSetCard(0x920) and c:IsAbleToHand()
end
function c30012000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30012000.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c30012000.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c30012000.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c30012000.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,30000010)
end
function c30012000.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,30000010)
end
function c30012000.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x920,5,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x920,5,REASON_COST)
end
function c30012000.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanRemove(tp) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c30012000.operation1(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c30012000.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x920,7,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x920,7,REASON_COST)
end
function c30012000.thfilter2(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c30012000.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30012000.thfilter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c30012000.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c30012000.thfilter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c30012000.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x920,10,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x920,10,REASON_COST)
end
function c30012000.spfilter(c,e,tp)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED)) and c:IsSetCard(0x920)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c30012000.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c30012000.spfilter,tp,loc,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c30012000.operation3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local loc=LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c30012000.spfilter,tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
