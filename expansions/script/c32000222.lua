--红锈龙 烈蚀龙

local id=32000222
local zd=0xff6
function c32000222.initial_effect(c)
	--LinkSummon
	aux.AddLinkProcedure(c,nil,2,2,c32000222.lcheck)
	c:EnableReviveLimit()
	--SpecialSummonSelf
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_DESTROY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(c32000222.e1con)
	e1:SetTarget(c32000222.e1tg)
	e1:SetOperation(c32000222.e1op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e1:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(c32000222.e3con)
	e3:SetTarget(c32000222.e3tg)
	e3:SetOperation(c32000222.e3op)
	c:RegisterEffect(e3)
end

--LinkSummon

function c32000222.lxyzfilter(c)
    return c:IsType(TYPE_XYZ) and c:IsSetCard(zd) and c:GetOverlayCount()>=2
end

function c32000222.lcheck(g)
	return g:IsExists(c32000222.lxyzfilter,1,nil)
end

--e1

function c32000222.e1confilter(c)
	return c:IsSetCard(zd)
end

function c32000222.e1con(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c32000222.e1confilter,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
end

function c32000222.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
end

function c32000222.e1op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if not c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

--e3
function c32000222.e3con(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end

function c32000222.e3spfilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end

function c32000222.e3rmfilter(c)
	return c:IsSetCard(zd) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end

function c32000222.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32000222.e3rmfilter,tp,LOCATION_MZONE,0,2,nil) and Duel.IsExistingMatchingCard(c32000222.e3spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPSUMMON,nil,2,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function c32000222.e3op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.IsExistingMatchingCard(c32000222.e3rmfilter,tp,LOCATION_MZONE,0,2,nil) ) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c32000222.e3rmfilter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	
	if not (Duel.IsExistingMatchingCard(c32000222.e3spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil,e,tp) ) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c32000222.e3spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil,e,tp)
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
end








