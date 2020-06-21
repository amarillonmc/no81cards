--影霊衣の反魂術
function c119721166.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,119721166)
    e1:SetTarget(aux.RitualUltimateTarget(c119721166.filter,Card.GetOriginalLevel,"Equal",LOCATION_HAND+LOCATION_GRAVE))
    e1:SetOperation(c119721166.activate)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c119721166.thcon)
    e2:SetCost(c119721166.thcost)
    e2:SetTarget(c119721166.thtg)
    e2:SetOperation(c119721166.thop)
    c:RegisterEffect(e2)
end
function c119721166.filter(c)
    return c:IsSetCard(0x10b4)
end
function c119721166.activate(e,tp,eg,ep,ev,re,r,rp)
    greater_or_equal="Equal"
    local mg=Duel.GetRitualMaterial(tp)
    local exg=nil
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c119721166.filter,e,tp,mg,exg,Card.GetOriginalLevel,greater_or_equal)
    local tc=tg:GetFirst()
    if tc then
        mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        if exg then
            mg:Merge(exg)
        end
        if tc.mat_filter then
            mg=mg:Filter(tc.mat_filter,tc,tp)
        else
            mg:RemoveCard(tc)
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local lv=tc:GetOriginalLevel()
        aux.GCheckAdditional=aux.RitualCheckAdditional(tc,lv,greater_or_equal)
        local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,lv,tp,tc,lv,greater_or_equal)
        aux.GCheckAdditional=nil
        tc:SetMaterial(mat)
        Duel.ReleaseRitualMaterial(mat)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()

        local c=e:GetHandler()
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e3:SetCode(EVENT_PHASE+PHASE_END)
        e3:SetCountLimit(1)
        e3:SetCondition(c119721166.effcon)
        e3:SetOperation(c119721166.effop)
        e3:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e3,tp)
    end
end
function c119721166.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c119721166.cfilter(c)
    return c:IsSetCard(0x10b4) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c119721166.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
        and Duel.IsExistingMatchingCard(c119721166.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c119721166.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    g:AddCard(e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c119721166.thfilter(c)
    return c:IsSetCard(0x10b4) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c119721166.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c119721166.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c119721166.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c119721166.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function c119721166.effcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsPlayerCanDraw(tp)
end
function c119721166.effop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsPlayerCanDraw(tp) then return end
    Duel.Hint(HINT_CARD,0,119721166)
    Duel.Draw(tp,1,REASON_EFFECT)
end