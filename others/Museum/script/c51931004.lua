--骑军之魔棋阵
function c51931004.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,51931004)
	e1:SetCost(c51931004.descost)
	e1:SetTarget(c51931004.destg)
	e1:SetOperation(c51931004.desop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,51931005)
	e2:SetCost(c51931004.setcost)
	e2:SetTarget(c51931004.settg)
	e2:SetOperation(c51931004.setop)
	c:RegisterEffect(e2)
end
function c51931004.costfilter(c)
	return c:IsSetCard(0x6258) and c:IsAbleToRemoveAsCost() and c:IsFaceup()
end
function c51931004.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51931004.costfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c51931004.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c51931004.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,1-tp,LOCATION_ONFIELD)
end
function c51931004.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,2,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,2,2,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c51931004.rmfilter(c)
	return c:IsSetCard(0x6258) and c:IsAbleToRemoveAsCost()
end
function c51931004.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51931004.rmfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c51931004.rmfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	sg:AddCard(e:GetHandler())
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c51931004.setfilter(c,tp)
	return c:IsSetCard(0x6258) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c51931004.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c51931004.setfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c51931004.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c51931004.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
