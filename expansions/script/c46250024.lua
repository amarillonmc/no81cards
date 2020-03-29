--骸星装-端枪
function c46250024.initial_effect(c)
    c:EnableReviveLimit()
    c:SetUniqueOnField(1,0,46250024,LOCATION_MZONE)
    aux.AddSynchroMixProcedure(c,c46250024.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_CHAINING)
    e5:SetRange(LOCATION_MZONE)
    e5:SetOperation(c46250024.chainop)
    c:RegisterEffect(e5)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetTarget(c46250024.attg)
    e4:SetValue(c46250024.atlimit)
    c:RegisterEffect(e4)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,46250024)
    e1:SetCondition(c46250024.tgcon)
    e1:SetCost(c46250024.tgcost)
    e1:SetTarget(c46250024.tgtg)
    e1:SetOperation(c46250024.tgop)
    c:RegisterEffect(e1)
end
function c46250024.matfilter1(c)
    return (c:IsType(TYPE_TUNER) or c:IsSetCard(0x1fc0)) and not c:IsAttribute(ATTRIBUTE_DARK)
end
function c46250024.chainop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local atk=c:GetAttack()
    if re:GetHandler():IsSetCard(0xfc0) then
        Duel.SetChainLimit(function(e,rp,np) return tp==rp or e:GetHandler():GetBaseAttack()>atk end)
    end
end
function c46250024.attg(e,c)
    return e:GetHandler():IsAttackAbove(c:GetBaseAttack())
end
function c46250024.atlimit(e,c)
    return c~=e:GetHandler()
end
function c46250024.tgfilter(c)
    return bit.band(c:GetSummonLocation(),LOCATION_EXTRA)==LOCATION_EXTRA
end
function c46250024.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c46250024.tgfilter,1,nil)
end
function c46250024.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReleasable() end
    Duel.Release(c,REASON_COST)
end
function c46250024.spfilter(c,e,tp)
    return c:IsSetCard(0x1fc0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsLevel(6)
end
function c46250024.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        local g=Duel.GetMatchingGroup(c46250024.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
        return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and g:GetClassCount(Card.GetAttribute)>=2
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c46250024.sxfilter(c,mg)
    return (c:CheckFusionMaterial(mg,nil) or c:IsXyzSummonable(mg,2,2)) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c46250024.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c46250024.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
    if not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
        and g:GetClassCount(Card.GetAttribute)>=2 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg1=g:Select(tp,1,1,nil)
        g:Remove(Card.IsAttribute,nil,sg1:GetFirst():GetAttribute())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg2=g:Select(tp,1,1,nil)
        sg1:Merge(sg2)
        for tc in aux.Next(sg1) do
            Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            tc:RegisterEffect(e2)
            local e3=e1:Clone()
            e3:SetCode(EFFECT_CHANGE_LEVEL)
            e3:SetValue(6)
            tc:RegisterEffect(e3)
        end
        Duel.SpecialSummonComplete()
        local sxg=Duel.GetMatchingGroup(c46250024.sxfilter,tp,LOCATION_EXTRA,0,nil,sg1)
        if sxg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(46250024,0)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sxc=sxg:Select(tp,1,1,nil):GetFirst()
            if sxc:IsType(TYPE_FUSION) then
                sxc:SetMaterial(sg1)
                Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
                Duel.BreakEffect()
                Duel.SpecialSummon(sxc,SUMMON_TYPE_FUSION,tp,tp,false,true,POS_FACEUP)
            else
                Duel.XyzSummon(tp,sxc,sg1)
            end
        end
        sg1:KeepAlive()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
        e1:SetLabelObject(sg1)
        e1:SetTargetRange(1,0)
        e1:SetTarget(c46250024.sumlimit)
        Duel.RegisterEffect(e1,tp)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
        e2:SetCode(EFFECT_CANNOT_ACTIVATE)
        e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
        e2:SetLabelObject(sg1)
        e2:SetTargetRange(1,0)
        e2:SetValue(c46250024.tgval)
        Duel.RegisterEffect(e2,tp)
    end
end
function c46250024.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return e:GetLabelObject():IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c46250024.tgval(e,re,rp)
    return e:GetLabelObject():IsExists(Card.IsCode,1,nil,re:GetHandler():GetCode())
end
