--覚醒の操手 レックス
function c260013010.initial_effect(c)
    c:EnableReviveLimit()
    c:SetSPSummonOnce(260013010)
    --special summon rule
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_CHAINING)
    e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e6:SetRange(LOCATION_EXTRA)
    e6:SetCondition(c260013010.chcon)
    e6:SetOperation(c260013010.chop)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e7:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e7:SetRange(LOCATION_EXTRA)
    e7:SetCode(EVENT_BE_BATTLE_TARGET)
    e7:SetCondition(c260013010.atcon)
    e7:SetOperation(c260013010.atop)
    c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
    e8:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetCode(EFFECT_SPSUMMON_PROC)
    e8:SetRange(LOCATION_EXTRA)
    e8:SetCondition(c260013010.xyzcon)
    e8:SetOperation(c260013010.xyzop)
    e8:SetValue(SUMMON_TYPE_XYZ)
    c:RegisterEffect(e8)
    --spsummon condition
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e9:SetCode(EFFECT_SPSUMMON_CONDITION)
    e9:SetValue(c260013010.splimit)
    c:RegisterEffect(e9)
    --act limit
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e10:SetCode(EVENT_SPSUMMON)
    e10:SetOperation(c260013010.limop)
    c:RegisterEffect(e10)
    --【ここまでX召喚ルール】
        
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetTarget(c260013010.sptg)
    e3:SetOperation(c260013010.spop)
    c:RegisterEffect(e3)
    
    --negate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c260013010.discon)
    e1:SetCost(c260013010.discost)
    e1:SetTarget(c260013010.distg)
    e1:SetOperation(c260013010.disop)
    c:RegisterEffect(e1)
    --destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c260013010.desreptg)
    e2:SetValue(c260013010.desrepval)
    e2:SetOperation(c260013010.desrepop)
    c:RegisterEffect(e2)    
    
    
end


--【召喚ルール】
function c260013010.cfilter(c,xyzc,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x944) and not c:IsType(TYPE_XYZ)
        and c:IsCanBeXyzMaterial(xyzc) and c:IsFaceup()
end
function c260013010.chcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(c260013010.cfilter,1,nil,c,tp) and Duel.IsChainNegatable(ev) and re:GetHandler():IsRelateToEffect(re)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c260013010.xyzfilter(c,e,tp,xyzc)
    return not c:IsType(TYPE_TOKEN) and (c:IsCanBeXyzMaterial(xyzc) or not c:IsType(TYPE_MONSTER))
end
function c260013010.xyzfilter2(c,e,tp)
    return not c:IsType(TYPE_TOKEN)
end
function c260013010.chop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=re:GetHandler()
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(c260013010.xyzfilter,nil,e,tp,c)
    local g2=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(c260013010.xyzfilter2,nil,e,tp)
    if Duel.GetFlagEffect(tp,260013010)==0 and g:GetCount()>0 and g:GetCount()==g2:GetCount() and rc:IsRelateToEffect(re)
        and Duel.IsChainNegatable(ev) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and Duel.SelectYesNo(tp,aux.Stringid(260013010,0)) then
        Duel.ConfirmCards(1-tp,c)
        Duel.RegisterFlagEffect(tp,260013010,RESET_PHASE+PHASE_END,0,1)
        if Duel.NegateEffect(ev) then
            rc:CancelToGrave()
            g:AddCard(rc)
            local tc=g:GetFirst()
            while tc do
                local og=tc:GetOverlayGroup()
                if og:GetCount()>0 then
                    Duel.SendtoGrave(og,REASON_RULE)
                end
                tc:RegisterFlagEffect(260013010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
                tc=g:GetNext()
            end
            Duel.XyzSummon(tp,c,nil)
        end
    end
end

function c260013010.atcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=eg:GetFirst()
    return tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0x944) and not tc:IsType(TYPE_TOKEN) and not tc:IsType(TYPE_XYZ)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c260013010.atop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    if not (Duel.GetLocationCountFromEx(tp,tp,a,c)>0 or Duel.GetLocationCountFromEx(tp,tp,d,c)>0) then return end
    if not a:IsRelateToEffect(e) and a:IsAttackable() and not a:IsStatus(STATUS_ATTACK_CANCELED)
        and a:IsCanBeXyzMaterial(c) and d:IsCanBeXyzMaterial(c)
        and not d:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(260013010,0)) then
        Duel.ConfirmCards(1-tp,c)
        if Duel.NegateAttack() then
            local g=Group.FromCards(a,d)
            local tc=g:GetFirst()
            while tc do
                local og=tc:GetOverlayGroup()
                if og:GetCount()>0 then
                    Duel.SendtoGrave(og,REASON_RULE)
                end
                tc:RegisterFlagEffect(260013010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
                tc=g:GetNext()
            end
            Duel.XyzSummon(tp,c,nil)
        end
    end
end

function c260013010.mfilter(c,xyzc)
    return c:GetFlagEffect(260013010)~=0 and (c:IsCanBeXyzMaterial(xyzc) or not c:IsType(TYPE_MONSTER))
end
function c260013010.xyzcon(e,c,og,min,max)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=nil
    if og then
        mg=og:Filter(c260013010.mfilter,nil,c)
    else
        mg=Duel.GetMatchingGroup(c260013010.mfilter,tp,0xff,0xff,nil,c)
    end
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and mg:GetCount()>0
end
function c260013010.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
            mg=og:Filter(c260013010.mfilter,nil,c)
        else
            mg=Duel.GetMatchingGroup(c260013010.mfilter,tp,0xff,0xff,nil,c)
        end
        local ct=mg:GetCount()
        xyzg:Merge(mg)
    end
    c:SetMaterial(xyzg)
    Duel.Overlay(c,xyzg)
end

function c260013010.splimit(e,se,sp,st)
    return not e:GetHandler():IsLocation(LOCATION_EXTRA) or (bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and se:GetHandler():IsCode(260013010))
end

function c260013010.limop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetCurrentChain()==0 then return end
    Duel.SetChainLimitTillChainEnd(c260013010.chlimit)
end
function c260013010.chlimit(e,rp,tp)
    return e:IsActiveType(TYPE_TRAP) and e:GetHandler():IsType(TYPE_COUNTER)
end

--【特殊召喚】
function c260013010.spfilter(c,e,tp)
    return c:IsSetCard(0x943) and not c:IsCode(260013010) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c260013010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c260013010.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c260013010.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c260013010.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end



--【効果無効化】
function c260013010.discon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c260013010.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c260013010.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c260013010.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0
        and c:IsRelateToEffect(e) and c:IsFaceup() then
    end
end

--【破壊無効】
function c260013010.repfilter(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
        and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c260013010.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return eg:IsExists(c260013010.repfilter,1,nil,tp)
        and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    return Duel.SelectEffectYesNo(tp,c,96)
end
function c260013010.desrepval(e,c)
    return c260013010.repfilter(c,e:GetHandlerPlayer())
end
function c260013010.desrepop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
    Duel.Hint(HINT_CARD,0,260013010)
end

local re=Card.IsSetCard
Card.IsSetCard=function(c,name)
    if name==0x944 and c:IsCode(33256280,60071928,34906152,49036338,85310252,99249638,1948619,44935634,62306203,54497620) then return true end
    return re(c,name)
end
