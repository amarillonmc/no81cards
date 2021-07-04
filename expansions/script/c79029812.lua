--构造的压制
function c79029812.initial_effect(c)
   --activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetCost(c79029812.cost)
	e0:SetCondition(c79029812.con)
	e0:SetTarget(c79029812.tg)
	e0:SetOperation(c79029812.op)
	c:RegisterEffect(e0) 
end
function c79029812.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c79029812.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and rp~=tp
end
function c79029812.rlfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and c:IsSetCard(0xa991) and c:IsReleasable()
end
function c79029812.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c79029812.rlfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return mg:GetCount()>0
	end
	local rg=Duel.SelectReleaseGroup(tp,c79029812.rlfilter,1,mg:GetCount(),nil)
	local num_1=Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if num_1>=2 then
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DAMAGE)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,num_1*400,1-tp,0,0)
	elseif num_1>=3 then
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DAMAGE+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,num_1*400,1-tp,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,0,0)
	elseif num_1>=4 then
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DAMAGE+CATEGORY_DRAW+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,num_1*400,1-tp,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,0,0)
	elseif num_1>=5 then
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DAMAGE+CATEGORY_DRAW+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,num_1*400,1-tp,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,0,0)
	end
	if num_1>0 then
		if re and re:GetHandler():IsRelateToEffect(e) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,tp,0,0)
		end
	end
	e:SetLabel(num_1)
end
function c79029812.op(e,tp,eg,ep,ev,re,r,rp)
	local num=e:GetLabel()
	if num>0 and Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	if num>1 then	 
		Duel.Damage(1-tp,num*400,REASON_EFFECT)
	end
	if num>2 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if num>3 then
		local cg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
		for tc in aux.Next(cg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc:RegisterEffect(e3)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_TRIGGER)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end