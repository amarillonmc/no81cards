--武色G-碧绿林鹿

local id=32000419
local zd=0x3c5
function c32000419.initial_effect(c)
    --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,f1filter,f2filter,false,false)
	
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c32000419.e1limit)
	c:RegisterEffect(e1)
	
	--AdToHandWhenSpSum
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetTarget(c32000419.e2tg)
	e2:SetOperation(c32000419.e2op)
	c:RegisterEffect(e2)
	
	--SpSumGAndRByRemoveSelf
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+1)
	e3:SetCost(c32000419.e3cost)
	e3:SetTarget(c32000419.e3tg)
	e3:SetOperation(c32000419.e3op)
	c:RegisterEffect(e3)
	
end

function f1filter(c)
    return c:IsSetCard(zd) and c:IsType(TYPE_MONSTER)
end

function f2filter(c)
   return c:IsSetCard(zd) and c:IsType(TYPE_SPELL)
end

--e1

function c32000419.e1limit(e,se,sp,st)
	return se:GetHandler():IsSetCard(zd) and se:GetHandlerPlayer()==e:GetHandlerPlayer()
end

--e2

function c32000419.e2tohfilter(c)
    return c:IsSetCard(zd) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function c32000419.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32000419.e2tohfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end

	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end

function c32000419.e2op(e,tp,eg,ep,ev,re,r,rp)
	 if not (Duel.IsExistingMatchingCard(c32000419.e2tohfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil)) then return end 
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32000419.e2tohfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end

--e3

function c32000419.e3spfilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()) and not c:IsCode(id)
end

function c32000419.e3cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToRemoveAsCost() end
    Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_COST)
end
	
function c32000419.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32000419.e3spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end

	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function c32000419.e3op(e,tp,eg,ep,ev,re,r,rp)
	 if not (Duel.IsExistingMatchingCard(c32000419.e3spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end 
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32000419.e3spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	
end



