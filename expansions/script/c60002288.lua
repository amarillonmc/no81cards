local cm,m,o=GetID()
cm.name = "雷迅卿的电光"
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DISABLE+CATEGORY_DRAW)
    e1:SetTarget(cm.tg)
    e1:SetOperation(cm.op)
    c:RegisterEffect(e1)
end
function cm.f(c)
    return c:IsCode(m-3) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.f,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(3,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.f,tp,LOCATION_DECK,0,1,1,nil)
    if #g==0 then return false end
    if Duel.SendtoHand(g,tp,REASON_EFFECT)>0 then
        local py=Duel.GetTurnPlayer()
        if py==tp then
            Duel.Hint(3,tp,HINTMSG_DISABLE)
            local tc=Duel.SelectMatchingCard(tp,cm.f1,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
            if not tc then return false end
            local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
        elseif py==1-tp then
            Duel.Draw(tp,1,REASON_EFFECT)
        end
    end 
end
function cm.f1(c)
    return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT)
end