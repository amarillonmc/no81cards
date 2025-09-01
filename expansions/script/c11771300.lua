--命运的结合
function c11771300.initial_effect(c)
    -- 骰子融合
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
    e1:SetTarget(c11771300.tg1)
    e1:SetOperation(c11771300.op1)
    c:RegisterEffect(e1)
    -- 墓地回收
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(11771300,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DICE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,11771300)
    e2:SetTarget(c11771300.tg2)
    e2:SetOperation(c11771300.op2)
    c:RegisterEffect(e2)
end
-- 1
function c11771300.fusfilter(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c11771300.matfilter(c)
    return c:IsCanBeFusionMaterial() and c:IsType(TYPE_MONSTER)
end
function c11771300.exmatfilter(c,e)
    return c11771300.matfilter(c) and c:IsAbleToRemove() and (c:IsLocation(LOCATION_MZONE) or aux.NecroValleyFilter()(c))
end
function c11771300.hmmatfilter(c,e)
    return c11771300.matfilter(c) and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_MZONE)) and not c:IsImmuneToEffect(e)
end
function c11771300.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_EXTRA,0,1,nil,TYPE_FUSION) end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11771300.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local d=Duel.TossDice(tp,1)
    local chkf=tp
    local ft=Duel.GetLocationCountFromEx(tp)
    if ft<=0 then return end
    if d==1 then
        mg1=Duel.GetMatchingGroup(c11771300.exmatfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e)
        local ce=Duel.GetChainMaterial(tp)
        local sg1=Duel.GetMatchingGroup(c11771300.fusfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
        local sg2=nil
        local mg2=nil
        if ce~=nil then
            local fgroup=ce:GetTarget()
            mg2=fgroup(ce,e,tp)
            local mf=ce:GetValue()
            sg2=Duel.GetMatchingGroup(c11771300.fusfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
        end
        if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
            local sg=sg1:Clone()
            if sg2 then sg:Merge(sg2) end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local tg=sg:Select(tp,1,1,nil)
            local tc=tg:GetFirst()
            if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
                local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
                tc:SetMaterial(mat1)
                Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
                Duel.BreakEffect()
                Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
            else
                local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
                local fop=ce:GetOperation()
                fop(ce,e,tp,tc,mat2)
            end
            tc:CompleteProcedure()
            return
        end
    elseif d>=2 and d<=5 then
        mg1=Duel.GetFusionMaterial(tp):Filter(c11771300.hmmatfilter,nil,e)
        local ce=Duel.GetChainMaterial(tp)
        local sg1=Duel.GetMatchingGroup(c11771300.fusfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
        local sg2=nil
        local mg2=nil
        if ce~=nil then
            local fgroup=ce:GetTarget()
            mg2=fgroup(ce,e,tp)
            local mf=ce:GetValue()
            sg2=Duel.GetMatchingGroup(c11771300.fusfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
        end
        if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
            local sg=sg1:Clone()
            if sg2 then sg:Merge(sg2) end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local tg=sg:Select(tp,1,1,nil)
            local tc=tg:GetFirst()
            if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
                local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
                tc:SetMaterial(mat1)
                Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
                Duel.BreakEffect()
                Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
            else
                local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
                local fop=ce:GetOperation()
                fop(ce,e,tp,tc,mat2)
            end
            tc:CompleteProcedure()
            return
        end
    elseif d==6 then
        if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
        mg1=Duel.GetMatchingGroup(c11771300.matfilter,tp,LOCATION_DECK,0,nil)
        local ce=Duel.GetChainMaterial(tp)
        local sg1=Duel.GetMatchingGroup(c11771300.fusfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
        local sg2=nil
        local mg2=nil
        if ce~=nil then
            local fgroup=ce:GetTarget()
            mg2=fgroup(ce,e,tp)
            local mf=ce:GetValue()
            sg2=Duel.GetMatchingGroup(c11771300.fusfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
        end
        if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
            local sg=sg1:Clone()
            if sg2 then sg:Merge(sg2) end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local tg=sg:Select(tp,1,1,nil)
            local tc=tg:GetFirst()
            if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
                local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
                tc:SetMaterial(mat1)
                Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
                Duel.BreakEffect()
                Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
            else
                local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
                local fop=ce:GetOperation()
                fop(ce,e,tp,tc,mat2)
            end
            tc:CompleteProcedure()
            return
        end
    end
end
-- 2
function c11771300.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c11771300.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local d=Duel.TossDice(tp,1)
    if d>3 and c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end
