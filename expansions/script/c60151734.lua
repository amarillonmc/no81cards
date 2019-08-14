--天空的水晶部队 倾城的枭姬
function c60151734.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x3b26),2,2)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151734,0))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c60151734.thtg)
    e1:SetOperation(c60151734.thop)
    c:RegisterEffect(e1)
    --todeck
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60151734,1))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1,60151734)
    e2:SetTarget(c60151734.tdtg)
    e2:SetOperation(c60151734.tdop)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151734,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1,6011734)
    e3:SetTarget(c60151734.target2)
    e3:SetOperation(c60151734.operation2)
    c:RegisterEffect(e3)
end
function c60151734.thtgfilter(c)
    return c:IsSetCard(0x3b26) and c:IsAbleToGrave()
end
function c60151734.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151734.thtgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c60151734.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60151734.thtgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
function c60151734.tdfilter(c)
    return c:IsSetCard(0x3b26) and c:IsAbleToDeck()
end
function c60151734.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c60151734.tdfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c60151734.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c60151734.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,LOCATION_ONFIELD)
end
function c60151734.tgfilter2(c,ttype)
    return c:IsType(ttype) and c:IsFaceup() and c:IsAbleToDeck()
end
function c60151734.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
            local ttype=bit.band(tc:GetType(),0x7)
            local g2=Duel.GetMatchingGroup(c60151734.tgfilter2,tp,0,LOCATION_ONFIELD,nil,ttype)
            if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60151734,3)) then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
                local sg=g2:Select(tp,1,1,nil)
                Duel.HintSelection(sg)
                Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
            end
        end
    end
end
function c60151734.filter(c,e,tp)
    return c:IsSetCard(0x3b26) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151734.filter2(c,ft)
    if ft==0 then
        return c:IsType(TYPE_MONSTER) and c:IsDestructable()
            and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
    else
        return c:IsType(TYPE_MONSTER) and c:IsDestructable()
            and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
    end
end
function c60151734.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151734.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,ft)
        and Duel.IsExistingTarget(c60151734.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c60151734.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    local g2=Duel.GetMatchingGroup(c60151734.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,ft)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c60151734.operation2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectMatchingCard(tp,c60151734.filter2,tp,LOCATION_MZONE,0,1,1,nil,ft)
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            if Duel.Destroy(g,REASON_EFFECT)~=0 then
                if tc:IsRelateToEffect(e) then
                    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectMatchingCard(tp,c60151734.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,ft)
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            if Duel.Destroy(g,REASON_EFFECT)~=0 then
                if tc:IsRelateToEffect(e) then
                    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
    end
end