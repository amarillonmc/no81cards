--[[
疑·虚拟YouTuber 动物朋友 飞棍
Anifriends VTuber? Skyfish
Aniamici VTuber? Pesce del Cielo
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--[[Before damage calculation, if this card battles: Excavate a number of cards from the top of your Deck equal to the number of cards in your opponent's hand,
	or to the number of monsters your opponent controls (whichever is higher, or your entire Deck, if less than that), and if you do,
	if the excavated cards all have different names from each other, you can add 1 of them to your hand, and if you do that, if this card is battling a monster,
	send that monster to the GY, also place the rest of excavated cards on the bottom of your Deck, in any order.
	Otherwise, if there are cards with the same name among the excavated cards, send this card to the GY, also place the excavated cards on the top of the Deck in the same order.]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH|CATEGORY_TOHAND|CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
--E1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and bc and bc:IsRelateToBattle() then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,bc,1,0,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	local ct1,ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND),Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if ct1+ct2==0 then return end
	ct=math.min(ct,math.max(ct1,ct2))
	Duel.ConfirmDecktop(tp,ct)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,ct)
	if aux.dncheck(g) then
		Duel.DisableShuffleCheck(true)
		local tg=g:Filter(Card.IsAbleToHand,nil)
		if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tc=tg:Select(tp,1,1,nil):GetFirst()
			if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT|REASON_REVEAL)>0 and tc:IsLocation(LOCATION_HAND) then
				Duel.ConfirmCards(1-tp,tc)
				ct=ct-1
			end
		end
		if c:IsRelateToChain() and c:IsRelateToBattle() then
			local bc=c:GetBattleTarget()
			if bc and bc:IsRelateToBattle() and bc:IsAbleToGrave() then
				Duel.SendtoGrave(bc,REASON_EFFECT)
			end
		end
		if ct>0 then
			Duel.SortDecktop(tp,tp,ct)
			for i=1,ct do
				local mg=Duel.GetDecktopGroup(tp,1)
				Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
			end
		end
	else
		if c:IsRelateToChain() and c:IsAbleToGrave() then
			Duel.SendtoGrave(c,REASON_EFFECT)
		end
	end
end