--究极异兽-喷射器之铁火辉夜
function c40008605.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,4,c40008605.ovfilter,aux.Stringid(40008605,0),4,c40008605.xyzop)
	c:EnableReviveLimit() 
	--special summon (hand)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008605,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c40008605.spcon1)
	e1:SetTarget(c40008605.target)
	e1:SetOperation(c40008605.activate)
	c:RegisterEffect(e1)	
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008605,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(c40008605.spcon)
	e2:SetTarget(c40008605.sptg)
	e2:SetOperation(c40008605.spop)
	c:RegisterEffect(e2)
end
function c40008605.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRank(8) and c:GetOverlayCount()>1
end
function c40008605.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40008605)==0 end
	Duel.RegisterFlagEffect(tp,40008605,RESET_PHASE+PHASE_END,0,1)
end
function c40008605.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c40008605.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c40008605.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c40008605.filter1,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c40008605.filter1,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c40008605.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c40008605.filter1,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
end
function c40008605.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>1 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c40008605.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40008605.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():GetOverlayGroup():IsExists(c40008605.spfilter,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
end
function c40008605.spop(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetOverlayGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=lg:FilterSelect(tp,c40008605.spfilter,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)>0 and c:IsRelateToEffect(e) and c:GetOverlayCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40008605,3))
		local mg=c:GetOverlayGroup():Select(tp,1,1,nil)
		local oc=mg:GetFirst():GetOverlayTarget()
		Duel.Overlay(tc,mg)
		Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	end
end