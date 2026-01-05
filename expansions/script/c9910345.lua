--神树勇者的回望
function c9910345.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c9910345.condition)
	e1:SetTarget(c9910345.target)
	e1:SetOperation(c9910345.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910345+EFFECT_COUNT_CODE_DUEL)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910345.sptg)
	e2:SetOperation(c9910345.spop)
	c:RegisterEffect(e2)
end
function c9910345.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:IsType(TYPE_SYNCHRO)
end
function c9910345.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910345.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c9910345.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9910345.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c9910345.spfilter(c,e,tp)
	return c:IsSetCard(0x3956,0x5956) and c:IsCanBeEffectTarget(e)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c9910345.fselect(g)
	if #g==1 then return true end
	return aux.gfcheck(g,Card.IsSetCard,0x3956,0x5956)
end
function c9910345.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9910345.spfilter(chkc,e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c9910345.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return ft>0 and #g>0 end
	ft=math.min(ft,2)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c9910345.fselect,false,1,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,#sg,0,0)
end
function c9910345.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local sg=Duel.GetTargetsRelateToChain()
	if #sg==0 then return end
	if #sg>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if #sg>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
