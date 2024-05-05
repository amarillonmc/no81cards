--红锈再起
local id=32000226
local zd=0xff6
function c32000226.initial_effect(c)
    c:SetUniqueOnField(1,0,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    --IgnitionToSpSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c32000226.e2tg)
	e2:SetOperation(c32000226.e2op)
	c:RegisterEffect(e2)
    --DestoryAndRemoveThen
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
    e3:SetCountLimit(1,id+1+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c32000226.e3tg)
	e3:SetOperation(c32000226.e3op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
end

--e2

function c32000226.e2spfilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c32000226.e2rmfilter(c)
	return c:IsSetCard(zd) and c:IsAbleToRemove() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(zd)
end

function c32000226.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32000226.e2spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end

function c32000226.e2op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.IsExistingMatchingCard(c32000226.e2spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32000226.e2spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	
	if not (Duel.IsExistingMatchingCard(c32000226.e2rmfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,HINTMSG_REMOVE))
	then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c32000226.e2rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
end

--e3

function c32000226.e3spfilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c32000226.e3confilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsAbleToHand() and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end

function c32000226.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32000226.e3spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function c32000226.e3op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.IsExistingMatchingCard(c32000226.e3spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32000226.e3spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	
	local g2=Duel.GetMatchingGroup(c32000226.e3confilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	
	if not ( g2:GetClassCount(Card.GetCode)>=6 and Duel.SelectYesNo(tp,HINTMSG_ATOHAND))
	then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ADTOHAND)
	local g3=Duel.SelectMatchingCard(tp,c32000226.e3confilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    Duel.SendtoHand(g3,tp,REASON_EFFECT)
end







