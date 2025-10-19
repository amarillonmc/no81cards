--璀璨原钻绽放
function c11607024.initial_effect(c)
	-- 无效效果
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetCountLimit(1,11607024+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11607024.condition)
	e1:SetTarget(c11607024.target)
	e1:SetOperation(c11607024.activate)
	c:RegisterEffect(e1)
	-- 墓效回收
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11607024,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c11607024.tdcost)
	e2:SetTarget(c11607024.tdtg)
	e2:SetOperation(c11607024.tdop)
	c:RegisterEffect(e2)
end
-- 1
function c11607024.cfilter(c)
	return c:IsSetCard(0x6225) and c:IsType(TYPE_MONSTER)
end
function c11607024.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_DISABLED)
end
function c11607024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11607024.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	e:SetLabelObject(re)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function c11607024.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c11607024.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
-- 2
function c11607024.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
	Duel.ShuffleDeck(tp)
end
function c11607024.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g1=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,e:GetHandler(),0x6225)
	local g2=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_REMOVED,0,nil,0x6225)
	g1:Merge(g2)
	if #g1>0 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0)
	end
end
function c11607024.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x6225)
	local g2=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_REMOVED,0,nil,0x6225)
	g1:Merge(g2)
	if #g1==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g1:Select(tp,1,4,nil)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end
