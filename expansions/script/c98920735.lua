--银河电子龙
function c98920735.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920735,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920735)
	e1:SetCost(c98920735.spcost)
	e1:SetTarget(c98920735.sptg)
	e1:SetOperation(c98920735.spop)
	c:RegisterEffect(e1)
	--atk change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920735,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98930735)
	e1:SetCondition(c98920735.atkcon)
	e1:SetTarget(c98920735.atktg)
	e1:SetOperation(c98920735.atkop)
	c:RegisterEffect(e1)
end
function c98920735.costfilter(c)
	return c:IsSetCard(0x107b) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c98920735.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920735.costfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920735.costfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98920735.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920735.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920735.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c98920735.atkfilter(c)
	return c:IsFaceup() and not (c:IsLevelAbove(8) and c:IsType(TYPE_FUSION))
end
function c98920735.atkfilter1(c)
	return c98920735.atkfilter(c) and c:GetAttack()>0
end
function c98920735.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasableByEffect()
		and Duel.IsExistingMatchingCard(c98920735.relfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp,c)
		and Duel.IsExistingMatchingCard(c98920735.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c98920735.relfilter(c,tp,ec)
	return c:IsReleasableByEffect() and c:IsAttackAbove(2000) and c:IsFaceup()
		and Duel.GetMZoneCount(tp,Group.FromCards(c,ec))>0
end
function c98920735.spfilter(c,e,tp)
	return c:IsSetCard(0x107b) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c98920735.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c98920735.relfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,tp,c)
	if g:GetCount()==0 then return end
	g:AddCard(c)
	if Duel.Release(g,REASON_EFFECT)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c98920735.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end