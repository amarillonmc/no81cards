local m=4878187
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,4878174)
    aux.AddRitualProcGreater2(c,cm.filter,LOCATION_GRAVE,cm.mfilter)
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
end
function cm.filter(c)
    return c:IsSetCard(0xae48)
end
function cm.mfilter(c)
    return c:IsSetCard(0xae48)
end
function cm.spcfilter(c)
    return c:IsCode(4878174) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
   
        if c:IsRelateToEffect(e) then
            Duel.SendtoHand(c,nil,REASON_EFFECT)
        end
end