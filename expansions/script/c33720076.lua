--无声交流
--Expression in Silence || Espressione nel Silenzio
--Scripted by: XGlitchy30

xpcall(function() require("expansions/script/glitchylib_vsnemo") end,function() require("script/glitchylib_vsnemo") end)

local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--[[While this card is on the field, you skip your Draw Phase.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetCode(EFFECT_SKIP_DP)
	c:RegisterEffect(e2)
	--[[During your Standby Phase: Look at the top 3 cards of your Deck, place 1 of them on the bottom of the Deck, and if you do,
	add 1 of them to your hand, and keep it revealed as long as it remains in your hand, then add the remaining card to your hand.]]
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORIES_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(aux.TurnPlayerCond(0))
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	--[[Once per turn, during the End Phase: Banish, face-down, all revealed cards in your hand that were revealed by this card's effect.]]
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE|PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.rmtg)
	e4:SetOperation(s.rmop)
	c:RegisterEffect(e4)
	--[[When your opponent activates a card or effect, while this card is in the GY: You can banish this card and 1 card with the same name from your GY, face-down, and if you do, negate that effect.]]
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,4))
	e5:SetCategory(CATEGORY_DISABLE|CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(s.discon)
	e5:SetTarget(s.distg)
	e5:SetOperation(s.disop)
	c:RegisterEffect(e5)
end
--E3
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmCards(tp,g)
	local bg=g:Select(tp,1,1,nil)
	if #bg>0 then
		local bc=bg:GetFirst()
		Duel.MoveSequence(bc,1)
		if bc:IsLocation(LOCATION_DECK) and bc:GetSequence()==0 then
			g:RemoveCard(bc)
			local sg=g:Filter(Card.IsAbleToHand,nil)
			if #sg>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg1=sg:Select(tp,1,1,nil)
				if #sg1>0 then
					Duel.DisableShuffleCheck()
					if Duel.SendtoHand(sg1,nil,REASON_EFFECT)>0 and aux.PLChk(sg1,tp,LOCATION_HAND) then
						Duel.ConfirmCards(1-tp,sg1)
						local sc1=sg1:GetFirst()
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetCode(EFFECT_PUBLIC)
						e1:SetLabel(tp)
						e1:SetCondition(s.resetcon)
						e1:SetReset(RESET_EVENT|RESETS_STANDARD)
						sc1:RegisterEffect(e1)
						sc1:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
						sg:RemoveCard(sc1)
						if #sg>0 then
							Duel.BreakEffect()
							Duel.SendtoHand(sg,nil,REASON_EFFECT)
						end
					end
					Duel.ShuffleHand(tp)
				end
			end
		end
	end
end
function s.resetcon(e)
	local c=e:GetHandler()
	if c:GetControler()~=e:GetLabel() then
		e:ResetFlagEffect(id)
		e:Reset()
		return false
	end
	return true
end

--FILTERS E4
function s.revfilter(c,tp)
	return c:IsPublic() and c:HasFlagEffect(id) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
--E4
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.Group(s.revfilter,tp,LOCATION_HAND,0,nil,tp)
	if #g>0 then
		Duel.SetCardOperationInfo(g,CATEGORY_REMOVE)
	end
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(s.revfilter,tp,LOCATION_HAND,0,nil,tp)
	if #g>0 then
		Duel.Banish(g,POS_FACEDOWN)
	end
end

--FILTERS E5
function s.rmfilter(c,tp,code1,code2)
	return c:IsCode(code1,code2) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
--E5
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not Duel.IsChainDisablable(ev) then return false end
	return true
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local code1,code2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
	if chk==0 then
		return not re:GetHandler():IsStatus(STATUS_DISABLED) and c:IsAbleToRemove(tp,POS_FACEDOWN) and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_GRAVE,0,1,c,tp,code1,code2)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,2,tp,LOCATION_GRAVE)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	local code1,code2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
	local g=Duel.Select(HINTMSG_REMOVE,false,tp,aux.Necro(s.rmfilter),tp,LOCATION_GRAVE,0,1,1,c,tp,code1,code2)
	if not c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:IsAbleToRemove(tp,POS_FACEDOWN) then
		g:AddCard(c)
	end
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.Banish(g,POS_FACEDOWN)>0 then
			Duel.NegateEffect(ev)
		end
	end
end