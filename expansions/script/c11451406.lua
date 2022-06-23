--traveler with infinite saga
--21.04.10
local m=11451406
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(0x11e0)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.filter(c,tp)
	return c.traveler_saga and ((c:CheckActivateEffect(false,false,false)~=nil and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsType(TYPE_CONTINUOUS+TYPE_FIELD)) or (c:IsType(TYPE_CONTINUOUS) and c:GetActivateEffect():IsActivatable(tp)) or (c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local tgp=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER)
		return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and (not tgp or tgp~=tp)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g==0 then return end
	local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
	Duel.MoveSequence(tc,0)
	Duel.ConfirmDecktop(tp,1)
	Duel.MoveSequence(tc,1)
	if not cm.filter(tc,tp) then
		local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		local sg=tg:RandomSelect(tp,1)
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	else
		if tc:IsType(TYPE_FIELD) then
			local te=tc:GetActivateEffect()
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.DisableShuffleCheck()
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		elseif tc:IsType(TYPE_CONTINUOUS) then
			local te=tc:GetActivateEffect()
			Duel.DisableShuffleCheck()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		else
			Duel.DisableShuffleCheck()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
			local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,false,true)
			te:UseCountLimit(tp,1,true)
			local cost=te:GetCost()
			local target=te:GetTarget()
			local operation=te:GetOperation()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			Duel.ClearTargetCard()
			if not tc:IsType(TYPE_EQUIP) then tc:CancelToGrave(false) end
			tc:CreateEffectRelation(te)
			if cost then cost(te,tp,ceg,cep,cev,cre,cr,crp,1) end
			if target then target(te,tp,ceg,cep,cev,cre,cr,crp,1) end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g then
				for fc in aux.Next(g) do
					fc:CreateEffectRelation(te)
				end
			end
			if operation then operation(te,tp,ceg,cep,cev,cre,cr,crp) end
			tc:ReleaseEffectRelation(te)
			if g then
				for fc in aux.Next(g) do
					fc:ReleaseEffectRelation(te)
				end
			end
		end
	end
end