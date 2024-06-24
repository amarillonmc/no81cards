--絆の物語
function c260013024.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,260013024)
    e1:SetTarget(c260013024.target)
    e1:SetOperation(c260013024.activate)
    c:RegisterEffect(e1)
    
    --remove overlay replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,260013024)
    e2:SetCondition(c260013024.rcon)
    e2:SetOperation(c260013024.rop)
    c:RegisterEffect(e2)
    
end
    
--【サーチ】 
function c260013024.filter(c)
    return c:IsSetCard(0x943) and not c:IsCode(260013024) and c:IsAbleToHand()
end
function c260013024.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c260013024.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c260013024.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c260013024.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

--【X素材代用】
function c260013024.rcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_COST)~=0 and re:IsActivated()
        and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0x943)
        and e:GetHandler():IsAbleToRemoveAsCost()
        and ep==e:GetOwnerPlayer() and ev==1
end
function c260013024.rop(e,tp,eg,ep,ev,re,r,rp)
    return Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
