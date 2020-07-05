--端午节的觉醒兔丸
function c8709008.initial_effect(c)
   --xyz summon
	aux.AddXyzProcedure(c,nil,3,2,c8709008.ovfilter,aux.Stringid(8709008,0),2,c8709008.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c8709008.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c8709008.defval)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8709008,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c8709008.spcost1)
	e3:SetTarget(c8709008.sptg1)
	e3:SetOperation(c8709008.spop1)
	c:RegisterEffect(e3)


   
end
function c8709008.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xafa) and not c:IsCode(8709008)
end
function c8709008.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,8709008)==0 end
	Duel.RegisterFlagEffect(tp,8709008,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c8709008.atkfilter(c)
	return c:IsSetCard(0xafa) and c:GetAttack()>=0
end
function c8709008.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c8709008.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c8709008.deffilter(c)
	return c:IsSetCard(0xafa) and c:GetDefense()>=0
end
function c8709008.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c8709008.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end

function c8709008.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c8709008.spfilter1(c,e,tp)
	return c:IsSetCard(0xafa) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c8709008.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c8709008.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c8709008.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c8709008.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end






