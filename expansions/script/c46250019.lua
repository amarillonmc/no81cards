--星装镜
function c46250019.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,46250019)
    e2:SetTarget(c46250019.lktg)
    e2:SetOperation(c46250019.lkop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_CONTROL+CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCondition(c46250019.tgcon)
    e3:SetCost(aux.bfgcost)
    e3:SetTarget(c46250019.tgtg)
    e3:SetOperation(c46250019.tgop)
    c:RegisterEffect(e3)
end
function c46250019.lkfilter0(c,e,tp)
    return c:IsFaceup() and c46250019.lkfilter2(c) and Duel.IsExistingMatchingCard(c46250019.lkfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c46250019.lkfilter(c,e,tp,mc)
    return c:IsSetCard(0x2fc0) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,true,true) and c:GetLink()>=2 and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and Duel.IsExistingMatchingCard(c46250019.lkfilter2,tp,LOCATION_DECK,0,c:GetLink()-1,nil)
end
function c46250019.lkfilter2(c)
    return c:IsSetCard(0x1fc0) and c:IsAbleToRemove() 
end
function c46250019.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(c46250019.lkfilter0,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    local g=Duel.SelectTarget(tp,c46250019.lkfilter0,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,e:GetHandler():GetLink(),tp,LOCATION_MZONE+LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c46250019.lkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local fc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or not fc:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local xg=Duel.SelectMatchingCard(tp,c46250019.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,fc)
    if not xg then return end
    local tc=xg:GetFirst()
    Duel.ConfirmCards(1-tp,tc)
    Duel.PayLPCost(tp,tc:GetLink()*1000)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local tg=Duel.SelectMatchingCard(tp,c46250019.lkfilter2,tp,LOCATION_DECK,0,tc:GetLink()-1,tc:GetLink()-1,nil)
    if not tg then return end
    tg:AddCard(fc)
    if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)==tg:GetCount() then
        Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,true,true,POS_FACEUP)
        tc:SetMaterial(tg)
        tc:CompleteProcedure()
    end
end
function c46250019.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLP(1-tp)>=Duel.GetLP(tp)*2
end
function c46250019.tgfilter(c)
    return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c46250019.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c46250019.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
end
function c46250019.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectMatchingCard(tp,c46250019.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
    if g and Duel.GetControl(g,tp,PHASE_END,1) then
        local tc=g:GetFirst()
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        tc:RegisterEffect(e2)
        local e3=e1:Clone()
        e3:SetCode(EFFECT_SET_ATTACK)
        e3:SetValue(1000)
        tc:RegisterEffect(e3)
        local e4=e1:Clone()
        e4:SetCode(EFFECT_CHANGE_CODE)
        e4:SetValue(46250000)
        tc:RegisterEffect(e4)
    end
end
