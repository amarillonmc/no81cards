--新郎掠夺 纯白型金发伊索德
function c60150733.initial_effect(c)
    c:SetUniqueOnField(1,0,60150733)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCode2(c,60150723,60150798,true,true)
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
    e1:SetValue(c60150733.splimit)
    c:RegisterEffect(e1)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c60150733.spcon)
    e2:SetOperation(c60150733.spop)
    c:RegisterEffect(e2)
    --battle indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e3:SetCountLimit(1)
    e3:SetValue(c60150733.valcon)
    c:RegisterEffect(e3)
    --attack target
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c60150733.tgcon)
    e4:SetCost(c60150733.tgcost)
    e4:SetTarget(c60150733.tgtg)
    e4:SetOperation(c60150733.tgop)
    c:RegisterEffect(e4)
end
function c60150733.splimit(e,se,sp,st)
    return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150733.spfilter1(c,tp,fc)
    return c:IsCode(60150723) and c:IsCanBeFusionMaterial(fc) and c:IsReleasable()
        and Duel.IsExistingMatchingCard(c60150733.spfilter2,tp,LOCATION_ONFIELD,0,1,c,fc)
end
function c60150733.spfilter2(c,fc)
    return c:IsCode(60150798) and c:IsCanBeFusionMaterial(fc) and c:IsReleasable()
end
function c60150733.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local c1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
    local c2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if (c1 and c1:IsCode(60150798)) or (c2 and c2:IsCode(60150798)) then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
            and Duel.IsExistingMatchingCard(c60150733.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,fc)
    else
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
            and Duel.IsExistingMatchingCard(c60150733.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,fc)
    end
end
function c60150733.spop(e,tp,eg,ep,ev,re,r,rp,c)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150733,0))
        local g1=Duel.SelectMatchingCard(tp,c60150733.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150733,1))
        local g2=Duel.SelectMatchingCard(tp,c60150733.spfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
        g1:Merge(g2)
        c:SetMaterial(g1)
        Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
    else
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150733,0))
        local g1=Duel.SelectMatchingCard(tp,c60150733.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c)
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150733,1))
        local g2=Duel.SelectMatchingCard(tp,c60150733.spfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
        g1:Merge(g2)
        c:SetMaterial(g1)
        Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
    end
end
function c60150733.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end
function c60150733.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
        and (Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE))
end
function c60150733.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupEx(tp,nil,1,e:GetHandler()) end
    local g=Duel.SelectReleaseGroupEx(tp,nil,1,1,e:GetHandler())
    Duel.Release(g,REASON_COST)
end
function c60150733.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return e:GetHandler():IsFaceup() and Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60150733.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Draw(tp,1,REASON_EFFECT)
    if c:IsRelateToEffect(e) then
        Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150733,2))
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_RISE_TO_FULL_HEIGHT)
        e1:SetTargetRange(0,LOCATION_MZONE)
        e1:SetLabel(c:GetRealFieldID())
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_ONLY_BE_ATTACKED)
        e2:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e2,true)
    end
end
