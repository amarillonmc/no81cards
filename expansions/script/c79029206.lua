--镜像衍生物-夜幕突袭
function c79029206.initial_effect(c)
   --disable 
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
   e1:SetCode(EVENT_SPSUMMON_SUCCESS)
   e1:SetCategory(CATEGORY_DISABLE)
   e1:SetOperation(c79029206.cop)
   c:RegisterEffect(e1)
   --to hand
   local e2=Effect.CreateEffect(c)
   e2:SetType(EFFECT_TYPE_IGNITION)
   e2:SetCode(EVENT_FREE_CHAIN)
   e2:SetCategory(CATEGORY_TOHAND)
   e2:SetRange(LOCATION_MZONE)
   e2:SetCountLimit(1)
   e2:SetCost(c79029206.thcost)
   e2:SetOperation(c79029206.thop)
   c:RegisterEffect(e2) 
end
function c79029206.cop(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
   local tc=g:GetFirst()
   while tc do
   local e1=Effect.CreateEffect(e:GetHandler())
   e1:SetType(EFFECT_TYPE_SINGLE)
   e1:SetCode(EFFECT_DISABLE)
   e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
   tc:RegisterEffect(e1)
   local e2=e1:Clone()
   e2:SetCode(EFFECT_DISABLE_EFFECT)
   tc:RegisterEffect(e2)
   tc=g:GetNext()
end
end
function c79029206.thfil(c)
   return c:IsCode(79029203) and c:IsAbleToHand()
end
function c79029206.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDisabled,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c79029206.thfil,tp,LOCATION_GRAVE,0,1,nil) end
   local g=Duel.SelectMatchingCard(tp,Card.IsDisabled,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
   Duel.SendtoGrave(g,REASON_EFFECT+REASON_COST)
end
function c79029206.thop(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.SelectMatchingCard(tp,c79029206.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
   Duel.SendtoHand(g,tp,REASON_EFFECT)
   Duel.ConfirmCards(tp,g)
end




