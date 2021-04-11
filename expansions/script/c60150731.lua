--水无月的新娘 纯白型歌姬亚瑟
function c60150731.initial_effect(c)
    c:SetUniqueOnField(1,0,60150731)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCode2(c,60150721,60150798,true,true)
    --cannot fusion material
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e11:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    e11:SetValue(1)
    c:RegisterEffect(e11)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c60150731.splimit)
    c:RegisterEffect(e1)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c60150731.spcon)
    e2:SetOperation(c60150731.spop)
    c:RegisterEffect(e2)
    --2
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60150731,2))
    e3:SetCategory(CATEGORY_DISABLE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,0x1e0)
    e3:SetTarget(c60150731.distg)
    e3:SetOperation(c60150731.disop)
    c:RegisterEffect(e3)
    --3
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(60150731,4))
    e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCost(c60150731.discost)
    e4:SetTarget(c60150731.distg2)
    e4:SetOperation(c60150731.disop2)
    c:RegisterEffect(e4)
end
c60150731.is_named_with_Million_Arthur=1
function c60150731.IsMillion_Arthur(c)
    local m=_G["c"..c:GetCode()]
    return m and m.is_named_with_Million_Arthur
end
function c60150731.splimit(e,se,sp,st)
    return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150731.spfilter1(c,tp,fc)
    return c:IsCode(60150721) and c:IsCanBeFusionMaterial(fc) and c:IsReleasable()
        and Duel.IsExistingMatchingCard(c60150731.spfilter2,tp,LOCATION_ONFIELD,0,1,c,fc)
end
function c60150731.spfilter2(c,fc)
    return c:IsCode(60150798) and c:IsCanBeFusionMaterial(fc) and c:IsReleasable()
end
function c60150731.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local c1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
    local c2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if (c1 and c1:IsCode(60150798)) or (c2 and c2:IsCode(60150798)) then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
            and Duel.IsExistingMatchingCard(c60150731.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,fc)
    else
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
            and Duel.IsExistingMatchingCard(c60150731.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,fc)
    end
end
function c60150731.spop(e,tp,eg,ep,ev,re,r,rp,c)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150731,0))
        local g1=Duel.SelectMatchingCard(tp,c60150731.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150731,1))
        local g2=Duel.SelectMatchingCard(tp,c60150731.spfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
        g1:Merge(g2)
        c:SetMaterial(g1)
        Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
    else
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150731,0))
        local g1=Duel.SelectMatchingCard(tp,c60150731.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c)
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150731,1))
        local g2=Duel.SelectMatchingCard(tp,c60150731.spfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
        g1:Merge(g2)
        c:SetMaterial(g1)
        Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
    end
end
function c60150731.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c60150731.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c60150731.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c60150731.filter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c60150731.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c60150731.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp) then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(60150731,2))
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CANNOT_ATTACK)
        e3:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e3)
        tc:RegisterFlagEffect(60150731,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60150731,3))
    end
end
function c60150731.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1,true)
end
function c60150731.filter2(c)
    return c:IsFaceup() and c:GetFlagEffect(60150731)~=0
end
function c60150731.distg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c60150731.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
        and Duel.IsPlayerCanDraw(tp,1) end
    local g=Duel.GetMatchingGroup(c60150731.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*1000)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60150731.disop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150731,5))
    local g=Duel.GetMatchingGroup(c60150731.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local ct=Duel.Destroy(g,REASON_EFFECT)
    if ct>0 then
        Duel.BreakEffect()
        Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end