--能量发生器
function c40011407.initial_effect(c)
	c:EnableCounterPermit(0xf11)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c40011407.target)
	e1:SetOperation(c40011407.activate)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c40011407.ctcon) 
	e2:SetOperation(c40011407.ctop)
	c:RegisterEffect(e2) 
	--draw
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET) 
	e3:SetRange(LOCATION_SZONE) 
	e3:SetCost(c40011407.drcost)
	e3:SetTarget(c40011407.drtg)
	e3:SetOperation(c40011407.drop)
	c:RegisterEffect(e3) 
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(function(e,te) 
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer() end) 
	e4:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0xf11)>0 end)
	c:RegisterEffect(e4)
end
function c40011407.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanAddCounter(tp,0xf11,3,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0xf11)
end
function c40011407.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0xf11,3)
	end
end
function c40011407.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.IsCanAddCounter(tp,0xf11,3,e:GetHandler())
end
function c40011407.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	c:AddCounter(0xf11,3) 
end
function c40011407.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0xf11,7,REASON_COST) end
	c:RemoveCounter(tp,0xf11,7,REASON_COST)
end
function c40011407.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c40011407.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end


