--武色W-透白铠虎

local id=32000425
local zd=0x3c5
function c32000425.initial_effect(c)
    --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,f1filter,f2filter,false,false)
	
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c32000425.e1limit)
	c:RegisterEffect(e1)
	
	--RemoveCostAndSTAdToHand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_GRAVE+LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(c32000425.e2cost)
	e2:SetTarget(c32000425.e2tg)
	e2:SetOperation(c32000425.e2op)
	c:RegisterEffect(e2)
	
	--ReturnCostAndMonsterSpSum
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,id)
	e3:SetCost(c32000425.e3cost)
	e3:SetTarget(c32000425.e3tg)
	e3:SetOperation(c32000425.e3op)
	c:RegisterEffect(e3)
	
end

function f1filter(c)
    return c:IsSetCard(zd) and c:IsType(TYPE_MONSTER)
end

function f2filter(c)
   return c:IsSetCard(zd)
end

--e1

function c32000425.e1limit(e,se,sp,st)
	return se:GetHandler():IsSetCard(zd) and se:GetHandlerPlayer()==e:GetHandlerPlayer()
end

--e2

function c32000425.e2tohfilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function c32000425.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_COST)
end
	
function c32000425.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c32000425.e2tohfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectTarget(tp,c32000425.e2tohfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)

	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function c32000425.e2op(e,tp,eg,ep,ev,re,r,rp)
     local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAbleToHand() then
	    Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--e3

function c32000425.e3spfilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()) and not c:IsCode(id)
end

function c32000425.e3cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToGraveAsCost(REASON_RETURN) end
    Duel.SendtoGrave(c,nil,REASON_EFFECT+REASON_RETURN+REASON_COST)
end
	
function c32000425.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c32000425.e3spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c32000425.e3spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)

	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function c32000425.e3op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
	    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end




