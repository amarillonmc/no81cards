--白夜の操手 ラウラ
function c260013012.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,8,10,c260013012.ovfilter,nil)
    c:EnableReviveLimit()
    c:SetSPSummonOnce(260013012)
        
    --material
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(260013012,1))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(c260013012.mcost)
    e3:SetTarget(c260013012.mtg)
    e3:SetOperation(c260013012.mop)
    c:RegisterEffect(e3)
    
    --attach
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(260013012,2))
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c260013012.thtg)
    e4:SetOperation(c260013012.thop)
    c:RegisterEffect(e4)    
    
    --spsummon
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(260013012,2))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetTarget(c260013012.sptg)
    e5:SetOperation(c260013012.spop)
    c:RegisterEffect(e5)
end

--【召喚ルール】
function c260013012.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x943) and c:IsType(TYPE_LINK)
end


--【X素材補充】
function c260013012.mfilter(c,e)
    return c:IsSetCard(0x943) and c:IsType(TYPE_LINK)
end
function c260013012.mcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
        and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
        and c:GetFlagEffect(260013012)==0 end
    c:RemoveOverlayCard(tp,1,1,REASON_COST)
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
    c:RegisterFlagEffect(260013012,RESET_CHAIN,0,1)
end
function c260013012.mtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
        and Duel.IsExistingMatchingCard(c260013012.mfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c260013012.mop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,c260013012.mfilter,tp,LOCATION_EXTRA,0,1,1,nil,e)
    if g:GetCount()>0 then
        Duel.Overlay(c,g)
    end
end


--【X素材入れ替え】
function c260013012.thfil1(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c260013012.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.GetOverlayCount(tp,1,0)>0 and Duel.IsExistingMatchingCard(c260013012.thfil1,tp,LOCATION_MZONE,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
end
function c260013012.thop(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetOverlayGroup(tp,1,0):Select(tp,1,1,nil)
    if #mg==0 then return end
    local tc=mg:GetFirst()
    local g=Duel.SelectMatchingCard(tp,c260013012.thfil1,tp,LOCATION_MZONE,0,1,1,tc:GetOverlayTarget())
    if #g>0 then
        Duel.Overlay(g:GetFirst(),tc)
        Duel.RaiseSingleEvent(tc:GetOverlayTarget(),EVENT_DETACH_MATERIAL,e,0,0,0,0)
    end
end

--【特殊召喚】
function c260013012.spfilter(c,e,tp)
    return c:IsSetCard(0x943) and not c:IsCode(260013012) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c260013012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c260013012.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c260013012.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c260013012.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end