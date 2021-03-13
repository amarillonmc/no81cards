--亡语邪法 恶灵巫术
function c99988042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99988042,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c99988042.cost)
	e1:SetTarget(c99988042.target)
	e1:SetOperation(c99988042.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99988042,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c99988042.settg)
	e2:SetOperation(c99988042.setop)
	c:RegisterEffect(e2)
end
function c99988042.tgfilter(c,tp)
	return c:GetOwner()~=tp and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c99988042.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.IsExistingMatchingCard(c99988042.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99988042.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99988042.filter(c,e,tp)
	return c:IsSetCard(0x20df) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99988042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==100 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then 
	    e:SetLabel(0)
		return res and Duel.IsExistingMatchingCard(c99988042.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99988042.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99988042.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c99988042.stfilter(c)
	return c:IsSetCard(0x20df) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c99988042.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c99988042.stfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c99988042.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c99988042.stfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCondition(c99988042.condition)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		tc:RegisterEffect(e2)
	end
end
function c99988042.setcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x20df) and c:GetOriginalRace()==RACE_FIEND
end
function c99988042.condition(e)
    return Duel.IsExistingMatchingCard(c99988042.setcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end 
