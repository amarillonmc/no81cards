--墓 园 是 万 事 万 物 的 终 点
local m=22348134
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c22348134.cost)
	e1:SetTarget(c22348134.target)
	e1:SetOperation(c22348134.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK+LOCATION_HAND)
	c:RegisterEffect(e2)
	--code
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetValue(22348080)
	c:RegisterEffect(e3)
	--instant(chain)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348134,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCost(c22348134.cgcost)
	e3:SetTarget(c22348134.cgtarget)
	e3:SetOperation(c22348134.cgoperation)
	c:RegisterEffect(e3)
end
function c22348134.tgfilter(c)
	return c:IsSetCard(0x703)
end
function c22348134.tgcostfilter(c)
	return c:IsSetCard(0x703) and c:IsAbleToGraveAsCost() and not c:IsCode(22348134)
end
function c22348134.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348134.tgcostfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348134.tgcostfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22348134.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c22348134.tgfilter,tp,LOCATION_HAND,0,1,nil) and c:GetFlagEffect(22348134)==0  end
	c:RegisterFlagEffect(22348134,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c22348134.limit)
	end
end
function c22348134.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348134.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c22348134.limit(e,ep,tp)
	local c=e:GetHandler()
	return not (c:IsCode(22348134) and e:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c22348134.cgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c22348134.spfilter(c,e,ep)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c22348134.cgtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(ep,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22348134.spfilter,ep,LOCATION_GRAVE,0,1,nil,e,ep)  end
end
function c22348134.cgoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c22348134.spop)
end
function c22348134.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(ep,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,ep,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(ep,c22348134.spfilter,ep,LOCATION_GRAVE,0,1,1,nil,e,ep)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,ep,ep,false,false,POS_FACEUP)
	end
end



