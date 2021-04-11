--LUKA Black Jack
function c60151411.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3b28),5,2)
    c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAIN_SOLVING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(c60151411.regop)
    c:RegisterEffect(e1)
	--equip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60151411,0))
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e2:SetCondition(c60151411.eqcon)
    e2:SetCost(c60151411.eqcost)
    e2:SetTarget(c60151411.eqtg)
    e2:SetOperation(c60151411.eqop)
    c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151411,1))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c60151411.thcost)
    e3:SetOperation(c60151411.thop)
    c:RegisterEffect(e3)
end
function c60151411.regop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_TO_DECK)
    e1:SetReset(RESET_EVENT+0x1fc0000+RESET_CHAIN)
    e1:SetValue(1)
    e:GetHandler():RegisterEffect(e1)
end
function c60151411.cfilter(c)
    return c:GetFlagEffect(60151411)>0
end
function c60151411.eqcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return not c:GetEquipGroup():IsExists(c60151411.cfilter,1,nil)
end
function c60151411.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151411.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c60151411.eqlimit(e,c)
    return e:GetOwner()==c
end
function c60151411.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if c:IsRelateToEffect(e) and c:IsFaceup() then
            if not Duel.Equip(tp,tc,c,false) then return end
            --Add Equip limit
            tc:RegisterFlagEffect(60151411,RESET_EVENT+0x1fe0000,0,0)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(c60151411.eqlimit)
            tc:RegisterEffect(e1)
        else Duel.SendtoGrave(tc,REASON_EFFECT) end
    end
end
function c60151411.filter(c)
    return c:IsSetCard(0x3b28) and c:IsAbleToHand()
end
function c60151411.cfilter2(c)
    return c:GetFlagEffect(60151411)>0 and c:IsAbleToDeckAsCost()
end
function c60151411.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetEquipGroup():IsExists(c60151411.cfilter2,1,nil) 
		and Duel.IsExistingMatchingCard(c60151411.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=c:GetEquipGroup():FilterSelect(tp,c60151411.cfilter2,1,1,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151411.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60151411.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end