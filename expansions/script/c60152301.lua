--连接姬 虹村雪
local m=60152301
local cm=_G["c"..m]
function cm.initial_effect(c)
    --spsummon
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(60152301,0))
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_HAND)
    e0:SetCondition(c60152301.e0con)
    e0:SetOperation(c60152301.e0op)
    c:RegisterEffect(e0)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60152301,1))
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,60152301)
    e1:SetTarget(c60152301.e1tg)
    e1:SetOperation(c60152301.e1op)
    c:RegisterEffect(e1)
    local e11=e1:Clone()
    e11:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e11)
    --XYZ
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60152301,5))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,6012301)
    e2:SetCondition(c60152301.e2con)
    e2:SetTarget(c60152301.e2tg)
    e2:SetOperation(c60152301.e2op)
    c:RegisterEffect(e2)
end
function c60152301.e0con(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_COST)
end
function c60152301.e0op(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.RemoveOverlayCard(tp,1,1,1,1,REASON_COST)
end
function c60152301.e1tgfilter(c,tp)
    local code=c:GetCode()
    return c:IsFaceup() and c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER) 
        and Duel.IsExistingTarget(c60152301.e1tgfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,code)
end
function c60152301.e1tgfilter2(c,code)
    return c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER) and not c:IsCode(code)
        and (c:IsAbleToGrave() or c:IsAbleToHand())
end
function c60152301.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c60152301.e1tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c60152301.e1tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152301.e1op(e,tp,eg,ep,ev,re,r,rp)
    local tc0=Duel.GetFirstTarget()
    local code=tc0:GetCode()
    local g=Duel.GetMatchingGroup(c60152301.e1tgfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,code)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152301,3))
        local sg=g:Select(tp,1,1,nil)
        local tc2=sg:GetFirst()
        if tc2:IsAbleToGrave() and tc2:IsAbleToHand() then
            if Duel.SelectYesNo(tp,aux.Stringid(60152301,2)) then
                Duel.SendtoHand(tc2,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,tc2)
            else
                Duel.SendtoGrave(tc2,REASON_EFFECT)
            end
        elseif not tc2:IsAbleToGrave() and tc2:IsAbleToHand() then
            Duel.SendtoHand(tc2,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc2)
        elseif tc2:IsAbleToGrave() and not tc2:IsAbleToHand() then
            Duel.SendtoGrave(tc2,REASON_EFFECT)
        end
        if tc0:IsType(TYPE_XYZ) and e:GetHandler():IsRelateToEffect(e) and not e:GetHandler():IsImmuneToEffect(e) 
            and tc0:IsLocation(LOCATION_MZONE) and tc0:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(60152301,4)) then
            Duel.Overlay(tc0,Group.FromCards(e:GetHandler()))
        end
    end
end
function c60152301.e2con(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60152301.e2tgfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb26) and c:IsType(TYPE_XYZ)
end
function c60152301.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=Duel.GetOverlayCount(tp,1,1)-1
    if chk==0 then return ct>0 or (Duel.IsExistingMatchingCard(c60152301.e2opfilter,tp,LOCATION_GRAVE,0,1,nil,e) 
        and Duel.IsExistingMatchingCard(c60152301.e2tgfilter,tp,LOCATION_MZONE,0,1,nil)) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152301.e2opfilter(c,e)
    return not c:IsImmuneToEffect(e) and not c:IsCode(60152301)
end
function c60152301.e2op(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetOverlayCount(tp,1,1)
    local g0=Duel.GetMatchingGroup(c60152301.e2tgfilter,tp,LOCATION_MZONE,0,nil)
    if g0:GetCount()>0 and ct>0 then
        if Duel.SelectYesNo(tp,aux.Stringid(60152301,8)) then
            Duel.RemoveOverlayCard(tp,1,1,1,3,REASON_EFFECT)
        else
            Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152301,6))
            local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60152301.e2opfilter),tp,LOCATION_GRAVE,0,1,2,nil,e)
            Duel.HintSelection(g1)
            Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152301,7))
            local g2=Duel.SelectMatchingCard(tp,c60152301.e2tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
            Duel.HintSelection(g2)
            local tc2=g2:GetFirst()
            Duel.Overlay(tc2,g1)
        end
    elseif not g0:GetCount()>0 and ct>0 then
        Duel.RemoveOverlayCard(tp,1,1,1,3,REASON_EFFECT)
    elseif g0:GetCount()>0 and not ct>0 then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152301,6))
        local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60152301.e2opfilter),tp,LOCATION_GRAVE,0,1,2,nil,e)
        Duel.HintSelection(g1)
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152301,7))
        local g2=Duel.SelectMatchingCard(tp,c60152301.e2tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
        Duel.HintSelection(g2)
        local tc2=g2:GetFirst()
        Duel.Overlay(tc2,g1)
    end
end