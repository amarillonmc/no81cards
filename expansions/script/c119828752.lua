function c119828752.initial_effect(c)
    aux.AddXyzProcedure(c,nil,8,2,c119828752.ovfilter,aux.Stringid(119828752,0),99,c119828752.xyzop)
    c:EnableReviveLimit()
    aux.EnablePendulumAttribute(c,false)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(119828752,1))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_PZONE)
    e1:SetHintTiming(TIMING_STANDBY_PHASE)
    e1:SetCountLimit(1,119828751)
    e1:SetCondition(c119828752.pccon)
    e1:SetTarget(c119828752.pctg)
    e1:SetOperation(c119828752.pcop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(119828752,2))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,119828752)
    e2:SetTarget(c119828752.target)
    e2:SetOperation(c119828752.operation)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_CHAIN_SOLVED)
    e3:SetRange(LOCATION_PZONE)
    e3:SetOperation(c119828752.cpop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(c119828752.atkval)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_UPDATE_DEFENSE)
    e5:SetValue(c119828752.defval)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(119828752,5))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCost(c119828752.cost)
    e6:SetTarget(c119828752.sptg)
    e6:SetOperation(c119828752.spop)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(119828752,6))
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE+LOCATION_EXTRA)
    e7:SetCountLimit(1,119828753)
    e7:SetTarget(c119828752.mvtg)
    e7:SetOperation(c119828752.mvop)
    c:RegisterEffect(e7)
end
function c119828752.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c119828752.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,119828752)==0 end
    Duel.RegisterFlagEffect(tp,119828752,RESET_PHASE+PHASE_END,0,1)
end
function c119828752.pcfilter(c)
    return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsFaceup()
end
function c119828752.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c119828752.pcfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c119828752.pcop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    if Duel.Destroy(dg,REASON_EFFECT)<dg:GetCount() then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c119828752.pcfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,2,nil)
    if g:GetCount()>0 then
        Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local tc=g:GetNext()
        if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
    end
end
function c119828752.pccon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    if Duel.GetTurnPlayer()==tp then
        return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
    else
        return ph==PHASE_STANDBY
    end
end
function c119828752.filter1(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c119828752.filter2(c)
    return c:IsType(TYPE_PENDULUM) and c:IsFaceup() 
end
function c119828752.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c119828752.filter1 end
    if chk==0 then return Duel.IsExistingTarget(c119828752.filter1,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingTarget(c119828752.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c119828752.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c119828752.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
        local g=Duel.SelectMatchingCard(tp,c119828752.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
        Duel.Overlay(tc,g)
    end
end
function c119828752.cpop(e,tp,eg,ep,ev,re,r,rp)
    local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    if lpz~=nil and lpz:GetFlagEffect(119828752)<=0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(aux.Stringid(119828752,4))
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_SPSUMMON_PROC_G)
        e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetRange(LOCATION_PZONE)
        e1:SetCountLimit(1,10000000)
        e1:SetCondition(c119828752.pencon1)
        e1:SetOperation(c119828752.penop1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(SUMMON_TYPE_PENDULUM)
        lpz:RegisterEffect(e1)
        lpz:RegisterFlagEffect(119828752,RESET_EVENT+RESETS_STANDARD,0,1)
    end
end
function c119828752.penfilter(c,e,tp,lscale,rscale,eset)
    local lv=0
    if c.pendulum_level then
        lv=c.pendulum_level
    else
        lv=c:GetLevel()
    end
    local bool=Auxiliary.PendulumSummonableBool(c)
    return (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
        and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
        and not c:IsForbidden()
        and (Auxiliary.PendulumChecklist&(0x1<<tp)==0 or Auxiliary.PConditionExtraFilter(c,e,tp,lscale,rscale,eset))
end
function c119828752.pencon1(e,c,og)
    if c==nil then return true end
    local tp=c:GetControler()
    local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
    if aux.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
    local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if rpz==nil or c==rpz then return false end
    local lscale=c:GetLeftScale()
    local rscale=rpz:GetRightScale()
    if lscale>rscale then lscale,rscale=rscale,lscale end
    local loc=0
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_DECK end
    if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
    if loc==0 then return false end
    local g=nil
    if og then
        g=og:Filter(Card.IsLocation,nil,loc)
    else
        g=Duel.GetFieldGroup(tp,loc,0)
    end
    return g:IsExists(c119828752.penfilter,1,nil,e,tp,lscale,rscale,eset)
end
function c119828752.penop1(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
    Duel.Hint(HINT_CARD,0,119828752)
    Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_EXTRA,0))
    local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    local lscale=c:GetLeftScale()
    local rscale=rpz:GetRightScale()
    if lscale>rscale then lscale,rscale=rscale,lscale end
    local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
    local tg=nil
    local loc=0
    local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
    local ft=Duel.GetUsableMZoneCount(tp)
    local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
    if ect and ect<ft2 then ft2=ect end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then
        if ft1>0 then ft1=1 end
        if ft2>0 then ft2=1 end
        ft=1
    end
    if ft1>0 then loc=loc|LOCATION_HAND+LOCATION_DECK end
    if ft2>0 then loc=loc|LOCATION_EXTRA end
    if og then
        tg=og:Filter(Card.IsLocation,nil,loc):Filter(c119828752.penfilter,nil,e,tp,lscale,rscale,eset)
    else
        tg=Duel.GetMatchingGroup(c119828752.penfilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
    end
    local ce=nil
    local b1=aux.PendulumChecklist&(0x1<<tp)==0
    local b2=#eset>0
    if b1 and b2 then
        local options={1163}
        for _,te in ipairs(eset) do
            table.insert(options,te:GetDescription())
        end
        local op=Duel.SelectOption(tp,table.unpack(options))
        if op>0 then
            ce=eset[op]
        end
    elseif b2 and not b1 then
        local options={}
        for _,te in ipairs(eset) do
            table.insert(options,te:GetDescription())
        end
        local op=Duel.SelectOption(tp,table.unpack(options))
        ce=eset[op+1]
    end
    if ce then
        tg=tg:Filter(aux.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
    end
    aux.GCheckAdditional=aux.PendOperationCheck(ft1,ft2,ft)
    local n=math.min(#tg,ft)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=tg:Filter(Card.IsLocation,nil,LOCATION_DECK):SelectSubGroup(tp,aux.TRUE,true,1,1)
    if n>1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        g:Merge(tg:Filter(Card.IsLocation,nil,LOCATION_HAND):SelectSubGroup(tp,aux.TRUE,true,1,n-1))
    end
    aux.GCheckAdditional=nil
    if not g then return end
    if ce then
        Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
        ce:Reset()
    else
        aux.PendulumChecklist=aux.PendulumChecklist|(0x1<<tp)
    end
    sg:Merge(g)
    Duel.HintSelection(Group.FromCards(c))
    Duel.HintSelection(Group.FromCards(rpz))
end
function c119828752.atkfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:GetAttack()>=0
end
function c119828752.atkval(e,c)
    local g=e:GetHandler():GetOverlayGroup():Filter(c119828752.atkfilter,nil)
    return g:GetSum(Card.GetAttack)
end
function c119828752.deffilter(c)
    return c:IsType(TYPE_PENDULUM) and c:GetDefense()>=0
end
function c119828752.defval(e,c)
    local g=e:GetHandler():GetOverlayGroup():Filter(c119828752.deffilter,nil)
    return g:GetSum(Card.GetDefense)
end
function c119828752.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c119828752.spfilter(c)
    return c:IsSetCard(0xe0) and c:IsAbleToHand()
end
function c119828752.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c119828752.spfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c119828752.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c119828752.spfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c119828752.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsFaceup() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c119828752.mvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end