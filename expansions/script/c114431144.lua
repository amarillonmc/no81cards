--マドルチェ・ビスコンティ
function c114431144.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,3,2)
    c:EnableReviveLimit()
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetDescription(aux.Stringid(114431144,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c114431144.spcost)
    e1:SetTarget(c114431144.sptg)
    e1:SetOperation(c114431144.spop)
    c:RegisterEffect(e1)
    --material
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(114431144,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c114431144.mttg)
    e2:SetOperation(c114431144.mtop)
    c:RegisterEffect(e2)
    --spsummon grave
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,114431144)
    e3:SetTarget(c114431144.grtg)
    e3:SetOperation(c114431144.grop)
    c:RegisterEffect(e3)
    --spsummon extra
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_EXTRA)
    e4:SetCountLimit(1,114431145)
    e4:SetCost(c114431144.excost)
    e4:SetTarget(c114431144.extg)
    e4:SetOperation(c114431144.exop)
    c:RegisterEffect(e4)
end

function c114431144.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c114431144.spfilter(c,e,tp)
    return c:IsSetCard(0x71) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
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

function c114431144.mtfilter(c)
    return c:IsSetCard(0x71) and c:IsType(TYPE_MONSTER)
end
function c114431144.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
        and Duel.IsExistingMatchingCard(c114431144.mtfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c114431144.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,c114431144.mtfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Overlay(c,g)
    end
end

function c114431144.grfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x71) and not c:IsType(TYPE_TOKEN)
end
function c114431144.grtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c114431144.grfilter(chkc,tp) end
    if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c114431144.grfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c114431144.grfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114431144.grop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
        and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        local og=tc:GetOverlayGroup()
        if og:GetCount()>0 then
            Duel.SendtoGrave(og,REASON_RULE)
        end
        Duel.Overlay(c,Group.FromCards(tc))
    end
end

function c114431144.exfilter(c)
    return c:IsSetCard(0x71) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c114431144.defilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c114431144.excost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c114431144.exfilter,tp,LOCATION_HAND,0,1,nil)
        and Duel.IsExistingMatchingCard(c114431144.defilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.ConfirmCards(1-tp,e:GetHandler())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g1=Duel.SelectMatchingCard(tp,c114431144.exfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g2=Duel.SelectMatchingCard(tp,c114431144.defilter,tp,0,LOCATION_MZONE,1,1,nil)
    g1:Merge(g2)
    Duel.ConfirmCards(1-tp,g1:GetFirst())
    Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c114431144.pdfilter(c,e,tp,xyzc)
    return c:IsCode(74641045) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeXyzMaterial(xyzc)
end
function c114431144.extg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
        and Duel.IsExistingMatchingCard(c114431144.pdfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c)
        and Duel.IsPlayerCanSpecialSummonCount(tp,2)
        and Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c114431144.exop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.GetLocationCountFromEx(tp,tp,nil,c)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,c114431144.pdfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,c)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
        c:SetMaterial(Group.FromCards(tc))
        Duel.Overlay(c,Group.FromCards(tc))
        Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
        c:CompleteProcedure()
    end
end
