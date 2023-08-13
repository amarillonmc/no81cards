--煉獄の獄炎機
function c49811170.initial_effect(c)
	--splimit
	c:SetSPSummonOnce(49811170)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c49811170.matfilter,1,1)
	--extra summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811171,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c49811170.spcon)
    e1:SetOperation(c49811170.spop)
    c:RegisterEffect(e1)
    --set
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811170,1))
    e2:SetCategory(CATEGORY_)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c49811170.stcost)
    e2:SetTarget(c49811170.sttg)
    e2:SetOperation(c49811170.stop)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811170,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,49811170+EFFECT_COUNT_CODE_DUEL)
    e3:SetCost(aux.bfgcost)
    e3:SetCondition(c49811170.spcon2)
    e3:SetTarget(c49811170.sptg2)
    e3:SetOperation(c49811170.spop2)
    c:RegisterEffect(e3)
end
function c49811170.matfilter(c)
	return c:IsLinkRace(RACE_FIEND)
end
function c49811170.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FIEND) and c:IsAbleToGraveAsCost()
end
function c49811170.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
        and Duel.IsExistingMatchingCard(c49811170.cfilter,tp,LOCATION_HAND,0,1,c)
end
function c49811170.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c49811170.cfilter,tp,LOCATION_HAND,0,1,1,c)
    Duel.SendtoGrave(g,REASON_COST)
end
function c49811170.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c49811170.stfilter(c,tp)
    return c:IsSetCard(0xc5) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
        and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c49811170.gselect(g,ft)
	local fc=g:FilterCount(Card.IsType,nil,TYPE_FIELD)
	return fc<=1 and aux.dncheck(g) and #g-fc<=ft
end	
function c49811170.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811170.stfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
end
function c49811170.stop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local mt=math.min(ft+1,ht)
	if mt<=0 then return end
	local dg=Duel.GetMatchingGroup(c49811170.stfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if dg:GetCount()==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=dg:SelectSubGroup(tp,c49811170.gselect,false,1,mt,ft)
    if g:GetCount()>0 then
        local sn=Duel.SSet(tp,g)
        Duel.BreakEffect()
        if sn<=0 then return end
        Duel.DiscardHand(tp,nil,sn,sn,REASON_EFFECT+REASON_DISCARD)
    end    
end
function c49811170.spfilter(c)
    return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0xc5)
end
function c49811170.spcon2(e)
    local tp=e:GetHandlerPlayer()
    local g=Duel.GetMatchingGroup(c49811170.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
    return g:GetClassCount(Card.GetCode)>=7
end
function c49811170.spfilter2(c,e,tp)
    return c:IsRace(RACE_FIEND) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
        and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0
            or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c49811170.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811170.spfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c49811170.spop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c49811170.spfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
    end
end