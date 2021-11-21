--创命的大魔术师
function c16160001.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false) 
--------------"Pendulum EFFECT"----------------
	--cannot sendtohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16160001,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(c16160001.cscost)
	e1:SetTarget(c16160001.cstarget)
	e1:SetOperation(c16160001.csoperation)
	c:RegisterEffect(e1)
	--Token im
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c16160001.eftg)
	e2:SetValue(c16160001.efilter)
	c:RegisterEffect(e2)
	--cannot release
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(0,1)
	e3:SetTarget(c16160001.rellimit)
	c:RegisterEffect(e3)
--------------"Monster EFFECT"----------------
	--Removed Card Cannot Effect
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1_1:SetRange(LOCATION_MZONE)
	e1_1:SetTargetRange(1,1)
	e1_1:SetValue(c16160001.aclimit)
	c:RegisterEffect(e1_1)
	--SpecialSummon Gensyonohoto Token
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetDescription(aux.Stringid(16160001,1))
	e2_1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e2_1:SetType(EFFECT_TYPE_IGNITION)
	e2_1:SetRange(LOCATION_MZONE)
	e2_1:SetCountLimit(1)
	e2_1:SetCost(c16160001.tkcost)
	e2_1:SetTarget(c16160001.tktg)
	e2_1:SetOperation(c16160001.tkop)
	c:RegisterEffect(e2_1)
end
function c16160001.cscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c16160001.cstarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c16160001.csoperation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_TO_HAND)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			e1:SetTarget(c16160001.thtarget)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_DRAW)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetTargetRange(0,1)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function c16160001.thtarget()
	return true
end
function c16160001.eftg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_TOKEN)
end
function c16160001.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer()
end
function c16160001.rellimit(e,c,tp,sumtp)
	return c:IsType(TYPE_TOKEN) and c:IsControler(e:GetHandlerPlayer())
end
function c16160001.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return loc==LOCATION_REMOVED
end
function c16160001.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,3000) end
	Duel.PayLPCost(tp,3000)
end
function c16160001.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,16160002,nil,0x4011,4000,4000,10,RACE_PLANT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c16160001.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,16160002,nil,0x4011,4000,4000,10,RACE_PLANT,ATTRIBUTE_EARTH) then
	local token=Duel.CreateToken(tp,16160002)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(16160001,2))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DESTROYED)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(c16160001.desop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetAbsoluteRange(ep,0,1)
		token:RegisterEffect(e1,true)
	end
end
function c16160001.filter(c,mc)
	if not c then return false end
	if not c:GetReasonEffect() then return c:GetReasonCard()==mc end
	return c:GetReasonCard()==mc or c:GetReasonEffect():GetHandler()==mc
end
function c16160001.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c16160001.filter,nil,e:GetHandler())
	if not sg then return end
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x17a0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x17a0000)
		tc:RegisterEffect(e2)
		tc=sg:GetNext()
	end
end