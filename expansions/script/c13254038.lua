--元素飞球之雨
local m=13254038
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DECKDES,CATEGORY_DRAW)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	elements={{"tama_elements",{{TAMA_ELEMENT_WIND,1}}}}
	cm[c]=elements
	
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
end
function cm.filter(c)
	return c:IsSetCard(0x356)
end
function cm.filter1(c)
	return c:IsSetCard(0x356) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function cm.filter2(c)
	return c:IsSetCard(0x356) and c:IsAbleToDeck()
end
function cm.filter2a(c)
	return c:IsAbleToDeck()
end
function cm.filter3(c,eg,ep,ev,re,r,rp)
	local PCe=tama.getTargetTable(c,"power_capsule")
	return c:IsFaceup() and PCe and cm.canActivate(c,PCe,eg,ep,ev,re,r,rp)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,5) then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local sg=g:Filter(cm.filter,nil)
	if sg:GetCount()<=0 then return end
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
	local sg1=Duel.GetOperatedGroup()
	local sg2=sg1:Clone()
	if sg1:GetCount()>0 then
		if sg1:GetSum(tama.tamas_getElementCount,TAMA_ELEMENT_WATER)>0 and Duel.IsPlayerCanDiscardDeck(tp,3) then
			Duel.BreakEffect()
			Duel.Hint(HINT_MESSAGE,0,aux.Stringid(m,1))
			Duel.ShuffleDeck(tp)
			Duel.DiscardDeck(tp,3,REASON_EFFECT)
			sg2:Merge(Duel.GetOperatedGroup())
		end
		if sg1:GetSum(tama.tamas_getElementCount,TAMA_ELEMENT_WIND)>0 and Duel.IsPlayerCanDraw(tp,2) then
			Duel.BreakEffect()
			Duel.Hint(HINT_MESSAGE,0,aux.Stringid(m,2))
			Duel.Draw(tp,1,REASON_EFFECT)
			Duel.ShuffleHand(tp)
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
			sg2:Merge(Duel.GetOperatedGroup())
		end
		--[[
		if sg1:GetSum(tama.tamas_getElementCount,TAMA_ELEMENT_CHAOS)>0 and sg2:IsExists(cm.filter2,1,nil) then
			local sg3=sg2:Filter(cm.filter2,nil)
			local ct=sg3:GetCount()
			Duel.BreakEffect()
			Duel.Hint(HINT_MESSAGE,0,aux.Stringid(m,3))
			Duel.SendtoDeck(sg3,tp,2,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg4=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,ct,ct,nil)
			Duel.SendtoGrave(sg4,REASON_EFFECT)
		end
		]]
		if sg1:GetSum(tama.tamas_getElementCount,TAMA_ELEMENT_CHAOS)>0 and sg2:IsExists(cm.filter2a,1,nil) then
			local sg3=sg2:Filter(cm.filter2a,nil)
			Duel.ConfirmCards(tp,sg3)
			if Duel.SelectYesNo(aux.Stringid(m,10)) then
				local ct=sg3:GetCount()
				Duel.BreakEffect()
				Duel.Hint(HINT_MESSAGE,0,aux.Stringid(m,3))
				Duel.SendtoDeck(sg3,tp,2,REASON_EFFECT)
				Duel.ShuffleDeck(tp)
				Duel.DiscardDeck(tp,ct,REASON_EFFECT)
				sg2=Duel.GetOperatedGroup():Clone()
			end
		end
		if sg1:GetSum(tama.tamas_getElementCount,TAMA_ELEMENT_MANA)>=3 then
			Duel.BreakEffect()
			Duel.Hint(HINT_MESSAGE,0,aux.Stringid(m,4))
			--change damage
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(0)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
			e2:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e2,tp)
		end
		if sg1:GetSum(tama.tamas_getElementCount,TAMA_ELEMENT_ENERGY)>=2 and Duel.IsExistingTarget(cm.filter3,tp,LOCATION_MZONE,0,1,nil,eg,ep,ev,re,r,rp) then
			Duel.BreakEffect()
			Duel.Hint(HINT_MESSAGE,0,aux.Stringid(m,5))
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,eg,ep,ev,re,r,rp):GetFirst()
			local tep=tc:GetControler()
			local PCe=tama.getTargetTable(tc,"power_capsule")
			local target=PCe:GetTarget()
			local operation=PCe:GetOperation()
			Duel.ClearTargetCard()
			e:SetProperty(PCe:GetProperty())
			tc:CreateEffectRelation(PCe)
			if target then target(PCe,tep,eg,ep,ev,re,r,rp,1) end
			if operation then operation(PCe,tep,eg,ep,ev,re,r,rp) end
			tc:ReleaseEffectRelation(PCe)
		end
	end

end
