--灵魂献祭
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsLocation(LOCATION_HAND)
end
function s.tgfilter(c)
	return c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>2 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>2 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,PLAYER_ALL,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g1=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	local g2=Duel.GetFieldGroup(1-p,0,LOCATION_HAND)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.ConfirmCards(p,g1)
		Duel.ConfirmCards(1-p,g2)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg1=g1:Select(p,1,1,nil)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
		if sg1:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_FORBIDDEN)
			e1:SetTargetRange(0xff,0xff)
			e1:SetTarget(s.bantg)
			e1:SetLabel(sg1:GetFirst():GetOriginalCodeRule())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			Duel.RegisterEffect(e1,tp)
		end
		Duel.ShuffleHand(1-p)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg2=g2:Select(1-p,1,1,nil)
		Duel.SendtoGrave(sg2,REASON_EFFECT)
		if sg2:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)>0 then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EFFECT_FORBIDDEN)
			e2:SetTargetRange(0xff,0xff)
			e2:SetTarget(s.bantg)
			e2:SetLabel(sg2:GetFirst():GetOriginalCodeRule())
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			Duel.RegisterEffect(e2,tp)
		end
		Duel.ShuffleHand(p)
		if Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_EXTRA,0,1,nil) then
			local g3=Duel.GetFieldGroup(1-p,0,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_EXTRA)
			Duel.ConfirmCards(1-p,g3)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg3=Duel.SelectMatchingCard(1-tp,s.tgfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_EXTRA,0,1,1,nil)
			if sg3:GetCount()>0 then
				Duel.SendtoGrave(sg3,REASON_EFFECT)
				if sg3:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)>0 then
					local e3=Effect.CreateEffect(e:GetHandler())
					e3:SetType(EFFECT_TYPE_FIELD)
					e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
					e3:SetCode(EFFECT_FORBIDDEN)
					e3:SetTargetRange(0xff,0xff)
					e3:SetTarget(s.bantg)
					e3:SetLabel(sg3:GetFirst():GetOriginalCodeRule())
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					Duel.RegisterEffect(e3,tp)
				end
			end
		end
	end
end
function s.bantg(e,c)
	local fcode=e:GetLabel()
	return c:IsOriginalCodeRule(fcode)
end