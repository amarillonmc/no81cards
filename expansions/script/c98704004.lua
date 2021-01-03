--真帝机 无神论
if not pcall(function() require("expansions/script/c98704001") end) then require("script/c98704001") end
local m=98704004
local cm=_G["c"..m]
cm.mqt=true
function cm.initial_effect(c)
    mqt.SummonWithThreeTributeEffect(c)
    mqt.SummonWithExtraTributeEffect(c)
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --tribute check
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_MATERIAL_CHECK)
    e2:SetValue(cm.valcheck)
    c:RegisterEffect(e2)
    --immune reg
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetCondition(cm.condition)
    e3:SetOperation(cm.regop)
    e3:SetLabelObject(e2)
    c:RegisterEffect(e3)
    --send to grave
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,3))
    e4:SetCategory(CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetHintTiming(TIMING_END_PHASE,TIMING_TOHAND+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e4:SetCondition(cm.condition)
    e4:SetCost(cm.cost)
    e4:SetTarget(cm.target)
    e4:SetOperation(cm.operation)
    c:RegisterEffect(e4)
end
function cm.valcheck(e,c)
    local g=c:GetMaterial()
    local typ=0
    local tc=g:GetFirst()
    while tc do
        typ=bit.bor(typ,bit.band(tc:GetOriginalType(),0x7))
        tc=g:GetNext()
    end
    e:SetLabel(typ)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local typ=e:GetLabelObject():GetLabel()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    e1:SetValue(cm.efilter)
    e1:SetLabel(typ)
    c:RegisterEffect(e1)
    if bit.band(typ,TYPE_MONSTER)~=0 then
        c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
    end
    if bit.band(typ,TYPE_SPELL)~=0 then
        c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
    end
    if bit.band(typ,TYPE_TRAP)~=0 then
        c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
    end
end
function cm.efilter(e,te)
    return te:GetHandler():GetOriginalType()&e:GetLabel()~=0 and te:GetOwner()~=e:GetOwner()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.costfilter(c)
    return mqt.ismqt(c) and c:IsAbleToRemoveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD+LOCATION_HAND)
end
function cm.cfilter(c)
    return not c:IsPublic()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
    if g:GetCount()>0 then
        local cg=g:Filter(cm.cfilter,nil)
        local shuffle=false
        if cg:GetCount()>0 then 
            Duel.ConfirmCards(tp,cg)
            shuffle=true
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local sg=g:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
        Duel.SendtoGrave(sg,REASON_RULE)
        if shuffle==true then
            Duel.ShuffleHand(1-tp)
        end
    end
end
