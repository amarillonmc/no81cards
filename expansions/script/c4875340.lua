function c4875340.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetTarget(c4875340.target)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c4875340.target1)
    e2:SetValue(c4875340.evalue)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c4875340.target1)
    e3:SetValue(500)
    c:RegisterEffect(e3)
    --effect
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(4875340,0))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetCountLimit(1,4875340)
    e4:SetHintTiming(0,TIMING_END_PHASE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCost(c4875340.effcost)
    e4:SetTarget(c4875340.efftg)
    e4:SetOperation(c4875340.effop)
    c:RegisterEffect(e4)
end
function c4875340.evalue(e,re,rp)
    return re:IsActiveType(TYPE_TRAP) and rp==1-e:GetHandlerPlayer()
end
function c4875340.target1(e,c)
	return c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c4875340.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local c=e:GetHandler()
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(4875340,4))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(c4875340.descon)
    e1:SetOperation(c4875340.desop)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
    c:SetTurnCounter(0)
    c:RegisterEffect(e1)
    if c4875340.effcost(e,tp,eg,ep,ev,re,r,rp,0)
        and c4875340.efftg(e,tp,eg,ep,ev,re,r,rp,0)
        and Duel.SelectYesNo(tp,94) then
        c4875340.effcost(e,tp,eg,ep,ev,re,r,rp,1)
        c4875340.efftg(e,tp,eg,ep,ev,re,r,rp,1)
        e:SetOperation(c4875340.effop)
    end
end
function c4875340.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c4875340.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct==2 then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end
function c4875340.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(4875340)==0 end
    e:GetHandler():RegisterFlagEffect(4875340,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
--option 1
function c4875340.costfilter1(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0x55,0x7b) and Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToGraveAsCost()
        and Duel.IsExistingMatchingCard(c4875340.spfilter1,tp,0,LOCATION_ONFIELD,1,nil,e,tp,c)
end
function c4875340.spfilter1(c,e,tp,cc)
    return c:IsFaceup()
end
--option 2
function c4875340.costfilter2(c)
    return c:IsFaceup() and c:IsSetCard(0x55,0x7b) and c:IsAbleToGraveAsCost()
end
function c4875340.thfilter(c)
    return c:IsSetCard(0x55,0x7b) and not c:IsCode(4875340) and c:IsAbleToHand()
end
--option both
function c4875340.costfilter3(c,e,tp)
    return c:IsFaceup() and c:IsCode(93717133) and Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToGraveAsCost()
        and Duel.IsExistingMatchingCard(c4875340.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c) and Duel.IsExistingMatchingCard(c4875340.spfilter1,tp,0,LOCATION_ONFIELD,1,nil,e,tp,c)
end
function c4875340.spfilter2(c,e,tp,cc)
    return c4875340.spfilter1(c,e,tp,cc) and Duel.IsExistingMatchingCard(c4875340.thfilter,tp,LOCATION_DECK,0,1,c)
end
function c4875340.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.IsExistingMatchingCard(c4875340.costfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
    local b2=Duel.IsExistingMatchingCard(c4875340.costfilter2,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(c4875340.thfilter,tp,LOCATION_DECK,0,1,nil)
    if chk==0 then return b1 or b2 end
    local b3=Duel.IsExistingMatchingCard(c4875340.costfilter3,tp,LOCATION_MZONE,0,1,nil,e,tp)
    local op=0
    if b1 and b2 and b3 then
        op=Duel.SelectOption(tp,aux.Stringid(4875340,1),aux.Stringid(4875340,2),aux.Stringid(4875340,3))
    elseif b1 and b2 then
        op=Duel.SelectOption(tp,aux.Stringid(4875340,1),aux.Stringid(4875340,2))
    elseif b1 then
        op=Duel.SelectOption(tp,aux.Stringid(4875340,1))
    else
        op=Duel.SelectOption(tp,aux.Stringid(4875340,2))+1
    end
    e:SetLabel(op)
    if op==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,c4875340.costfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
        e:SetLabelObject(g:GetFirst())
        Duel.SendtoGrave(g,REASON_COST)
        e:SetCategory(CATEGORY_DISABLE)
        Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,tp,LOCATION_MZONE)
    elseif op==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,c4875340.costfilter2,tp,LOCATION_MZONE,0,1,1,nil)
        Duel.SendtoGrave(g,REASON_COST)
        e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,c4875340.costfilter3,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
        e:SetLabelObject(g:GetFirst())
        Duel.SendtoGrave(g,REASON_COST)
        e:SetCategory(CATEGORY_DISABLE+CATEGORY_TOHAND+CATEGORY_SEARCH)
        Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,tp,LOCATION_MZONE)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    end
end
function c4875340.effop(e,tp,eg,ep,ev,re,r,rp)
    local op=e:GetLabel()
    local cc=e:GetLabelObject()
    if op==0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
        local g=Duel.SelectMatchingCard(tp,c4875340.spfilter1,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp,cc)
        if g:GetCount()>0 then
             Duel.HintSelection(g)
        local c=e:GetHandler()
        local tc=g:GetFirst()
		
            Duel.NegateRelatedChain(tc,RESET_TURN_SET)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e2)
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_DISABLE_EFFECT)
            e3:SetValue(RESET_TURN_SET)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e3)
        end
    elseif op==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c4875340.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    else
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
        local g1=Duel.SelectMatchingCard(tp,c4875340.spfilter1,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp,cc)
        if g1:GetCount()>0 then
		         Duel.HintSelection(g1)
        local c=e:GetHandler()
        local tc=g1:GetFirst()
	    if tc then
            Duel.NegateRelatedChain(tc,RESET_TURN_SET)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e2)
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_DISABLE_EFFECT)
            e3:SetValue(RESET_TURN_SET)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e3)
        end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local g2=Duel.SelectMatchingCard(tp,c4875340.thfilter,tp,LOCATION_DECK,0,1,1,nil)
            if g2:GetCount()>0 then
                Duel.BreakEffect()
                Duel.SendtoHand(g2,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,g2)
            end
        end
    end
end
