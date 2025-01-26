--浮华若梦·绮梦绮梦
function c65860035.initial_effect(c)
	c:SetSPSummonOnce(65860035)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(65860035,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e0:SetCondition(c65860035.ttcon)
	e0:SetOperation(c65860035.ttop)
	c:RegisterEffect(e0)
	--spsummon cost
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(65860035,0))
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_COST)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e5:SetCost(c65860035.spcost)
	e5:SetOperation(c65860035.spcop)
	c:RegisterEffect(e5)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65860035,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c65860035.target)
	e1:SetOperation(c65860035.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
end
function c65860035.filter1(c,e,tp)
	return c:IsSetCard(0xa36) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(65860035)
end
function c65860035.ttcon(e,c,minc)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c65860035.filter1,e:GetHandlerPlayer(),LOCATION_HAND+LOCATION_DECK,0,1,e:GetHandler(),e,tp)
end
function c65860035.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(e:GetHandlerPlayer(),c65860035.filter1,e:GetHandlerPlayer(),LOCATION_HAND+LOCATION_DECK,0,1,1,e:GetHandler(),e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c65860035.spcost(e,c,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c65860035.filter1,e:GetHandlerPlayer(),LOCATION_HAND+LOCATION_DECK,0,1,e:GetHandler(),e,tp)
end
function c65860035.spcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(e:GetHandlerPlayer(),c65860035.filter1,e:GetHandlerPlayer(),LOCATION_HAND+LOCATION_DECK,0,1,1,e:GetHandler(),e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c65860035.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c65860035.spfilter(c,e,tp)
	return (not c:IsSetCard(0xa36) or c:IsFacedown()) and c:IsAbleToDeck()
end
function c65860035.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then 
	local g=Duel.GetMatchingGroup(c65860035.spfilter,tp,LOCATION_ONFIELD,0,nil,e,tp)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65860035.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end
function c65860035.splimit(e,c)
	return not c:IsSetCard(0xa36) and c:IsLocation(LOCATION_EXTRA)
end