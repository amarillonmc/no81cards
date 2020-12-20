--幽波纹之力
function c33711005.initial_effect(c)
	c:SetUniqueOnField(LOCATION_SZONE,0,33711005)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Cal cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetOperation(c33711005.costop)
	c:RegisterEffect(e2)
end
function c33711005.actarget(e,te,tp)
	return true
end
function c33711005.atkcostfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove(tp,POS_FACEUP,REASON_RULE)
end
function c33711005.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,33711005)
	local num1=0
	local num2=0
	local num3=0
	local num4=0
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	local sg=Group.CreateGroup()
	sg:AddCard(a)
	sg:AddCard(b)
	local sg1=sg:Filter(Card.IsControler,nil,tp)
	local sg2=sg:Filter(Card.IsControler,nil,1-tp)
	local tc=Duel.SelectMatchingCard(tp,c33711005.atkcostfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc2=Duel.SelectMatchingCard(1-tp,c33711005.atkcostfilter,1-tp,LOCATION_DECK,0,1,1,nil,1-tp)
	if tc:GetCount()>0 then
		tc=tc:GetFirst()
		num1=tc:GetTextAttack()
		num2=tc:GetTextDefense()
	end
	if tc2:GetCount()>0 then
		tc2=tc2:GetFirst()
		num3=tc2:GetTextAttack()
		num4=tc2:GetTextDefense()  
	end
	Duel.Remove(tc,POS_FACEUP,REASON_RULE)
	Duel.Remove(tc2,POS_FACEUP,REASON_RULE)
	for i in aux.Next(sg1) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(num1)
		i:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(num2)
		i:RegisterEffect(e2)
	end
	for i in aux.Next(sg2) do
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e3:SetValue(num3)
		i:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_UPDATE_DEFENSE)
		e4:SetValue(num4)
		i:RegisterEffect(e4)
	end
end