--血晶骰子
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(EFFECT_CANNOT_REMOVE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,1)
	e0:SetTarget(s.rmlimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.toss_dice=true
function s.rmlimit(e,c,tp,r)
	return c==e:GetHandler()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	local sg=g:Filter(Card.IsFaceup,nil)
	return sg:GetCount()<=0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(s.chainlm)
end
function s.chainlm(e,ep,tp)
	return tp==ep
end
function s.thfilter(c)
	return c:IsAbleToHand()
end
function s.thfilter1(c,tp)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,c,c)
end
function s.thfilter2(c,ec)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
		and c:GetAttribute()==ec:GetAttribute()
		and c:GetRace()==ec:GetRace()
		and c:GetLevel()==ec:GetLevel()
		and not c:IsCode(ec:GetCode())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc1,dc2=Duel.TossDice(tp,2)
	if (dc1==1 or dc1==2 or dc1==5 or dc1==6) and (dc2==1 or dc2==2 or dc2==5 or dc2==6) then
		if Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
			local tc=g:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tc2=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,tc,tc):GetFirst()
			g:AddCard(tc2)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local dg=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
			if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				for dc in aux.Next(dg) do
					Duel.NegateRelatedChain(dc,RESET_TURN_SET)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					dc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					dc:RegisterEffect(e2)
					if dc:IsType(TYPE_TRAPMONSTER) then
						local e3=Effect.CreateEffect(c)
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
						e3:SetReset(RESET_EVENT+RESETS_STANDARD)
						dc:RegisterEffect(e3)
					end
				end
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
				local dg=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
				if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					for dc in aux.Next(dg) do
						Duel.NegateRelatedChain(dc,RESET_TURN_SET)
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetCode(EFFECT_DISABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						dc:RegisterEffect(e1)
						local e2=Effect.CreateEffect(c)
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e2:SetCode(EFFECT_DISABLE_EFFECT)
						e2:SetValue(RESET_TURN_SET)
						e2:SetReset(RESET_EVENT+RESETS_STANDARD)
						dc:RegisterEffect(e2)
						if dc:IsType(TYPE_TRAPMONSTER) then
							local e3=Effect.CreateEffect(c)
							e3:SetType(EFFECT_TYPE_SINGLE)
							e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
							e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
							e3:SetReset(RESET_EVENT+RESETS_STANDARD)
							dc:RegisterEffect(e3)
						end
					end
				end
			end
		end
	else
		Duel.Draw(1-tp,1,REASON_EFFECT)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetTargetRange(LOCATION_ONFIELD,0)
		e2:SetTarget(s.disable)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.disable(e,c)
	return not c:IsCode(id) and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end