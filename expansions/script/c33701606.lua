--银流秘术H·任宁古测量结界
local m=33701606
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.coinop)
	c:RegisterEffect(e1)
end
cm.toss_coin=true
function cm.tgfilter(c)
	return c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.filter(c)
	return c:IsAbleToHand() 
end
function cm.coinop(e,tp,eg,ep,ev,re,r,rp)
    local c1,c2,c3=Duel.TossCoin(tp,3)
    if c1+c2+c3==0 then
        Duel.Draw(1-tp,3,REASON_EFFECT)
        Duel.BreakEffect()  
        Duel.ConfirmDecktop(tp,3)
        local g=Duel.GetDecktopGroup(tp,3)
        ac=g:GetCount()
        if ac>0 then
            Duel.SortDecktop(tp,tp,ac)
            for i=1,ac do
                local mg=Duel.GetDecktopGroup(tp,1)
                Duel.MoveSequence(mg:GetFirst(),1)
            end
        end
    elseif c1+c2+c3==1 then
        Duel.ConfirmDecktop(tp,3)
        local g=Duel.GetDecktopGroup(tp,3)
        if g:GetCount()>0 then
            Duel.DisableShuffleCheck()
            if g:IsExists(cm.filter,1,nil) then
                Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
                local sg=g:FilterSelect(1-tp,cm.filter,2,2,nil)
                Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
                Duel.ConfirmCards(tp,sg)
                Duel.ShuffleHand(1-tp)
                g:Sub(sg)
            end   
            Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
        end
    elseif c1+c2+c3==2 then
        Duel.ConfirmDecktop(tp,3)
        local g=Duel.GetDecktopGroup(tp,3)
        if g:GetCount()>0 then
            if g:IsExists(cm.filter,1,nil) then
                Duel.DisableShuffleCheck()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
                local sg=g:FilterSelect(tp,cm.filter,1,1,nil)
                Duel.SendtoHand(sg,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,sg)
                Duel.ShuffleHand(tp)
                g:Sub(sg)
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
                local sg=g:FilterSelect(tp,cm.filter,1,1,nil)
                Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
                g:Sub(sg)
            end
            Duel.SendtoHand(g,1-tp,REASON_EFFECT)
            Duel.ConfirmCards(tp,g)
            Duel.ShuffleHand(1-tp)
        end
    elseif c1+c2+c3==3 then
        Duel.ConfirmDecktop(tp,3)
        local g=Duel.GetDecktopGroup(tp,3)
        if g:GetCount()>0 then
            if g:IsExists(cm.filter,1,nil) then
                Duel.DisableShuffleCheck()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
                local sg=g:FilterSelect(tp,cm.filter,3,3,nil)
                Duel.SendtoHand(sg,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,sg)
                Duel.ShuffleHand(tp)
            end
        end
    end
end