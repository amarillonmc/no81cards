--影霊衣の万華鏡
function c115112430.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,115112430)
    e1:SetTarget(c115112430.target)
    e1:SetOperation(c115112430.activate)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c115112430.thcon)
    e2:SetCost(c115112430.thcost)
    e2:SetTarget(c115112430.thtg)
    e2:SetOperation(c115112430.thop)
    c:RegisterEffect(e2)
end
function c115112430.spfilter(c,e,tp,mc)
    return c:IsSetCard(0x10b4) and bit.band(c:GetType(),0x81)==0x81 and (not c.mat_filter or c.mat_filter(mc,tp))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
        and mc:IsCanBeRitualMaterial(c)
end
function c115112430.rfilter(c,mc)
    local mlv=mc:GetRitualLevel(c)
    if mlv==mc:GetLevel() then return false end
    local lv=c:GetLevel()
    return lv==bit.band(mlv,0xffff) or lv==bit.rshift(mlv,16)
end
function c115112430.filter(c,e,tp)
    local sg=Duel.GetMatchingGroup(c115112430.spfilter,tp,LOCATION_HAND,0,c,e,tp,c)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if c:IsLocation(LOCATION_MZONE) then ft=ft+1 end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    return sg:IsExists(c115112430.rfilter,1,nil,c) or sg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,ft)
end
function c115112430.mfilter(c)
    return c:GetLevel()>0 and c:IsAbleToGrave()
end
function c115112430.mzfilter(c,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:GetSequence()<5
end
function c115112430.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if ft<0 then return false end
        local mg=Duel.GetRitualMaterial(tp)
        if ft>0 then
            local mg2=Duel.GetMatchingGroup(c115112430.mfilter,tp,LOCATION_EXTRA,0,nil)
            mg:Merge(mg2)
        else
            mg=mg:Filter(c115112430.mzfilter,nil,tp)
        end
        return mg:IsExists(c115112430.filter,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c115112430.activate(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<0 then return end
    local mg=Duel.GetRitualMaterial(tp)
    if ft>0 then
        local mg2=Duel.GetMatchingGroup(c115112430.mfilter,tp,LOCATION_EXTRA,0,nil)
        mg:Merge(mg2)
    else
        mg=mg:Filter(c115112430.mzfilter,nil,LOCATION_MZONE)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local mat=mg:FilterSelect(tp,c115112430.filter,1,1,nil,e,tp)
    local mc=mat:GetFirst()
    if not mc then return end
    local sg=Duel.GetMatchingGroup(c115112430.spfilter,tp,LOCATION_HAND,0,mc,e,tp,mc)
    if mc:IsLocation(LOCATION_MZONE) then ft=ft+1 end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    local b1=sg:IsExists(c115112430.rfilter,1,nil,mc)
    local b2=sg:CheckWithSumEqual(Card.GetLevel,mc:GetLevel(),1,ft)
    local count
    if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(115112430,0))) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:FilterSelect(tp,c115112430.rfilter,1,1,nil,mc)
        local tc=tg:GetFirst()
        tc:SetMaterial(mat)
        if not mc:IsLocation(LOCATION_EXTRA) then
            Duel.ReleaseRitualMaterial(mat)
        else
            Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
        end
        Duel.BreakEffect()
        count=Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:SelectWithSumEqual(tp,Card.GetLevel,mc:GetLevel(),1,ft)
        local tc=tg:GetFirst()
        while tc do
            tc:SetMaterial(mat)
            tc=tg:GetNext()
        end
        if not mc:IsLocation(LOCATION_EXTRA) then
            Duel.ReleaseRitualMaterial(mat)
        else
            Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
        end
        Duel.BreakEffect()
        tc=tg:GetFirst()
        while tc do
            Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
            tc:CompleteProcedure()
            tc=tg:GetNext()
        end
        Duel.SpecialSummonComplete()
        count=tg:GetCount()
    end

    local c=e:GetHandler()
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetCountLimit(1)
    e3:SetCondition(c115112430.effcon)
    e3:SetOperation(c115112430.effop)
    e3:SetReset(RESET_PHASE+PHASE_END)
    e3:SetLabel(count)
    Duel.RegisterEffect(e3,tp)
end
function c115112430.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c115112430.cfilter(c)
    return c:IsSetCard(0x10b4) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c115112430.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
        and Duel.IsExistingMatchingCard(c115112430.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c115112430.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    g:AddCard(e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c115112430.thfilter(c)
    return c:IsSetCard(0x10b4) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c115112430.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c115112430.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c115112430.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c115112430.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function c115112430.effcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabel()>0 and Duel.IsPlayerCanDraw(tp)
end
function c115112430.effop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsPlayerCanDraw(tp) then return end
    Duel.Hint(HINT_CARD,0,115112430)
    Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
end