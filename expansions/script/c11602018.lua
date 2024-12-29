--大海爬兽 深渊远古沧龙

local s,id,o=GetID()
local zd=0x5224

function s.initial_effect(c)
    --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11602000,aux.FilterBoolFunction(Card.IsFusionType,TYPE_PENDULUM),1,true,true)
	
	--DoubleDemageWhenAtkDefMon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e1)
	
	--ExtraGraveSpSumOrToHand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
	
	--NegateSpSumAndToDeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.e3con)
	e3:SetCost(s.e3cost)
	e3:SetTarget(s.e3tg)
	e3:SetOperation(s.e3op)
	c:RegisterEffect(e3)
end

--e2
--ExtraGraveSpSumOrToHand

function s.e2spfilter(c,e,tp)
    return c:IsSetCard(zd) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and (not c:IsLocation(LOCATION_EXTRA) or c:IsFaceup())
end

function s.e2tohfilter(c)
    return c:IsSetCard(zd) and c:IsAbleToHand() and c:IsType(TYPE_PENDULUM) 
    and (not c:IsLocation(LOCATION_EXTRA) or c:IsFaceup())
end

function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bl1=Duel.IsExistingMatchingCard(s.e2tohfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil)
    local bl2=Duel.IsExistingMatchingCard(s.e2spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) 
	if chk==0 then return bl1 or bl2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA+LOCATION_GRAVE)
end

function s.e2op(e,tp,eg,ep,ev,re,r,rp)
    local bl1=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.e2tohfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil)
    local bl2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.e2spfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) 
    if not (bl1 or bl2) then return end
    local op=0
    if (bl1 and bl2) then
        op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
    elseif bl2 then
        op=1
    end
    
    if op==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.e2tohfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
    
    if op==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.e2spfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

--e3

function s.e3spfilter(c,tp)
	return c:IsSummonPlayer(tp)
end

function s.e3con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(s.e3spfilter,1,nil,1-tp)
end

function s.e3costfilter(c)
    return c:IsSetCard(zd) and c:IsType(TYPE_FUSION) and c:IsReleasable()
end

function s.e3cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(s.e3costfilter,tp,LOCATION_MZONE,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,s.e3costfilter,tp,LOCATION_MZONE,0,1,1,c)
    Duel.Release(g,REASON_COST)
end

function s.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end

function s.e3op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.NegateSummon(eg)
	Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
end


