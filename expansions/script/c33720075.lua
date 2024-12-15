--[[慈英州対張銅羅
Duel of the Walkers
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id,o=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
Duel.LoadScript("glitchylib_lprecover.lua")
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--Counter Permit workaround for placing counters at activation (do NOT assign the EFFECT_FLAG_SINGLE_RANGE property)
	local ct=Effect.CreateEffect(c)
	ct:SetType(EFFECT_TYPE_SINGLE)
	ct:SetRange(LOCATION_FZONE)
	ct:SetCode(EFFECT_COUNTER_PERMIT|0x337)
	c:RegisterEffect(ct)
	--[[Activate this card by paying half of your LP. If you do, when this card resolves, place 1 Life Counter on this card for every 400 LP you paid this way (rounded up).]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
	--[[Monsters cannot activate their effects or declare an attack, during the turn they were Normal Summoned/Set.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(s.aclimit)
	c:RegisterEffect(e2)
	local e2x=Effect.CreateEffect(c)
	e2x:SetType(EFFECT_TYPE_FIELD)
	e2x:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2x:SetRange(LOCATION_FZONE)
	e2x:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2x:SetTarget(aux.TargetBoolFunction(Card.HasFlagEffect,id))
	c:RegisterEffect(e2x)
	--[[You choose the attack targets for your opponent's attacks, also you can make them direct attacks.]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,1)
	c:RegisterEffect(e3)
	local e3x=Effect.CreateEffect(c)
	e3x:SetType(EFFECT_TYPE_FIELD)
	e3x:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3x:SetCode(EFFECT_DIRECT_ATTACK)
	e3x:SetRange(LOCATION_FZONE)
	e3x:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e3x)
	--[[If you would gain LP, place 1 Life Counter on this card for each 400 LP you would have gained, instead.]]
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_RECOVER)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(s.recval)
	c:RegisterEffect(e4)
	xgl.RegisterChangeBattleRecoverHandler()
	--[[If you would take damage, remove 1 Life Counter from this card for each 400 damage you would have taken, instead.]]
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(1,0)
	e5:SetValue(s.damval)
	c:RegisterEffect(e5)
	local e5x=e5:Clone()
	e5x:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e5x:SetValue(s.CheckProtectionApplicability)
	c:RegisterEffect(e5x)
	--[[If there are no Life Counters on this card, send it to the GY.]]
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_SELF_TOGRAVE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(s.selftg)
	c:RegisterEffect(e6)
	--[[If this card leaves the field: Halve your LP.]]
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,1))
	e7:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetOperation(s.hlop)
	c:RegisterEffect(e7)
	--
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.regsum)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.regsum(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(id,RESET_EVENT|(RESETS_STANDARD&(~(RESET_TEMP_REMOVE|RESET_TURN_SET)))|RESET_PHASE|PHASE_END,EFFECT_FLAG_SET_AVAILABLE,1)
	end
end

--E1
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cost=math.floor(Duel.GetLP(tp)/2)
	if chk==0 then return c:IsCanAddCounter(0x337,math.ceil(cost/400),false,LOCATION_FZONE) end
	Duel.PayLPCost(tp,cost)
	e:SetLabel(math.ceil(cost/400))
	c:AddCounter(0x337,math.ceil(cost/400))
end

--E2
function s.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and re:IsActiveType(TYPE_MONSTER) and tc:HasFlagEffect(id)
end

--E4
function s.recval(e,r,val,re,chk)
	local c=e:GetHandler()
	local ct=math.floor(val/400)
	if chk==0 then
		return c:IsCanAddCounter(0x337,ct)
	end
	if ct>0 and c:IsCanAddCounter(0x337,ct) then
		c:AddCounter(0x337,ct)
	end
	return 0
end

--E5
function s.damval(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local ct=math.floor(val/400)
	if ct>0 and c:IsCanRemoveCounter(tp,0x337,ct,REASON_EFFECT) then
		Duel.IgnoreActionCheck(Card.RemoveCounter,c,tp,0x337,ct,REASON_EFFECT)
		return 0
	end
	return ev
end
--E5X 
function s.CheckProtectionApplicability(e,dam)
	return dam>=400
end

--E6
function s.selftg(e)
	return e:GetHandler():GetCounter(0x337)==0
end

--E7
function s.hlop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
end