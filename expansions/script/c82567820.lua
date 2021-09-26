--方舟·Rhodes Island
function c82567820.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c82567820.ctcon)
	e2:SetOperation(c82567820.ctop)
	c:RegisterEffect(e2)
	--add counter2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c82567820.ctcon2)
	e3:SetOperation(c82567820.ctop2)
	c:RegisterEffect(e3)
	--add counter3
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c82567820.ctcon3)
	e4:SetOperation(c82567820.ctop3)
	c:RegisterEffect(e4)
	--atk up
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(82567820,0))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCost(c82567820.adcost)
	e5:SetCountLimit(1)
	e5:SetTarget(c82567820.target)
	e5:SetOperation(c82567820.activate)
	e5:SetValue(500)
	c:RegisterEffect(e5)
	--draw
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(82567820,1))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c82567820.dwcon)
	e6:SetCost(c82567820.dwcost)
	e6:SetTarget(c82567820.dwtg)
	e6:SetOperation(c82567820.dwop)
	c:RegisterEffect(e6)
end
function c82567820.ctfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x825) 
	 and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_RITUAL))
end
function c82567820.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c82567820.ctfilter,1,nil,tp)
end
function c82567820.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 c:AddCounter(0x5825,1)
end
function c82567820.ctfilter2(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x825) 
	 and c:IsType(TYPE_LINK) and c:IsLinkAbove(3)
end
function c82567820.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c82567820.ctfilter2,1,nil,tp)
end
function c82567820.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 c:AddCounter(0x5825,1)
end
function c82567820.ctfilter3(c,e,tp)
	return c:IsSetCard(0x825) and c:GetSummonPlayer()==tp and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c82567820.ctcon3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c82567820.ctfilter3,1,nil,nil,tp)
end
function c82567820.ctop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 c:AddCounter(0x5825,1)
end
function c82567820.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x825)
end
function c82567820.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Card.IsCanRemoveCounter(c,tp,0x5825,2,REASON_COST) end
	Card.RemoveCounter(c,tp,0x5825,2,REASON_COST)
end
function c82567820.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c82567820.filter,tp,LOCATION_MZONE,0,nil)
	local nsg=sg:GetCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c82567820.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,sg,nsg,tp,0)
end
function c82567820.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82567820.filter,tp,LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c82567820.dwcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetCounter(0x5825)>0 and Duel.IsExistingMatchingCard(c82567820.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c82567820.dwcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Card.IsCanRemoveCounter(c,tp,0x5825,8,REASON_COST) end
	Card.RemoveCounter(c,tp,0x5825,8,REASON_COST)
end
function c82567820.dwtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local dwc=Duel.GetMatchingGroupCount(c82567820.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,dwc) end
	
	Duel.SetTargetPlayer(tp)
	if dwc<3 then
	Duel.SetTargetParam(dwc)
	else 
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dwc)
end
end
function c82567820.dwop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c82567820.skipcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Card.IsCanRemoveCounter(c,tp,0x5825,8,REASON_COST) end
	Card.RemoveCounter(c,tp,0x5825,8,REASON_COST)
end
function c82567820.skiptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) end
end
function c82567820.skipop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e1:SetCondition(c82567820.skipcon)
	Duel.RegisterEffect(e1,tp)
end
function c82567820.skipcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end