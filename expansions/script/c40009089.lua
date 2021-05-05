--光之牙 加尔莫尔
function c40009089.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEAST),6,2,c40009089.ovfilter,aux.Stringid(40009089,0),2,c40009089.xyzop)   
	--ATK Up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009089,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c40009089.atkcon)
	e1:SetCost(c40009089.thcost)
	e1:SetTarget(c40009089.sptg2)
	e1:SetOperation(c40009089.spop2)
	c:RegisterEffect(e1)
	--disable special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009089,2))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40009089)
	e1:SetCondition(c40009089.discon)
	e1:SetCost(c40009089.discost)
	e1:SetTarget(c40009089.target)
	e1:SetOperation(c40009089.activate)
	c:RegisterEffect(e1)
end
function c40009089.ovfilter(c)
	return c:IsFaceup() and c:IsCode(40009088)
end
function c40009089.cfilter1(c)
	return c:IsFaceup() and c:IsCode(40009087) and c:IsCanOverlay()
end
function c40009089.xyzop(e,tp,chk,mc)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009089.cfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,c40009089.cfilter1,tp,LOCATION_MZONE,0,2,2,nil,tp)
	if g1:GetCount()>0 then
		Duel.Overlay(mc,g1)
	end
end
function c40009089.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c40009089.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c40009089.spfilter(c,e,tp)
	return (c:IsCode(40009086) or c:IsCode(40009087)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009089.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40009089.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c40009089.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009089.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c40009089.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnPlayer()~=tp and rp==1-tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c40009089.costfilter(c,tp)
	return c:IsCode(40009087) and (c:IsControler(tp) or c:IsFaceup())
end
function c40009089.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,40009087) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,2,nil,40009087)
	local rct=Duel.Release(g,REASON_COST)
	e:SetLabel(rct)
end
function c40009089.target(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c40009089.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	local ct=e:GetLabel()
	if ct==2 then
	Duel.BreakEffect()
	Duel.SkipPhase(1-tp,Duel.GetCurrentPhase(),RESET_PHASE+PHASE_END,1)
	end
end