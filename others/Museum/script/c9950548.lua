--葛饰北斋-富岳三十六景
function c9950548.initial_effect(c)
	 aux.AddCodeList(c,9950528,9950555)
	c:EnableReviveLimit()
	--Cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950548.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
  --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950548,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c9950548.spcon2)
	e1:SetCost(c9950548.spcost)
	e1:SetTarget(c9950548.sptg2)
	e1:SetOperation(c9950548.spop2)
	c:RegisterEffect(e1)
   c9950548.discard_effect=e1
--to grave
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TOGRAVE)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE)
	e8:SetHintTiming(0,TIMING_MAIN_END)
	e8:SetCountLimit(1,9950548)
	e8:SetTarget(c9950548.tgtg)
	e8:SetOperation(c9950548.tgop)
	c:RegisterEffect(e8)
 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950548,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,99505481)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c9950548.spcon)
	e2:SetTarget(c9950548.sptg)
	e2:SetOperation(c9950548.spop)
	c:RegisterEffect(e2)
end
c9950548.assault_name=9950547
function c9950548.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950548,0))
end
function c9950548.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9950548.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9950548.rmfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xba5) and c:IsAbleToRemove() and c:GetOwner()==1-tp
end
function c9950548.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950548.rmfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
end
function c9950548.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c9950548.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950548.rmfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c9950548.spfilter2),tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(9950548,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9950548.spfilter2),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9950548.spfilter(c,e,tp)
	return c:IsCode(9950547)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c9950548.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c9950548.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(c9950548.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c9950548.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 or not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c9950548.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end
function c9950548.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE+LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_MZONE+LOCATION_HAND)
end
function c9950548.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950548,0))
end