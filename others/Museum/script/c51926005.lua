--炼金工具 铁之油灯
function c51926005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c51926005.condition)
	e1:SetTarget(c51926005.target)
	e1:SetOperation(c51926005.activate)
	c:RegisterEffect(e1)
	--negate damage
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCost(c51926005.cost)
	e2:SetOperation(c51926005.daop)
	c:RegisterEffect(e2)
end
function c51926005.cfilter(c)
	return c:IsCode(51926001) and c:IsFaceup()
end
function c51926005.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c51926005.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c51926005.spfilter(c,e,tp)
	return c:IsSetCard(0x3257) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c51926005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c51926005.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c51926005.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c51926005.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 and sc:IsCode(51926011) and
		Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) and
		Duel.SelectYesNo(tp,aux.Stringid(51926005,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.Destroy(g,nil,TYPE_EFFECT)
	end
end
function c51926005.tdfilter(c)
	return c:IsCode(51926011) and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function c51926005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c51926005.tdfilter,tp,LOCATION_REMOVED,0,1,nil)
		and c:IsAbleToDeckAsCost() end
	local g=Duel.SelectMatchingCard(tp,c51926005.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	g:AddCard(c)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c51926005.daop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetValue(1)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
