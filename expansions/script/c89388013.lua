--机怪巨兵 「DISK」
local m=89388013
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcc21))
    e3:SetValue(300)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e4)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetCost(cm.spcost)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,0))
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_SUMMON_PROC)
    e5:SetCondition(cm.otcon)
    e5:SetOperation(cm.otop)
    e5:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_SET_PROC)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_SPSUMMON_COST)
    e7:SetOperation(cm.lvop2)
    c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
    e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_SUMMON_SUCCESS)
    e8:SetCondition(cm.spcon2)
    e8:SetCost(cm.spcost2)
    e8:SetTarget(cm.sptg2)
    e8:SetOperation(cm.spop2)
    c:RegisterEffect(e8)
    Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
    return c:IsSetCard(0xcc21)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.filter(c,e,tp)
    return c:IsSetCard(0xcc21) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.otfilter(c,tp)
    return c:IsSetCard(0xcc21) and (c:IsControler(tp) or c:IsFaceup())
end
function cm.otcon(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(cm.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(cm.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function cm.lvop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_CHANGE_LEVEL)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e0:SetRange(LOCATION_MZONE)
    e0:SetValue(4)
    e0:SetReset(RESET_EVENT+0xff0000)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetReset(RESET_EVENT+0xff0000)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetValue(500)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_BASE_DEFENSE)
    e2:SetValue(1400)
    c:RegisterEffect(e2)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSetCard(0xcc21)
end
function cm.spfilter(c,e,tp)
    return c:IsSetCard(0xcc21) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
    local c=e:GetHandler()
    local fid=c:GetFieldID()
    local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
    if g:GetCount()>=2 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,2,2,nil)
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        sg:GetFirst():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0,fid)
        sg:GetNext():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0,fid)
        sg:KeepAlive()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetCountLimit(1)
        e1:SetLabel(fid)
        e1:SetLabelObject(sg)
        e1:SetCondition(cm.descon)
        e1:SetOperation(cm.desop)
        Duel.RegisterEffect(e1,tp)
    end
end
function cm.desfilter(c,fid)
    return c:GetFlagEffectLabel(m)==fid
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    if not g:IsExists(cm.desfilter,1,nil,e:GetLabel()) then
        g:DeleteGroup()
        e:Reset()
        return false
    else return true end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    local tg=g:Filter(cm.desfilter,nil,e:GetLabel())
    Duel.Destroy(tg,REASON_EFFECT)
end
