--幻想山河 寄宿精灵的蒂奥
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.sumcon)
	e1:SetCost(s.sumcost)
	e1:SetTarget(s.sumtg)
	e1:SetOperation(s.sumop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(id)
	c:RegisterEffect(e2)
	if not aux.dio_fantasy_check then
		aux.dio_fantasy_check=true
		fantasy_IsAbleToHand=Card.IsAbleToHand
		fantasy_IsAbleToHandAsCost=Card.IsAbleToHandAsCost
		fantasy_SendtoHand=Duel.SendtoHand
		function Card.IsAbleToHand(card_c,int_player)
			if card_c:GetCode()==id and card_c:IsLocation(LOCATION_DECK) then
				local pl=0
				if int_player then
					pl=int_player
				else
					pl=card_c:GetOwner()
				end
				if not Duel.IsExistingMatchingCard(s.fantasy_setfilter,pl,LOCATION_DECK,0,1,nil) then return false end
			end
			return fantasy_IsAbleToHand(card_c,int_player)
		end
		function Card.IsAbleToHandAsCost(card_c)
			if card_c:GetCode()==id and card_c:IsLocation(LOCATION_DECK) then
				local pl=card_c:GetOwner()
				if not Duel.IsExistingMatchingCard(s.fantasy_setfilter,pl,LOCATION_DECK,0,1,nil) then return false end
			end
			return fantasy_IsAbleToHandAsCost(card_c)
		end
		function Duel.SendtoHand(card_c_or_g,int_player,int_reason)
			if aux.GetValueType(card_c_or_g)=='Group' then
				for card_c in aux.Next(card_c_or_g) do
					local pl=0
					if int_player then
						pl=int_player
					else
						pl=card_c:GetOwner()
					end
					if card_c:GetCode()==id and card_c:IsLocation(LOCATION_DECK) then
						if not Duel.IsExistingMatchingCard(s.fantasy_setfilter,pl,LOCATION_DECK,0,1,nil) then return end
						Duel.Hint(HINT_SELECTMSG,pl,HINTMSG_SET)
						local g=Duel.SelectMatchingCard(pl,s.fantasy_setfilter,pl,LOCATION_DECK,0,1,1,nil)
						local tc=g:GetFirst()
						if tc and Duel.SSet(pl,tc)~=0 then
							Duel.BreakEffect()
						end
					end
				end
			else
				local pl=0
				if int_player then
					pl=int_player
				else
					pl=card_c_or_g:GetOwner()
				end
				if card_c_or_g:GetCode()==id and card_c_or_g:IsLocation(LOCATION_DECK) then
					if not Duel.IsExistingMatchingCard(s.fantasy_setfilter,pl,LOCATION_DECK,0,1,nil) then return end
					Duel.Hint(HINT_SELECTMSG,pl,HINTMSG_SET)
					local g=Duel.SelectMatchingCard(pl,s.fantasy_setfilter,pl,LOCATION_DECK,0,1,1,nil)
					local tc=g:GetFirst()
					if tc and Duel.SSet(pl,tc)~=0 then
						Duel.BreakEffect()
					end
				end
			end
			return fantasy_SendtoHand(card_c_or_g,int_player,int_reason)
		end
	end
end
s.fantasy_mountains_and_rivers=true
function s.fantasy_setfilter(c)
	return c.fantasy_mountains_and_rivers
		and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function s.tgfilte(c)
	return c.fantasy_mountains_and_rivers and c:IsAbleToGrave()
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and (e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) or 1==1)
		and e:GetHandler():IsSummonable(true,nil)
		and Duel.IsExistingMatchingCard(s.tgfilte,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilte,tp,LOCATION_HAND,0,1,1,c)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) and Duel.Draw(tp,1,REASON_EFFECT)~=0
		and c:IsRelateToEffect(e) and c:IsSummonable(true,nil) then
		Duel.BreakEffect()
		Duel.Summon(tp,c,true,nil)
	end
end