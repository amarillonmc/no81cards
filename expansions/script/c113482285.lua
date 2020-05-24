function c113482285.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,113482285+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c113482285.target)
    e1:SetOperation(c113482285.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetOperation(c113482285.setop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_HAND+LOCATION_GRAVE,LOCATION_HAND+LOCATION_GRAVE)
    e3:SetTarget(c113482285.efftg)
    e3:SetCode(113482285)
    c:RegisterEffect(e3)
end
function c113482285.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,6) end
end
function c113482285.filter(c)
    return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER)
end
function c113482285.thfilter(c)
    return (c:IsSetCard(0xc5) or c:IsSetCard(0xbb)) and c:IsAbleToHand()
end
function c113482285.rthfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c113482285.tgfilter(c)
    return c:IsSetCard(0xbb) and c:IsAbleToGrave()
end
function c113482285.filter0(c)
    return c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c113482285.filter1(c,e)
    return c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c113482285.filter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsSetCard(0xbb) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c113482285.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if not Duel.IsPlayerCanDiscardDeck(tp,6) then return end
    local n=0
    Duel.ConfirmDecktop(tp,6)
    local g=Duel.GetDecktopGroup(tp,6)
    local sg=g:Filter(c113482285.filter,nil)
    if sg:GetCount()>0 then
        n=Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
    end
    local o1=Duel.GetMatchingGroup(c113482285.thfilter,tp,LOCATION_DECK,0,nil)
    if n>=1 and o1:GetCount()>0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local s1=o1:Select(tp,1,1,nil)
        if s1:GetCount()>0 then
            Duel.SendtoHand(s1,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,s1)
        end
    end
    local o2=Duel.GetMatchingGroup(c113482285.rthfilter,tp,0,LOCATION_ONFIELD,nil)
    if n>=2 and o2:GetCount()>0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
        local s2=o2:Select(tp,1,2,nil)
        if s2:GetCount()>0 then
            Duel.SendtoHand(s2,nil,REASON_EFFECT)
        end
    end
    if n>=3 then
        Duel.BreakEffect()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_ACTIVATE)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(0,1)
        e1:SetValue(c113482285.actlimit)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
    local o3=Duel.GetMatchingGroup(c113482285.tgfilter,tp,LOCATION_DECK,0,nil)
    if n>=4 and o3:GetCount()>0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local s3=o3:Select(tp,1,4,nil)
        if s3:GetCount()>0 then
            Duel.SendtoGrave(s3,REASON_EFFECT)
        end
        local chkf=Duel.GetLocationCountFromEx(tp)>0 and PLAYER_NONE or tp
        local mg1=Duel.GetMatchingGroup(c113482285.filter0,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
        local res=Duel.IsExistingMatchingCard(c113482285.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg2=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c113482285.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
            end
        end
        if n>0 and res and Duel.SelectYesNo(tp,aux.Stringid(113482285,0)) then
            Duel.BreakEffect()
            local sg1=Duel.GetMatchingGroup(c113482285.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
            local mg2=nil
            local sg2=nil
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                mg2=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                sg2=Duel.GetMatchingGroup(c113482285.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
            end
            if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
                local sg=sg1:Clone()
                if sg2 then sg:Merge(sg2) end
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local tg=sg:Select(tp,1,1,nil)
                local tc=tg:GetFirst()
                if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
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
            end
        end
    end
end
function c113482285.actlimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER)
end
function c113482285.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.ChangePosition(c,POS_FACEDOWN)
        Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
    end
end
function c113482285.efftg(e,c)
    return c:IsSetCard(0xbb)
end