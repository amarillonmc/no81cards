--浮华若梦·绮梦绮夜
function c65860050.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa36),aux.FilterBoolFunction(Card.IsFusionType,TYPE_MONSTER),1,true)
	aux.AddContactFusionProcedure(c,c65860050.ffilter,LOCATION_MZONE+LOCATION_HAND,0,Duel.Release,REASON_SPSUMMON):SetCountLimit(1,65860050)
	--spsummon cost
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(65860050,0))
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_COST)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCost(c65860050.spcost)
	e5:SetOperation(c65860050.spcop)
	c:RegisterEffect(e5)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65860050,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,65860050+1)
	e3:SetTarget(c65860050.target)
	e3:SetOperation(c65860050.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
end

function c65860050.ffilter(c,fc,sub,mg,sg)
	return c:IsSetCard(0xa36) and Duel.IsPlayerCanRelease(c:GetControler()) and c:IsType(TYPE_MONSTER)
end

function c65860050.filter(c,fc,sub,mg,sg)
	return (Duel.GetLocationCountFromEx(tp,tp,c)>0 or Duel.GetMZoneCount(tp,c)>0) and c:IsAbleToDeckOrExtraAsCost()
end
function c65860050.spcost(e,c,tp)
	return Duel.IsExistingMatchingCard(c65860050.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp)
end
function c65860050.spcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(e:GetHandlerPlayer(),c65860050.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),tp)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	end
end

function c65860050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c65860050.spfilter1(c,e,tp)
	return (not c:IsSetCard(0xa36) or c:IsFacedown()) and c:IsAbleToDeck()
end
function c65860050.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then 
	local g=Duel.GetMatchingGroup(c65860050.spfilter1,tp,LOCATION_ONFIELD,0,nil,e,tp)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65860050.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end
function c65860050.splimit(e,c)
	return not c:IsSetCard(0xa36) and c:IsLocation(LOCATION_EXTRA)
end