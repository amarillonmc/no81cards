--连接姬 佩克莉露
local m=60152306
local cm=_G["c"..m]
function cm.initial_effect(c)
    --spsummon
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(60152306,0))
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_HAND)
    e0:SetCondition(c60152306.e0con)
    e0:SetOperation(c60152306.e0op)
    c:RegisterEffect(e0)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60152306,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,60152306)
    e1:SetTarget(c60152306.e1tg)
    e1:SetOperation(c60152306.e1op)
    c:RegisterEffect(e1)
    local e11=e1:Clone()
    e11:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e11)
    --XYZ
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60152306,2))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,6012306)
    e2:SetCondition(c60152306.e2con)
    e2:SetTarget(c60152306.e2tg)
    e2:SetOperation(c60152306.e2op)
    c:RegisterEffect(e2)
end
function c60152306.e0con(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_COST)
end
function c60152306.e0op(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.RemoveOverlayCard(tp,1,1,1,1,REASON_COST)
end
function c60152306.e1tgfilter(c,e,tp)
    local code=c:GetCode()
    return c:IsFaceup() and c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER) 
        and Duel.IsExistingTarget(c60152306.e1tgfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,code,e,tp)
end
function c60152306.e1tgfilter2(c,code,e,tp)
    return c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER) and not c:IsCode(code)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60152306.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60152306.e1tgfilter(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(c60152306.e1tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) 
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c60152306.e1tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152306.e1op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc0=Duel.GetFirstTarget()
    local code=tc0:GetCode()
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c60152306.e1tgfilter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,code,e,tp)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,1,nil)
        local tc2=sg:GetFirst()
        Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
        if Duel.IsPlayerAffectedByEffect(tp,60152321) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_IMMUNE_EFFECT)
            e1:SetRange(LOCATION_MZONE)
            e1:SetValue(c60152306.e1opfilter)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_CHAIN)
            tc2:RegisterEffect(e1)
        end
        if tc0:IsType(TYPE_XYZ) and e:GetHandler():IsRelateToEffect(e) and not e:GetHandler():IsImmuneToEffect(e) 
            and tc0:IsLocation(LOCATION_MZONE) and Duel.SelectYesNo(tp,aux.Stringid(60152301,4)) then
            Duel.Overlay(tc0,Group.FromCards(e:GetHandler()))
        end
    end
end
function c60152306.e1opfilter(e,re)
    return e:GetHandler()~=re:GetOwner()
end
function c60152306.e2con(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60152306.e2tgfilter(c)
    return c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(60152306)
end
function c60152306.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60152306.e2tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152306.e2op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60152306.e2tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end