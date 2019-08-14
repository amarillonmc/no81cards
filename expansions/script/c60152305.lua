--连接姬 冰川镜华
local m=60152305
local cm=_G["c"..m]
function cm.initial_effect(c)
    --special summon
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(60152305,0))
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_HAND)
    e0:SetCondition(c60152305.e0con)
    c:RegisterEffect(e0)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60152305,1))
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,60152305)
    e1:SetTarget(c60152305.e1tg)
    e1:SetOperation(c60152305.e1op)
    c:RegisterEffect(e1)
    local e11=e1:Clone()
    e11:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e11)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60152305,2))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,6012305)
    e2:SetCondition(c60152305.e2con)
    e2:SetTarget(c60152305.e2tg)
    e2:SetOperation(c60152305.e2op)
    c:RegisterEffect(e2)
end
function c60152305.e0confilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb26) and c:GetCode()~=60152305
end
function c60152305.e0con(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
        Duel.IsExistingMatchingCard(c60152305.e0confilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60152305.e1tgfilter(c,tp)
    local code=c:GetCode()
    return c:IsFaceup() and c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER)
        and Duel.IsExistingTarget(c60152305.e1tgfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,code)
end
function c60152305.e1tgfilter2(c,code)
    return not c:IsCode(code) and c:IsAbleToGrave()
end
function c60152305.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60152305.e1tgfilter(chkc,tp) end
    if chk==0 then return Duel.IsExistingTarget(c60152305.e1tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) 
        and Duel.IsPlayerCanDraw(tp,1) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c60152305.e1tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152305.e1op(e,tp,eg,ep,ev,re,r,rp)
    local tc0=Duel.GetFirstTarget()
    local code=tc0:GetCode()
    local g=Duel.GetMatchingGroup(c60152305.e1tgfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,code)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local sg=g:Select(tp,1,1,nil)
        if Duel.SendtoGrave(sg,REASON_EFFECT) then
            Duel.Draw(tp,1,REASON_EFFECT)
        end
        if tc0:IsType(TYPE_XYZ) and e:GetHandler():IsRelateToEffect(e) and not e:GetHandler():IsImmuneToEffect(e) 
            and tc0:IsLocation(LOCATION_MZONE) and tc0:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(60152301,4)) then
            Duel.Overlay(tc0,Group.FromCards(e:GetHandler()))
        end
    end
end
function c60152305.e2con(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60152305.e2tgfilter(c)
    return c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and not c:IsCode(60152305)
end
function c60152305.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60152305.e2tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
    local g=Duel.GetMatchingGroup(c60152305.e2tgfilter,tp,LOCATION_GRAVE,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152305.e2op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c60152305.e2tgfilter,tp,LOCATION_GRAVE,0,1,3,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
            local gc=Duel.GetOperatedGroup():GetCount()
            local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,nil)
            if g2:GetCount()>=gc and Duel.SelectYesNo(tp,aux.Stringid(60152305,3)) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
                local sg=g2:Select(tp,gc,gc,nil)
                Duel.HintSelection(sg)
                Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
            end
        end
    end
end