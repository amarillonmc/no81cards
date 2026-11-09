--别忘了做限定任务！
function c33740005.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c33740005.condition)
	e0:SetOperation(c33740005.activate)
	c:RegisterEffect(e0)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33740005.damtg)
	e1:SetOperation(c33740005.damop)
	c:RegisterEffect(e1)
	--count
	Duel.AddCustomActivityCounter(33740005+1,ACTIVITY_CHAIN,c33740005.mfilter)
	Duel.AddCustomActivityCounter(33740005+2,ACTIVITY_CHAIN,c33740005.sfilter)
	Duel.AddCustomActivityCounter(33740005+3,ACTIVITY_CHAIN,c33740005.tfilter)
end
function c33740005.mfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_MONSTER)
end
function c33740005.sfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_SPELL)
end
function c33740005.tfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_TRAP)
end
function c33740005.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	return ct and ct>0
end
function c33740005.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) or not c:IsRelateToChain() then return end
	local ct=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
	if ct then
		for i=1,ct do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if te:IsActiveType(TYPE_MONSTER) and c:GetFlagEffect(33740005+1)==0 then--
				c:RegisterFlagEffect(33740005+1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33740005,1))
			elseif te:IsActiveType(TYPE_SPELL) and c:GetFlagEffect(33740005+2)==0 then
				c:RegisterFlagEffect(33740005+2,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33740005,2))
			elseif te:IsActiveType(TYPE_TRAP) and c:GetFlagEffect(33740005+3)==0 then
				c:RegisterFlagEffect(33740005+3,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33740005,3))
			end
		end
	end
end
function c33740005.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local p=Duel.GetTurnPlayer()
	local val=0
	local clear=true
	for i=1,3 do
		if e:GetHandler():GetFlagEffect(33740005+i)~=0 then
			if Duel.GetCustomActivityCount(33740005+i,p,ACTIVITY_CHAIN)==0 then
				clear=false
			else
				val=val+2000
			end
		end
	end
	if clear then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,p,val)
	else
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,p,2000)
	end
end
function c33740005.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	local val=0
	local clear=true
	for i=1,3 do
		if e:GetHandler():GetFlagEffect(33740005+i)~=0 then
			if Duel.GetCustomActivityCount(33740005+i,p,ACTIVITY_CHAIN)==0 then
				clear=false
			else
				val=val+2000
			end
		end
	end
	if clear then
		Duel.Recover(p,val,REASON_EFFECT)
	else
		Duel.Damage(p,2000,REASON_EFFECT)
	end
end
