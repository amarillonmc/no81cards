--星渊虫群 -脊针爬虫-
local s,id=GetID()
function s.initial_effect(c)
    -- 效果①：融合召唤
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.fntg)
    e1:SetOperation(s.fnop)
    c:RegisterEffect(e1)
    
    -- 效果②：成为融合素材时的效果
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetCountLimit(1,id+100)
    e2:SetCondition(s.fdcon)
    e2:SetOperation(s.fdop)
    c:RegisterEffect(e2)
end

-- 效果①：融合召唤
function s.filter1(c,e)
    return c:IsLocation(LOCATION_MZONE+LOCATION_HAND) and not c:IsImmuneToEffect(e)
end

function s.filter2(c,e,tp,m,f,gc,chkf)
    return c:IsType(TYPE_FUSION) and c:IsSetCard(0x890) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end

function s.fntg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
        local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg2=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.fnop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local chkf=tp
    if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
    local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
    local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
    local mg2=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg2=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)
    end
    if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
        local sg=sg1:Clone()
        if sg2 then sg:Merge(sg2) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:Select(tp,1,1,nil)
        local tc=tg:GetFirst()
        if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
            local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
            tc:SetMaterial(mat1)
            Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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

-- 效果②：成为融合素材时的效果
function s.fdcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_GRAVE) and r==REASON_FUSION 
end

function s.spfilter(c,e,tp)
    return c:IsSetCard(0x890) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end

function s.fdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local mg=e:GetHandler():GetReasonCard():GetMaterialCount()
    
    -- 提升攻击力效果
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(1000)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
    
    -- 如果素材数量≥3，特殊召唤墓地怪兽
    if mg>=3 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
        if g2:GetCount()>0 then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg=g2:Select(tp,1,1,nil)
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end