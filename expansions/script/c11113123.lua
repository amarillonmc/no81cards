--无谋的欲望
function c11113123.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_SPSUMMON,TIMING_SUMMON)
	e1:SetCountLimit(1,11113123+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11113123.target)
	e1:SetOperation(c11113123.activate)
	c:RegisterEffect(e1)
end
function c11113123.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	local atk=tg:GetFirst():GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function c11113123.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		local atk=tg:GetFirst():GetAttack()
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=tg:Select(tp,1,1,nil)
			if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
			    Duel.Recover(tp,atk,REASON_EFFECT)
				local cg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_GRAVE,LOCATION_DECK+LOCATION_GRAVE,nil,sg:GetFirst():GetCode())
				if cg:GetCount()>0 and Duel.GetLP(tp)<Duel.GetLP(1-tp) 
				   and not Duel.IsPlayerAffectedByEffect(tp,30459350) and Duel.SelectYesNo(tp,aux.Stringid(11113123,0)) then
				    Duel.BreakEffect()
					local ct=Duel.Remove(cg,POS_FACEUP,REASON_EFFECT)
					Duel.Recover(tp,ct*500,REASON_EFFECT)
				end
			end
		elseif Duel.SendtoGrave(tg,REASON_EFFECT)~=0 then
		    Duel.Recover(tp,atk,REASON_EFFECT)
			local cg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_GRAVE,LOCATION_DECK+LOCATION_GRAVE,nil,tg:GetFirst():GetCode())
			if cg:GetCount()>0 and Duel.GetLP(tp)<Duel.GetLP(1-tp) 
			   and not Duel.IsPlayerAffectedByEffect(tp,30459350) and Duel.SelectYesNo(tp,aux.Stringid(11113123,0)) then
			    Duel.BreakEffect()
				local ct=Duel.Remove(cg,POS_FACEUP,REASON_EFFECT)
				Duel.Recover(tp,ct*500,REASON_EFFECT)
			end
		end
	end
	local rct=1
	if Duel.GetTurnPlayer()~=tp then rct=2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c11113123.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,rct)
	Duel.RegisterEffect(e1,tp)
end
function c11113123.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL)
end