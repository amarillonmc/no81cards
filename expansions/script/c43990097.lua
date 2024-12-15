--N公司的审判准备
local m=43990097
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c43990097.target)
	e1:SetOperation(c43990097.activate)
	c:RegisterEffect(e1)
end
function c43990097.filter(c)
	return c:IsSetCard(0x3510) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c43990097.thfilter(c)
	return c:IsSetCard(0x3510) and c:IsAbleToHand()
end
function c43990097.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990097.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c43990097.cgfilter(c)
	return not c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function c43990097.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c43990097.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingTarget(c43990097.cgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(43990097,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			Duel.BreakEffect()
			local sc=Duel.SelectMatchingCard(tp,c43990097.cgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp):GetFirst()
			if sc:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_RACE)
				e1:SetValue(RACE_MACHINE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1)
				if sc:IsImmuneToEffect(e) or not sc:IsRace(RACE_MACHINE) then
					if Duel.IsExistingMatchingCard(c43990097.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(43990097,3)) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
						Duel.BreakEffect()
						 local ttg=Duel.SelectMatchingCard(tp,c43990097.thfilter,tp,LOCATION_DECK,0,1,1,nil)
						if ttg:GetCount()>0 then
							Duel.SendtoHand(ttg,nil,REASON_EFFECT)
							Duel.ConfirmCards(1-tp,ttg)
						end
					end
				end
			end
		end
	end
end
