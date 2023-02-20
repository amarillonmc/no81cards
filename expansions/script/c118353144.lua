--彼岸の到達者 ダンテ
function c118353144.initial_effect(c)
    c:SetSPSummonOnce(118353144)
    c:EnableReviveLimit()
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_TO_GRAVE)
    e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetCondition(c118353144.sprcon)
    e0:SetOperation(c118353144.sprop)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c118353144.xyzcon)
    e1:SetOperation(c118353144.xyzop)
    e1:SetValue(SUMMON_TYPE_XYZ)
    c:RegisterEffect(e1)
    --tograve
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetDescription(aux.Stringid(118353144,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e2:SetCondition(c118353144.descon1)
    e2:SetCost(c118353144.descost)
    e2:SetTarget(c118353144.destg)
    e2:SetOperation(c118353144.desop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCondition(c118353144.descon2)
    c:RegisterEffect(e3)
    --battle damage reduce
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e4:SetCondition(c118353144.rdcon)
    e4:SetOperation(c118353144.rdop)
    c:RegisterEffect(e4)
    --disable
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetTargetRange(LOCATION_GRAVE,0)
    e5:SetTarget(c118353144.disable)
    e5:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e5)
    --
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(118353144)
    e6:SetRange(LOCATION_MZONE)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetTargetRange(1,0)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(10463)
    e7:SetRange(LOCATION_GRAVE)
    c:RegisterEffect(e7)
    --spsummon condition
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e8:SetCode(EFFECT_SPSUMMON_CONDITION)
    e8:SetValue(c118353144.splimit)
    c:RegisterEffect(e8)
    --act limit
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e9:SetCode(EVENT_SPSUMMON)
    e9:SetOperation(c118353144.limop)
    c:RegisterEffect(e9)
end

--replace tograve
local dc=Duel.DiscardDeck
Duel.DiscardDeck=function(tp,count,reason)
    if Duel.IsPlayerAffectedByEffect(tp,118353144) and Duel.IsExistingMatchingCard(c118353144.vafilter,tp,LOCATION_DECK,0,count,nil)
        and Duel.GetFlagEffect(tp,10463)==0 and Duel.SelectYesNo(tp,aux.Stringid(118353144,1)) then
        Duel.RegisterFlagEffect(tp,10463,RESET_PHASE+PHASE_END,0,1)
        Duel.Hint(HINT_CARD,0,118353144)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,c118353144.vafilter,tp,LOCATION_DECK,0,count,count,nil)
        return Duel.SendtoGrave(g,reason)
    else
        return dc(tp,count,reason)
    end
end
function c118353144.vafilter(c)
    return c:IsSetCard(0xb1) and c:IsType(TYPE_MONSTER) and (c:IsAbleToGrave() or c:IsAbleToGraveAsCost())
end

--avoid damage
local ad=Duel.Damage
Duel.Damage=function(tp,amount,reason)
    local ag=Duel.GetMatchingGroup(c118353144.adfilter,tp,LOCATION_GRAVE,0,nil)
    local def=ag:GetSum(Card.GetDefense)
    if Duel.IsPlayerAffectedByEffect(tp,10463) and amount>0 and def>=amount and Duel.SelectYesNo(tp,aux.Stringid(118353144,2)) then
        local sg=ag:SelectWithSumGreater(tp,Card.GetDefense,amount)
        Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
        return ad(tp,0,reason)
    else
        return ad(tp,amount,reason)
    end
end
function c118353144.adfilter(c)
    return c:IsSetCard(0xb1) and c:IsType(TYPE_MONSTER) and c:GetDefense()~=0 and c:IsAbleToDeck()
end

function c118353144.splimit(e,se,sp,st)
    return not e:GetHandler():IsLocation(LOCATION_EXTRA) or (bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and se:GetHandler():IsCode(118353144))
end

function c118353144.mfilter(c,xyzc)
    return c:GetFlagEffect(118353144)~=0 and c:IsCanBeXyzMaterial(xyzc)
end
function c118353144.xyzcon(e,c,og,min,max)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=nil
    if og then
        mg=og:Filter(c118353144.mfilter,nil,c)
    else
        mg=Duel.GetMatchingGroup(c118353144.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,c)
    end
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and mg:GetCount()>0
end
function c118353144.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
    local c=e:GetHandler()
    local g=nil
    local sg=Group.CreateGroup()
    local xyzg=Group.CreateGroup()
    if og then
        g=og
        local tc=og:GetFirst()
    else
        local mg=nil
        if og then
            mg=og:Filter(c118353144.mfilter,nil,c)
        else
            mg=Duel.GetMatchingGroup(c118353144.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,c)
        end
        local ct=mg:GetCount()
        xyzg:Merge(mg)
    end
    c:SetMaterial(xyzg)
    Duel.Overlay(c,xyzg)
end

function c118353144.sprcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:IsExists(c118353144.cxfilter,1,nil,tp)
        and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c118353144.cxfilter(c,tp)
    return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0xb1) and c:IsType(TYPE_MONSTER)
        and c:GetPreviousControler()==tp and not c:IsType(TYPE_XYZ)
end
function c118353144.cxfilter2(c,xyzc)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeXyzMaterial(xyzc) and c:IsLocation(LOCATION_GRAVE)
end
function c118353144.cxfilter3(c)
    return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)
end
function c118353144.sprop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=eg:Filter(c118353144.cxfilter2,nil,c)
    local g2=eg:Filter(c118353144.cxfilter3,nil)
    if g:GetCount()>0 and g:GetCount()==g2:GetCount() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
        and Duel.GetFlagEffect(tp,118353144)==0 and Duel.SelectYesNo(tp,aux.Stringid(118353144,3)) then
        Duel.RegisterFlagEffect(tp,118353144,RESET_PHASE+PHASE_END,0,1)
        Duel.ConfirmCards(1-tp,c)
        local tc=g:GetFirst()
        while tc do
            if tc:GetFlagEffect(118353144)==0 then
                local og=tc:GetOverlayGroup()
                if og:GetCount()>0 then
                    Duel.SendtoGrave(og,REASON_RULE)
                end
                tc:RegisterFlagEffect(118353144,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
            end
            tc=g:GetNext()
        end
        Duel.XyzSummon(tp,c,nil)
    end
end

function c118353144.bafilter(c)
    return c:IsSetCard(0xb1)
end
function c118353144.descon1(e,tp,eg,ep,ev,re,r,rp)
    local og=e:GetHandler():GetOverlayGroup():Filter(c118353144.bafilter,nil)
    return og:GetClassCount(Card.GetCode)<2
end
function c118353144.descon2(e,tp,eg,ep,ev,re,r,rp)
    local og=e:GetHandler():GetOverlayGroup():Filter(c118353144.bafilter,nil)
    return og:GetClassCount(Card.GetCode)>=2
end
function c118353144.cfilter(c)
    return c:IsSetCard(0xb1) and c:IsAbleToGraveAsCost()
end
function c118353144.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
        and Duel.IsExistingMatchingCard(c118353144.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c118353144.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c118353144.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_MZONE)
end
function c118353144.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end

function c118353144.rdcon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp
end
function c118353144.rdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c118353144.adfilter,tp,LOCATION_GRAVE,0,nil)
    local def=g:GetSum(Card.GetDefense)
    if ev>0 and ev<=def and Duel.SelectYesNo(tp,aux.Stringid(118353144,2)) then
        local sg=g:SelectWithSumGreater(tp,Card.GetDefense,ev)
        Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
        Duel.ChangeBattleDamage(tp,0)
    end
end

function c118353144.disable(e,c)
    return c:IsCode(118353144) and e:GetHandler()~=c
end

function c118353144.limop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetCurrentChain()==0 then return end
    Duel.SetChainLimitTillChainEnd(c118353144.chlimit)
end
function c118353144.chlimit(e,rp,tp)
    return e:IsActiveType(TYPE_TRAP) and e:GetHandler():IsType(TYPE_COUNTER)
end
