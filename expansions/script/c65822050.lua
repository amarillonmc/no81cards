--天之将临制裁之时
local s,id,o=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end
function s.costfilter(c)
    return c:IsType(TYPE_DUAL)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ret_group=Group.CreateGroup()
    for i=1,ev do
        local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
        if tgp~=tp then
            local tc=te:GetHandler()
            Duel.ChangeChainOperation(i,aux.NULL)
            if tc and tc:IsRelateToEffect(te) then
                local flag=tc:IsStatus(STATUS_LEAVE_CONFIRMED)
		        if flag then
			        tc:CancelToGrave()
		        end
                if tc:IsAbleToHand(tp) then
                    Duel.SendtoHand(tc,tp,REASON_EFFECT)
		        elseif flag then
			        tc:CancelToGrave(false)
		        end
            end
        end
    end
end