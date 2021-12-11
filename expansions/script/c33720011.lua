--始源的最终通牒
--Scripted by: XGlitchy30
local id=33720011
local s=_G["c"..tostring(id)]
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e)
	return Duel.GetTurnCount()>=13
end
function s.filter(c,tp)
	return c:IsAbleToHand() or c:IsAbleToRemove(1-tp,POS_FACEDOWN)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,5,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnCount()<13 then return end
	local ct=Duel.Damage(tp,Duel.GetLP(tp)-100,REASON_EFFECT)
	if ct~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,5,5,nil,tp)
		if #g>0 then
			local op=Duel.SelectOption(1-tp,aux.Stringid(id,0),aux.Stringid(id,1))
			if op==0 then
				local fg=g:Filter(Card.IsAbleToHand,nil)
				if #fg>0 then
					Duel.SendtoHand(fg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,fg)
				else
					Duel.ConfirmCards(1-tp,g)
				end
			else
				local fg=g:Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)
				if #fg>0 then
					if Duel.Remove(fg,POS_FACEDOWN,REASON_EFFECT)>0 then
						Duel.Damage(1-tp,ct,REASON_EFFECT)
					end
				else
					Duel.ConfirmCards(1-tp,g)
				end
			end
		end
	end
end