--终焉邪魂 死亡侵蚀
function c30000035.initial_effect(c)
	--Activate(summon)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30000035,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCountLimit(1,30000035)
	e1:SetCondition(c30000035.condition1)
	e1:SetCost(c30000035.cost)
	e1:SetTarget(c30000035.target1)
	e1:SetOperation(c30000035.activate1)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	--Activate(effect)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(30000035,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,30000036)
	e4:SetCondition(c30000035.condition2)
	e4:SetCost(c30000035.cost)
	e4:SetTarget(c30000035.target2)
	e4:SetOperation(c30000035.activate2)
	c:RegisterEffect(e4)
	--Activate(effect2)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(30000035,2))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCountLimit(1,30000037)
	e5:SetCondition(c30000035.condition3)
	e5:SetCost(c30000035.cost)
	e5:SetTarget(c30000035.target3)
	e5:SetOperation(c30000035.activate3)
	c:RegisterEffect(e5)
	--Activate(effect2)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1,30000038)
	e6:SetCost(c30000035.thcost)
	e6:SetTarget(c30000035.thtg)
	e6:SetOperation(c30000035.thop)
	c:RegisterEffect(e6)
end

function c30000035.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 
end
function c30000035.cfilter(c)
	return  c:IsAbleToRemoveAsCost() and not c:IsCode(30000035)
end
function c30000035.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30000035.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,5,nil) end
	local g=Duel.SelectMatchingCard(tp,c30000035.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,5,5,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c30000035.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c30000035.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end
function c30000035.condition2(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)) and Duel.IsChainNegatable(ev)
end
function c30000035.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c30000035.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end

function c30000035.condition3(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c30000035.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c30000035.activate3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end

function c30000035.thfilter(c)
	return c:IsAbleToRemoveAsCost() and not c:IsCode(30000035)
end
function c30000035.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30000035.thfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,7,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c30000035.thfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,7,7,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c30000035.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c30000035.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end