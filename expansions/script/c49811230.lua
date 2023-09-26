--強欲で大欲な壺
function c49811230.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c49811230.condition)
    e1:SetTarget(c49811230.target)
    e1:SetOperation(c49811230.activate)
    c:RegisterEffect(e1)
end
function c49811230.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) -10 >=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK) and Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c49811230.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
    if chk==0 then return ct>=10 end
    local ot = math.floor(ct/10)
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(ct)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ot,0,LOCATION_DECK)
end
function c49811230.activate(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.ConfirmDecktop(p,d)
    local ot = math.floor(d/10)
    local g=Duel.GetDecktopGroup(p,d)
    if #g>0 and #g<10 then
        Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
    end
    if #g>9 then
        Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
        local sc=g:Select(p,ot,ot,nil)
        g:Sub(sc)
        local tc=sc:GetFirst()
        while tc do
            if tc:IsAbleToHand() then
                Duel.SendtoHand(tc,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-p,tc)
                Duel.ShuffleHand(tc)
            else
                Duel.SendtoGrave(tc,REASON_RULE)
            end
            tc=sc:GetNext()
        end            
        Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
    end    
end 
