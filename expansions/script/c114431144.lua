function c114431144.initial_effect(c)
    aux.AddXyzProcedure(c,nil,3,2)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(114431144,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(c114431144.cost)
    e1:SetTarget(c114431144.sptg)
    e1:SetOperation(c114431144.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(114431144,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c114431144.mttg)
    e2:SetOperation(c114431144.mtop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1,114431144)
    e3:SetTarget(c114431144.hsptg)
    e3:SetOperation(c114431144.hspop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_EXTRA)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetCountLimit(1,144311441)
    e4:SetCost(c114431144.cost2)
    e4:SetTarget(c114431144.target2)
    e4:SetOperation(c114431144.operation2)
    c:RegisterEffect(e4)
end
function c114431144.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c114431144.spfilter(c,e,tp)
    return c:IsSetCard(0x71) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c114431144.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c114431144.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c114431144.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c114431144.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c114431144.mtfilter(c,sc)
    return c:IsSetCard(0x71) and c:IsType(TYPE_MONSTER) and c:IsCanBeXyzMaterial(sc)
end
function c114431144.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c114431144.mtfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c) end
end
function c114431144.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,c114431144.mtfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Overlay(c,g)
    end
end
function c114431144.mtfilter2(c,sc)
    return c:IsFaceup() and c:IsSetCard(0x71) and c:IsType(TYPE_MONSTER) and c:IsCanBeXyzMaterial(sc)
end
function c114431144.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chkc then return chkc:IsOnField() and c114431144.mtfilter2(chkc,c) end
    if chk==0 then return Duel.IsExistingTarget(c114431144.mtfilter2,tp,LOCATION_MZONE,0,1,nil,c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectTarget(tp,c114431144.mtfilter2,tp,LOCATION_MZONE,0,1,1,nil,c)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c114431144.hspop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        local og=tc:GetOverlayGroup()
        if og:GetCount()>0 then
            Duel.SendtoGrave(og,REASON_RULE)
        end
        Duel.Overlay(c,tc)
    end
end
function c114431144.filter2(c)
    return c:IsSetCard(0x71) and c:IsAbleToDeckAsCost()
end
function c114431144.filter3(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c114431144.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g1=Duel.GetMatchingGroup(c114431144.filter2,tp,LOCATION_HAND,0,nil)
    local g2=Duel.GetMatchingGroup(c114431144.filter3,tp,0,LOCATION_MZONE,nil)
    if chk==0 then return g1:GetCount()>0 and g2:GetCount()>0 end
    Duel.ConfirmCards(1-tp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local tg=g1:Select(tp,1,1,nil)
    Duel.ConfirmCards(1-tp,tg)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    tg:Merge(g2:Select(tp,1,1,nil))
    Duel.SendtoDeck(tg,nil,2,REASON_COST)
end
function c114431144.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g3=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,74641045)
    if chk==0 then return g3:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g3:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true,POS_FACEUP) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g3:GetFirst(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c114431144.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g3=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,74641045)
    if not (g3:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true,POS_FACEUP)) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tc=g3:Select(tp,1,1,nil):GetFirst()
    if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==1 then
        c:SetMaterial(Group.FromCards(tc))
        Duel.Overlay(c,Group.FromCards(tc))
        Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
        c:CompleteProcedure()
    end
end