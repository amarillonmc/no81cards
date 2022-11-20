--溶解
function c10113025.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10113025.cost)
	e1:SetTarget(c10113025.target)
	e1:SetOperation(c10113025.activate)
	c:RegisterEffect(e1)	  
end
function c10113025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000)
	else Duel.PayLPCost(tp,1000) end
end
function c10113025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,sg,sg:GetCount(),0,0)
	if sg:GetCount()>=3 then
	   Duel.SetChainLimit(c10113025.chlimit)
	end
end
function c10113025.chlimit(e,ep,tp)
	return tp==ep or not e:IsActiveType(TYPE_MONSTER)
end
function c10113025.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg,c=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil),e:GetHandler()
	if sg:GetCount()<=0 then return end
	local fid=c:GetFieldID()
	local tc=sg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(10113025,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e5:SetValue(tc:GetDefense()/2)
		tc:RegisterEffect(e5)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		tc=sg:GetNext()
	end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetLabel(fid)
	sg:KeepAlive()
	e4:SetLabelObject(sg)
	e4:SetCondition(c10113025.adcon)
	e4:SetOperation(c10113025.adop)
	Duel.RegisterEffect(e4,tp)
end
function c10113025.rfilter(c,fid)
	return c:GetFlagEffect(10113025) > 0 and c:GetFlagEffectLabel(10113025) == fid
end
function c10113025.adcon(e,tp)
	local g = e:GetLabelObject()
	if g:FilterCount(c10113025.rfilter,nil,e:GetLabel()) <= 0 then 
		g:DeleteGroup()
		e:Reset()
		return false
	else
		return true
	end
end
function c10113025.adop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10113025)
	local g = e:GetLabelObject():Filter(c10113025.rfilter,nil,e:GetLabel())
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e2)
	end
	g:DeleteGroup()
end
