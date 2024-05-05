--武色P-暗紫爪狼

local id=32000422
local zd=0x3c5
function c32000422.initial_effect(c)
    --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,f1filter,f2filter,false,false)
	
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c32000422.e1limit)
	c:RegisterEffect(e1)
	
	--SpSumWhenCaining
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECAIL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,id)
	e2:SetTarget(c32000422.e2tg)
	e2:SetOperation(c32000422.e2op)
	c:RegisterEffect(e2)
	
	--DestoryHAndFThenSendOpField
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c32000422.e3tg)
	e3:SetOperation(c32000422.e3op)
    c:RegisterEffect(e3)
end

function f1filter(c)
    return c:IsSetCard(zd) and c:IsType(TYPE_MONSTER)
end

function f2filter(c)
   return c:IsSetCard(zd) and c:IsType(TYPE_TRAP)
end

--e1

function c32000422.e1limit(e,se,sp,st)
	return se:GetHandler():IsSetCard(zd) and se:GetHandlerPlayer()==e:GetHandlerPlayer()
end

--e2

function c32000422.e2spfilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end

function c32000422.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c32000422.e2spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end

function c32000422.e2op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c32000422.e2spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp)) then return end
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32000422.e2spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end

--e3

function c32000422.e3desfilter(c)
	return c:IsSetCard(zd) and c:IsDestructable()
end

function c32000422.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32000422.e3desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTORY,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
end

function c32000422.e3op(e,tp,eg,ep,ev,re,r,rp)
   
    if not (Duel.IsExistingMatchingCard(c32000422.e3desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)) then return end
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,c32000422.e3desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	
	Duel.Hint(HINT_SELECTMSG,TP,HINTMSG_TOGRAVE)
	local tgg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	
	Duel.Destroy(dg,REASON_EFFECT)
	Duel.SendtoGrave(tgg,nil,REASON_EFFECT)
end









