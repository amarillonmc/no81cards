--机怪巨兵召唤阵
local m=89388019
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,m)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(cm.splimit)
    c:RegisterEffect(e2)
    local e1=e2:Clone()
    e1:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
    c:RegisterEffect(e1)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetTarget(cm.desreptg)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,0))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TODECK)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCountLimit(1,m)
    e5:SetTarget(cm.ftg)
    e5:SetOperation(cm.fop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(m,1))
    e6:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_SZONE)
    e6:SetCountLimit(1,m)
    e6:SetTarget(cm.stg)
    e6:SetOperation(cm.sop)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(m,2))
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_SZONE)
    e7:SetCountLimit(1,m)
    e7:SetTarget(cm.xtg)
    e7:SetOperation(cm.xop)
    c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(m,3))
    e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetRange(LOCATION_SZONE)
    e8:SetCountLimit(1,m)
    e8:SetTarget(cm.ltg)
    e8:SetOperation(cm.lop)
    c:RegisterEffect(e8)
end
function cm.splimit(e,c)
    return not c:IsSetCard(0xcc21)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) end
    if Duel.SelectEffectYesNo(tp,c,96) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
        Duel.SendtoGrave(g,REASON_REPLACE+REASON_EFFECT)
        return true
    else return false end
end
function cm.ffilter0(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function cm.ffilter1(c,e)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function cm.ffilter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsSetCard(0xcc21) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg=Duel.GetMatchingGroup(cm.ffilter0,tp,LOCATION_REMOVED,0,nil)
        local res=Duel.IsExistingMatchingCard(cm.ffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg3=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(cm.ffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.fop(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg=Duel.GetMatchingGroup(cm.ffilter1,tp,LOCATION_REMOVED,0,nil,e)
    local sg1=Duel.GetMatchingGroup(cm.ffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
    local mg3=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg3=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(cm.ffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
    end
    if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
        local sg=sg1:Clone()
        if sg2 then sg:Merge(sg2) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:Select(tp,1,1,nil)
        local tc=tg:GetFirst()
        if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
            local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
            tc:SetMaterial(mat)
            Duel.SendtoDeck(mat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        else
            local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
            local fop=ce:GetOperation()
            fop(ce,e,tp,tc,mat2)
        end
        tc:CompleteProcedure()
    end
end
function cm.sfilter1(c,e,tp)
    local lv=c:GetLevel()
    return c:IsSetCard(0xcc21) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and Duel.IsExistingMatchingCard(cm.sfilter2,tp,LOCATION_GRAVE,0,1,nil,tp,lv)
end
function cm.sfilter2(c,tp,lv)
    local rlv=lv-c:GetLevel()
    local rg=Duel.GetMatchingGroup(cm.sfilter3,tp,LOCATION_GRAVE,0,c)
    return rlv>0 and c:IsSetCard(0xcc21) and c:IsType(TYPE_TUNER) and c:IsAbleToRemove() and rg:CheckWithSumEqual(Card.GetLevel,rlv,1,99)
end
function cm.sfilter3(c)
    return c:GetLevel()>0 and c:IsSetCard(0xcc21) and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.sfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectMatchingCard(tp,cm.sfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    local tc=g1:GetFirst()
    if tc then
        local lv=tc:GetLevel()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g2=Duel.SelectMatchingCard(tp,cm.sfilter2,tp,LOCATION_GRAVE,0,1,1,nil,tp,lv)
        local rlv=lv-g2:GetFirst():GetLevel()
        local rg=Duel.GetMatchingGroup(cm.sfilter3,tp,LOCATION_GRAVE,0,g2:GetFirst())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g3=rg:SelectWithSumEqual(tp,Card.GetLevel,rlv,1,2)
        g2:Merge(g3)
        Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
        Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.xfilter(c,e,tp)
    return c:IsSetCard(0xcc21) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.xyzfilter(c,e,tp,mg)
    return c:IsSetCard(0xcc21) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and mg:IsExists(Card.IsXyzLevel,2,nil,c,c:GetRank())
end
function cm.xmfilter1(c,e,tp,mg,exg)
    return mg:IsExists(cm.xmfilter2,1,c,e,tp,c,exg)
end
function cm.xmfilter2(c,e,tp,mc,exg)
    return exg:IsExists(cm.xyzfilter,1,nil,e,tp,Group.FromCards(c,mc))
end
function cm.xtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local mg=Duel.GetMatchingGroup(cm.xfilter,tp,LOCATION_DECK,0,nil,e,tp)
    local exg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
    if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and mg:IsExists(cm.xmfilter1,1,nil,e,tp,mg,exg) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.xop(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetMatchingGroup(cm.xfilter,tp,LOCATION_DECK,0,nil,e,tp)
    local exg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
    if not (Duel.IsPlayerCanSpecialSummonCount(tp,2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and mg:IsExists(cm.xmfilter1,1,nil,e,tp,mg,exg)) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg1=mg:FilterSelect(tp,cm.xmfilter1,1,1,nil,e,tp,mg,exg)
    local tc1=sg1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg2=mg:FilterSelect(tp,cm.xmfilter2,1,1,tc1,e,tp,tc1,exg)
    sg1:Merge(sg2)
    Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
    local xyzg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,sg1)
    if xyzg:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
        Duel.XyzSummon(tp,xyz,sg1)
    end
end
function cm.matfilter(c,tp)
    return c:IsFaceup() or c:IsLocation(LOCATION_HAND)
end
function cm.lkfilter(c,mg)
    return c:IsSetCard(0xcc21) and c:IsLinkSummonable(mg)
end
function cm.ltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
        return Duel.IsExistingMatchingCard(cm.lkfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.lop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,cm.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
    local tc=tg:GetFirst()
    if tc then
        Duel.LinkSummon(tp,tc,mg)
    end
end
