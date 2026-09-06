--星渊虫群 -跳虫-
local s,id=GetID()
function s.initial_effect(c)
    -- 效果①：融合召唤
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.fncon1)
    e1:SetTarget(s.fntg)
    e1:SetOperation(s.fnop)
    c:RegisterEffect(e1)
    
    -- 效果①：对方回合也能发动
    local e2=e1:Clone()
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMING_END_PHASE)
    e2:SetCondition(s.fncon2)
    c:RegisterEffect(e2)
    
    -- 效果②：作为融合素材时当作3只以上
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
    e3:SetValue(2) -- 当作额外2只素材，加上自身就是3只
    e3:SetCondition(s.matcon)
    c:RegisterEffect(e3)
end

-- 效果①条件：自己回合
function s.fncon1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end

-- 效果①条件：对方回合且对方场上有怪兽
function s.fncon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==1-tp and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end

-- 效果②条件：作为星渊虫群融合怪兽的素材
function s.matcon(e)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_HAND+LOCATION_MZONE) and c:IsOnField()
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