--原生种·心
local m=89390002
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
    e2:SetCondition(cm.thcon)
    e2:SetCost(cm.thcost)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_REMOVE)
    e1:SetTarget(cm.srettg)
    e1:SetOperation(cm.sretop)
    c:RegisterEffect(e1)
    if not cm.global_check then
        cm.global_check=true
        cm[0]={}
        cm[1]={}
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_CHAINING)
        ge1:SetOperation(cm.checkop)
        Duel.RegisterEffect(ge1,0)
        local ge2=ge1:Clone()
        ge2:SetCode(EVENT_CHAIN_NEGATED)
        ge2:SetOperation(cm.regop2)
        Duel.RegisterEffect(ge2,0)
        local ge4=Effect.CreateEffect(c)
        ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
        ge4:SetOperation(cm.clearop)
        Duel.RegisterEffect(ge4,0)
    end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.thfilter(c)
    return c:IsRace(RACE_PSYCHO) and not c:IsCode(m) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetChainLimit(aux.FALSE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
    if tg:GetCount()>0 then
        local tc=tg:GetFirst()
        if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_REMOVED) then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
function cm.srettg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToDeck() end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
    Duel.SetChainLimit(aux.FALSE)
end
function cm.sretop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 and cm.ckecktarget(e,tp) and Duel.GetFlagEffect(tp,m)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp)
        local copyt=cm[tp]
        local exg=Group.CreateGroup()
        for k,v in pairs(copyt) do
            if k and v then exg:AddCard(k) end
        end
        local cd=c89390009.cd or 3
        if exg:GetClassCount(Card.GetOriginalCode)>=cd then
            local mg2=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_DECK,0,nil,tp,exg)
            mg1:Merge(mg2)
        end
        aux.FCheckAdditional=cm.fcheck
        local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
        aux.FCheckAdditional=nil
        local mg3=nil
        local sg2=nil
        local ce=Duel.GetChainMaterial(tp)
        if ce~=nil then
            local fgroup=ce:GetTarget()
            mg3=fgroup(ce,e,tp)
            local mf=ce:GetValue()
            sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
        end
        if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
            local sg=sg1:Clone()
            if sg2 then sg:Merge(sg2) end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local tg=sg:Select(tp,1,1,nil)
            local tc=tg:GetFirst()
            if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
                aux.FCheckAdditional=cm.fcheck
                local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
                aux.FCheckAdditional=nil
                tc:SetMaterial(mat1)
                Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
                Duel.BreakEffect()
                Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
            else
                local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
                local fop=ce:GetOperation()
                fop(ce,e,tp,tc,mat2)
            end
            tc:CompleteProcedure()
            Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
        end
    end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if re:IsActiveType(TYPE_MONSTER) and rc:IsRace(RACE_PSYCHO) then
        cm[rp][rc]=1
    end
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
    cm[rp][re:GetHandler()]=nil
end
function cm.clearop(e,tp,eg,ep,ev,re,r,rp)
    cm[0]={}
    cm[1]={}
end
function cm.filter0(c,tp,g)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and c:IsRace(RACE_PSYCHO) and g:IsExists(aux.FilterEqualFunction(Card.GetOriginalCode,c:GetOriginalCode()),1,nil)
end
function cm.filter1(c,e)
    return not c:IsImmuneToEffect(e) and c:IsAbleToRemove() and c:IsRace(RACE_PSYCHO)
end
function cm.filter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.ckecktarget(e,tp)
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp)
    local copyt=cm[tp]
    local exg=Group.CreateGroup()
    for k,v in pairs(copyt) do
        if k and v then exg:AddCard(k) end
    end
    local cd=c89390009.cd or 3
    if exg:GetClassCount(Card.GetOriginalCode)>=cd then
        local mg2=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_DECK,0,nil,tp,exg)
        mg1:Merge(mg2)
    end
    aux.FCheckAdditional=cm.fcheck
    local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
    aux.FCheckAdditional=nil
    if not res then
        local ce=Duel.GetChainMaterial(tp)
        if ce~=nil then
            local fgroup=ce:GetTarget()
            local mg3=fgroup(ce,e,tp)
            local mf=ce:GetValue()
            res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
        end
    end
    return res
end
function cm.fcheck(tp,sg,fc)
    return not sg:IsExists(aux.NOT(Card.IsRace),1,nil,RACE_PSYCHO)
end
