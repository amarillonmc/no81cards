--奇幻仙境的Sekai
local m=131000015
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_FZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c131000015.spcon)
    e1:SetCost(c131000015.thcost)
    e1:SetTarget(c131000015.target)
    e1:SetOperation(c131000015.activate)
    c:RegisterEffect(e1)    
    --cannot set
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_MSET)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTargetRange(1,0)
    e4:SetTarget(aux.TRUE)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_SSET)
    c:RegisterEffect(e5)
    local e6=e4:Clone()
    e6:SetCode(EFFECT_CANNOT_TURN_SET)
    c:RegisterEffect(e6)
    local e7=e4:Clone()
    e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e7:SetTarget(c131000015.sumlimit)
    c:RegisterEffect(e7)
    --cannot trigger
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_TRIGGER)
    e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_SZONE,0)
    e3:SetTarget(c131000015.distg)
    c:RegisterEffect(e3)
    Duel.AddCustomActivityCounter(131000015,ACTIVITY_SPSUMMON,c131000015.counterfilter)
end
function c131000015.counterfilter(c)
    return not c:IsType(TYPE_LINK) or   c:GetLink()<3   or c:GetSummonType()~=SUMMON_TYPE_LINK 
end
function c131000015.spcon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c131000015.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c131000015.cfilter(c)
    return c:GetSequence()>=5
end
function c131000015.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return  Duel.GetCustomActivityCount(131000015,tp,ACTIVITY_SPSUMMON)==0
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetLabelObject(e)
    e1:SetTarget(c131000015.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c131000015.splimit(e,c,tp,sumtp,sumpos)
    return c:IsType(TYPE_LINK) and c:IsLinkAbove(3) and bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c131000015.dfilter(c)
    return c:IsSetCard(0xacdb) and c:IsLevelAbove(1) and not c:IsForbidden()
end
function c131000015.filter(c,e,tp)
    return c:IsType(TYPE_RITUAL)
end
function c131000015.rcheck(tp,g,c)
    return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c131000015.rgcheck(g)
    return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c131000015.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp)
        local dg=nil
        if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
                 dg=Duel.GetMatchingGroup(c131000015.dfilter,tp,LOCATION_DECK,0,nil)
        end
        aux.RCheckAdditional=c131000015.rcheck
        aux.RGCheckAdditional=c131000015.rgcheck
        local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_EXTRA,0,1,nil,c131000015.filter,e,tp,mg,dg,Card.GetLevel,"Equal")
        aux.RCheckAdditional=nil
        aux.RGCheckAdditional=nil
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c131000015.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local m=Duel.GetRitualMaterial(tp)
        local dg=nil
         if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
             dg=Duel.GetMatchingGroup(c131000015.dfilter,tp,LOCATION_DECK,0,nil)
         end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    aux.RCheckAdditional=c131000015.rcheck
    aux.RGCheckAdditional=c131000015.rgcheck
    local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_EXTRA,0,1,1,nil,c131000015.filter,e,tp,m,dg,Card.GetLevel,"Equal")
    local tc=tg:GetFirst()
    if tc then
        local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
         if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
             dg=Duel.GetMatchingGroup(c131000015.dfilter,tp,LOCATION_DECK,0,nil)
             mg:Merge(dg)
         end

        if tc.mat_filter then
            mg=mg:Filter(tc.mat_filter,tc,tp)
        else
            mg:RemoveCard(tc)
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
        local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
        aux.GCheckAdditional=nil
        if not mat or mat:GetCount()==0 then
            aux.RCheckAdditional=nil
            aux.RGCheckAdditional=nil
            return
        end
        tc:SetMaterial(mat)
        local dmat=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
        if dmat:GetCount()>0 then
            mat:Sub(dmat)
            Duel.MoveToField(dmat:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
        end
        Duel.ReleaseRitualMaterial(mat)
        Duel.BreakEffect()
        if   Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
            local pg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
            Duel.SendtoGrave(pg,REASON_EFFECT+REASON_DISCARD)
        end
        tc:CompleteProcedure()
    end
    aux.RCheckAdditional=nil
    aux.RGCheckAdditional=nil
end

function c131000015.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return bit.band(sumpos,POS_FACEDOWN)>0
end
function c131000015.distg(e,c)
    return c:IsFacedown()
end
