--创生原核
function c9910813.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6951),3,true)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910813,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910813)
	e1:SetCondition(c9910813.condition1)
	e1:SetCost(c9910813.discost)
	e1:SetTarget(c9910813.distg)
	e1:SetOperation(c9910813.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9910813.condition2)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910813,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9910814)
	e3:SetCondition(c9910813.condition1)
	e3:SetCost(c9910813.descost)
	e3:SetTarget(c9910813.destg)
	e3:SetOperation(c9910813.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(c9910813.condition2)
	c:RegisterEffect(e4)
end
function c9910813.filter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6951)
end
function c9910813.condition1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910813.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)<3
end
function c9910813.condition2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910813.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=3
end
function c9910813.rfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemoveAsCost()
end
function c9910813.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910813.rfilter,tp,LOCATION_GRAVE,0,1,nil,9910803) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910813.rfilter,tp,LOCATION_GRAVE,0,1,1,nil,9910803)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9910813.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c9910813.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c9910813.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910813.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9910813.disfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c9910813.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
function c9910813.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910813.rfilter,tp,LOCATION_GRAVE,0,1,nil,9910805) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910813.rfilter,tp,LOCATION_GRAVE,0,1,1,nil,9910805)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9910813.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9910813.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
