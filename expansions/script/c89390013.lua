--自律金属细胞
local m=89390013
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddLinkProcedure(c,cm.mfilter,1,1)
    c:EnableReviveLimit()
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_REMOVE)
    e2:SetOperation(cm.rmop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_FUSION_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e3:SetRange(LOCATION_REMOVED)
    e3:SetCountLimit(1,m)
    e3:SetCondition(cm.thcon)
    e3:SetTarget(cm.sptg)
    e3:SetOperation(cm.spop)
    e3:SetLabelObject(e2)
    c:RegisterEffect(e3)
end
function cm.mfilter(c)
    return c:IsLinkRace(RACE_PSYCHO) and c:IsLinkAttribute(ATTRIBUTE_DARK)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetTurnCount()
    e:SetLabel(ct)
    e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(m)>0
end
function cm.spfilter(c,e,tp)
    return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function cm.filter1(c,e)
    return c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,m,f,gc,chkf)
    return c:IsType(TYPE_FUSION) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        local c=g:GetFirst()
        if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CHANGE_RACE)
            e1:SetValue(RACE_MACHINE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            c:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_ADD_TYPE)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e2:SetValue(TYPE_TUNER)
            c:RegisterEffect(e2)
            Duel.SpecialSummonComplete()
            if c:IsImmuneToEffect(e) then return end
            local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter1,nil,e)
            local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
            local mg2=nil
            local sg2=nil
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                mg2=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)
            end
            if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
                local sg=sg1:Clone()
                if sg2 then sg:Merge(sg2) end
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local tg=sg:Select(tp,1,1,nil)
                local tc=tg:GetFirst()
                if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
                    local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
                    tc:SetMaterial(mat1)
                    Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
                    Duel.BreakEffect()
                    Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
                else
                    local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c,chkf)
                    local fop=ce:GetOperation()
                    fop(ce,e,tp,tc,mat2)
                end
                tc:CompleteProcedure()
            end
        end
    end
end
