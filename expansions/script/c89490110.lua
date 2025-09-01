--三藏的深奥
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.thfilter(c,atk)
	return c:IsAttackBelow(atk) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and c:IsAbleToHand()
end
function s.filter(c,tp)
	return not c:IsAttack(c:GetBaseAttack()) and c:IsSetCard(0xc31) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,math.abs(c:GetAttack()-c:GetBaseAttack()))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.thfilter2(c,tc)
	return not c:IsCode(tc:GetCode()) and c:IsAttack(1500) and c:IsDefense(1100) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and c:IsAbleToHand()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if not tc:IsAttack(tc:GetBaseAttack()) then
			local dif=math.abs(tc:GetAttack()-tc:GetBaseAttack())
			if dif>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,dif)
				if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
					Duel.ConfirmCards(1-tp,g)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SET_ATTACK_FINAL)
					e1:SetValue(tc:GetBaseAttack())
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
					tc:RegisterEffect(e1)
					local g2=Duel.GetMatchingGroup(s.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,g:GetFirst())
					if g2:GetClassCount(Card.GetCode)>=2 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
						local sg=g2:SelectSubGroup(tp,aux.dncheck,false,2,2)
						if sg:GetCount()>0 then
							Duel.SendtoHand(sg,nil,REASON_EFFECT)
							Duel.ConfirmCards(1-tp,sg)
						end
					end
				end
			end
		end
	end
end
