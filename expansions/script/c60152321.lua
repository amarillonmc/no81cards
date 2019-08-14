--现在，是柊杏奈的时间
local m=60152321
local cm=_G["c"..m]
function cm.initial_effect(c)
    --
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(60152321)
    e0:SetRange(LOCATION_FZONE)
    e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e0:SetTargetRange(1,0)
    c:RegisterEffect(e0)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,60152321)
    e1:SetOperation(c60152321.e1op)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60152321,3))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCost(c60152321.e2cost)
    e2:SetTarget(c60152321.e2tg)
    e2:SetOperation(c60152321.e2op)
    c:RegisterEffect(e2)
end
function c60152321.e1opfilter(c)
    return c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER) and ((c:IsAbleToHand() and c:IsLocation(LOCATION_DECK)) or (c:IsAbleToGrave() and c:IsLocation(LOCATION_EXTRA)))
end
function c60152321.e1op(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c60152321.e1opfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60152321,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152321,1))
        local sg=g:Select(tp,1,1,nil)
        local tc2=sg:GetFirst()
        if tc2:IsLocation(LOCATION_DECK) then
            Duel.SendtoHand(tc2,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc2)
        else
            Duel.SendtoGrave(tc2,REASON_EFFECT)
        end
    end
end
function c60152321.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_COST) end
    Duel.RemoveOverlayCard(tp,1,1,1,1,REASON_COST)
end
function c60152321.e2tgfilter(c,e,tp)
    return c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60152321.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60152321.e2tgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152321.e2opfilter(c,e)
    return c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e)
end
function c60152321.e2op(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60152321.e2tgfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        local tc0=g:GetFirst()
        if Duel.SpecialSummon(tc0,0,tp,tp,false,false,POS_FACEUP)>0 then
            local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c60152321.e2opfilter),tp,LOCATION_GRAVE,0,nil,e)
            if tc0:IsType(TYPE_XYZ) and tc0:IsLocation(LOCATION_MZONE) and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60152321,4)) then
                Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152311,1))
                local sg=g2:Select(tp,1,1,g2:GetFirst())
                Duel.HintSelection(sg)
                Duel.Overlay(tc0,sg)
            end
            if Duel.IsPlayerAffectedByEffect(tp,60152321) then
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_IMMUNE_EFFECT)
                e1:SetRange(LOCATION_MZONE)
                e1:SetValue(c60152321.e2opfilter2)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_CHAIN)
                tc0:RegisterEffect(e1)
            end
        end
    end
end
function c60152321.e2opfilter2(e,re)
    return e:GetHandler()~=re:GetOwner()
end