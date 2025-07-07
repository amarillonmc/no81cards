--智慧光辉
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
		local g=Duel.GetDecktopGroup(tp,3)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Filter(cm.spellfil,nil):Select(p,1,1,nil)
		if sg and Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
			local tc=sg:GetFirst()
			if not tc:IsPublic() then
				local e11=Effect.CreateEffect(c)
				e11:SetType(EFFECT_TYPE_SINGLE)
				e11:SetCode(EFFECT_PUBLIC)
				e11:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e11)
			end
			tc:RegisterFlagEffect(60001538,RESET_EVENT+RESET_LEAVE+RESET_TODECK+RESET_TOGRAVE+RESET_REMOVE,0,1)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		end
		Duel.ShuffleDeck(p)
		if #g:Filter(Card.IsType,nil,TYPE_SPELL)==#g then Duel.Draw(p,1,REASON_EFFECT) end
	end
end
function cm.spellfil(c)
	return c.isSpellboost and c:IsAbleToHand()
end