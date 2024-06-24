--煉獄の癇魃
function c113482285.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,113482285+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c113482285.target)
    e1:SetOperation(c113482285.activate)
    c:RegisterEffect(e1)
    --sset
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTarget(c113482285.sstg)
    e2:SetOperation(c113482285.ssop)
    c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(113482285)
    e3:SetRange(LOCATION_SZONE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,0)
    c:RegisterEffect(e3)
    --plus effect
    if not c113482285.global_check then
        c113482285.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_ADJUST)
        ge1:SetOperation(c113482285.sdop)
        Duel.RegisterEffect(ge1,0)
    end
end

--change summon condition
local emc=Duel.GetMatchingGroup
Duel.GetMatchingGroup=function(filter,tp,location,locationed,card,args1,args2,args3,args4,args5,args6,args7,args8)
    if Duel.IsPlayerAffectedByEffect(tp,113482285) and card~=nil and locationed==0 and (location==LOCATION_GRAVE+LOCATION_HAND or location==LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE)
        and card:IsSetCard(0xbb) then
        return Group.CreateGroup()
    else
        return emc(filter,tp,location,locationed,card,args1,args2,args3,args4,args5,args6,args7,args8)
    end
end

function c113482285.filter(c)
    return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c113482285.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>5
        and Duel.IsExistingMatchingCard(c113482285.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c113482285.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.ConfirmDecktop(tp,6)
    local g=Duel.GetDecktopGroup(tp,6):Filter(c113482285.filter,nil)
    Duel.SendtoGrave(g,REASON_EFFECT)
    Duel.ShuffleDeck(tp)
    --search
    local hg=Duel.GetMatchingGroup(c113482285.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and hg:GetCount()>0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local thg=hg:Select(tp,1,1,nil)
        Duel.SendtoHand(thg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,thg)
    end
    --Bounce
    local bg=Duel.GetMatchingGroup(c113482285.mtfilter,tp,0,LOCATION_ONFIELD,nil)
    if g:GetCount()>1 and bg:GetCount()>0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local tbg=bg:Select(tp,1,2,nil)
        Duel.HintSelection(tbg)
        Duel.SendtoHand(tbg,nil,REASON_EFFECT)
    end
    --monster effect
    if g:GetCount()>2 then
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
    --tograve
    local tg=Duel.GetMatchingGroup(c113482285.filter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>3 and tg:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local tsg=tg:Select(tp,1,4,nil)
        Duel.SendtoGrave(tsg,REASON_EFFECT)

        local chkf=tp
        local mg1=Duel.GetMatchingGroup(c113482285.filter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e)
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
        if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) and Duel.SelectYesNo(tp,aux.Stringid(113482285,3)) then
            Duel.BreakEffect()
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
        end
    end
end
function c113482285.thfilter(c)
    return (c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER)) or (c:IsSetCard(0xc5) and c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsAbleToHand()
end
function c113482285.mtfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c113482285.actlimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c113482285.filter1(c,e)
    return c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c113482285.filter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsSetCard(0xbb) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
        and Duel.GetLocationCountFromEx(tp,tp,c)>0
end

function c113482285.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSSetable() end
end
function c113482285.ssop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsSSetable() then
        Duel.ChangePosition(c,POS_FACEDOWN)
    end
end

function c113482285.iffilter(c)
    return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER) and not c:IsCode(82734805,58446973)
end
function c113482285.sdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler():GetOwner()
    local g=Duel.GetMatchingGroup(c113482285.iffilter,c,LOCATION_GRAVE+LOCATION_HAND,LOCATION_GRAVE+LOCATION_HAND,nil)
    local tc=g:GetFirst()
    while tc do
        if tc:GetFlagEffect(113482285)==0 then
            local code=tc:GetOriginalCode()
            --special summon
            local e1=Effect.CreateEffect(tc)
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_SPSUMMON_PROC)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
            e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
            e1:SetCondition(c113482285.spcon)
            e1:SetOperation(c113482285.spop)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e1)
            tc:RegisterFlagEffect(113482285,RESET_EVENT+0x1fe0000,0,1)
        end
        tc=g:GetNext()
    end
end

function c113482285.spfilter(c)
    return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER)
        and ((c:IsAbleToRemoveAsCost() and c:IsLocation(LOCATION_HAND+LOCATION_MZONE)) or (c:IsFaceup() and c:IsLocation(LOCATION_REMOVED)))
end
function c113482285.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    if not Duel.IsPlayerAffectedByEffect(tp,113482285) then return false end
    local lv=c:GetOriginalLevel()
    if c:IsLocation(LOCATION_GRAVE) and lv<5 then return false end
    local count=0
    if lv>8 then count=3 elseif lv>4 then count=2 else count=1 end
    local sum=0
    for i=0,4 do
        local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
        if tc and tc:IsFaceup() and tc:IsType(TYPE_EFFECT) then
            if tc:IsType(TYPE_XYZ) then sum=sum+tc:GetRank()
            else sum=sum+tc:GetLevel() end
        end
    end
    if sum>8 then return false end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<-2 then return false end
    if c:IsHasEffect(34822850) then
        if ft>0 then
            return Duel.IsExistingMatchingCard(c113482285.spfilter,tp,LOCATION_MZONE+LOCATION_REMOVED+LOCATION_HAND,0,count,c)
        else
            local ct=-ft+1
            return Duel.IsExistingMatchingCard(c113482285.spfilter,tp,LOCATION_MZONE,0,ct,nil)
                and Duel.IsExistingMatchingCard(c113482285.spfilter,tp,LOCATION_MZONE+LOCATION_REMOVED+LOCATION_HAND,0,count,c)
        end
    else
        return ft>0 and Duel.IsExistingMatchingCard(c113482285.spfilter,tp,LOCATION_REMOVED+LOCATION_HAND,0,count,c)
    end
end
function c113482285.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local lv=c:GetOriginalLevel()
    if c:IsLocation(LOCATION_GRAVE) and lv<5 then return false end
    local count=0
    if lv>8 then count=3 elseif lv>4 then count=2 else count=1 end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=nil
    if c:IsHasEffect(34822850) then
        if ft>0 then
            g=Duel.SelectMatchingCard(tp,c113482285.spfilter,tp,LOCATION_MZONE+LOCATION_REMOVED+LOCATION_HAND,0,count,count,c)
        else
            local sg=Duel.GetMatchingGroup(c113482285.spfilter,tp,LOCATION_MZONE+LOCATION_REMOVED+LOCATION_HAND,0,c)
            local ct=-ft+1
            g=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
            if ct<count then
                sg:Sub(g)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
                local g2=sg:Select(tp,count-ct,count-ct,nil)
                g:Merge(g2)
            end
        end
    else
        g=Duel.SelectMatchingCard(tp,c113482285.spfilter,tp,LOCATION_REMOVED+LOCATION_HAND,0,count,count,c)
    end
    local rg=Group.CreateGroup()
    local sg=Group.CreateGroup()
    local tc=g:GetFirst()
    while tc do
        if tc:IsLocation(LOCATION_REMOVED) then
            rg:AddCard(tc)
        else
            sg:AddCard(tc)
        end
        tc=g:GetNext()
    end
    Duel.Remove(sg,POS_FACEUP,REASON_COST)
    Duel.SendtoGrave(rg,REASON_COST+REASON_RETURN)
end
