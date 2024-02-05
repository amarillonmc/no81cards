--異界のコネクター
function c49811283.initial_effect(c)
    --act in hand
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e0:SetCondition(c49811283.handcon)
    c:RegisterEffect(e0)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,49811283+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c49811283.target)
    e1:SetOperation(c49811283.activate)
    c:RegisterEffect(e1)
end
function c49811283.handcon(e)
    local tp=e:GetHandlerPlayer()
    local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
    return #g==0 
end    
function c49811283.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c49811283.thfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
        and c:IsLevel(3) and c:IsAttack(1000) and c:IsDefense(1000)
end
function c49811283.gfilter(c,tc)
    return c:IsType(TYPE_MONSTER) and c:IsRace(tc:GetRace())
end
function c49811283.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c49811283.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c49811283.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c49811283.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c49811283.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c49811283.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if Duel.DiscardHand(tp,nil,1,1,REASON_DISCARD+REASON_EFFECT,nil)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c49811283.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,tp,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
    Duel.BreakEffect()
    if tc:IsRelateToEffect(e) then
    	local gg=Duel.GetMatchingGroup(c49811283.gfilter,tp,0,LOCATION_GRAVE,nil,tc)
    	if #gg>=5 then
    		local ct=tc:GetRace()
    		local e1=Effect.CreateEffect(c)
		    e1:SetType(EFFECT_TYPE_FIELD)
		    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		    e1:SetLabel(ct)
		    e1:SetTargetRange(1,1)
		    e1:SetTarget(c49811283.splim)
		    e1:SetReset(RESET_PHASE+PHASE_END,2)
		    Duel.RegisterEffect(e1,tp)
    	end	
    end		
end
function c49811283.splim(e,c,sump,sumtype,sumpos,targetp,se)
    return c:GetRace()&e:GetLabel()>0 and se:IsHasType(EFFECT_TYPE_ACTIONS)
end