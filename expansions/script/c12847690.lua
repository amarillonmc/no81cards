--霜烬决
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter0(c)
	return c:IsAbleToHand() or c:IsAbleToGrave() and (s.filter1(c) or s.filter2(c))
end
function s.filter1(c)
	return c:IsRace(RACE_AQUA) and c:IsAttribute(ATTRIBUTE_WATER)
end
function s.filter2(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.check(g)
	return aux.gffcheck(g,s.filter1,nil,s.filter2,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(s.check,2,2) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,s.check,false,2,2)
	if #sg==2 then
		local ag=sg:Filter(Card.IsAbleToHand,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=ag:Select(tp,1,1,nil)
		local tc=sg1:GetFirst()
		if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,sg1)
			sg:Sub(sg1)
			if #sg>0 then
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
			if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetLabelObject(tc)
				e1:SetTarget(s.splimit)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.splimit(e,c)
	local tc=e:GetLabelObject()
	return not (c:IsRace(tc:GetRace()) and c:IsAttribute(tc:GetAttribute())) and not c:IsLocation(LOCATION_EXTRA)
end