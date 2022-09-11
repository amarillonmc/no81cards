--青空残想
local s,id,o=GetID()
function c12847003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(c12847003.cost)
	e1:SetCountLimit(1,12847003)
	e1:SetCondition(c12847003.condition)
	e1:SetTarget(c12847003.target)
	e1:SetOperation(c12847003.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--cannot set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SSET)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(0xff)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c12847003.atarget)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12847003,0))
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e4:SetCost(c12847003.cost)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1,12847003+o)
	e4:SetTarget(c12847003.cttg)
	e4:SetOperation(c12847003.ctop)
	c:RegisterEffect(e4)
end
function c12847003.atarget(e,c)
	return c==e:GetHandler()
end
function c12847003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=0
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then
		ct=Duel.GetLP(tp)
	elseif e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		ct=math.floor(Duel.GetLP(tp)/2)
	end
	Duel.PayLPCost(tp,ct)
end
function c12847003.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()<2 then return false end 
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
			return true
		end
	end
	return false
end
function c12847003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp==tp and c:GetFlagEffect(12847003)==0 then c:RegisterFlagEffect(12847003,RESET_CHAIN,0,1) end
		if (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
end
function c12847003.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetCurrentChain()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) then
			Duel.NegateActivation(i)
		end
	end
	if c:GetFlagEffect(12847003)==0 then
		Duel.SetLP(tp,0)
	end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12847030,0,TYPES_TOKEN_MONSTER,ct*1000,ct*1000,1,RACE_PSYCHO,ATTRIBUTE_LIGHT) then
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,12847030)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(ct*1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetValue(ct*1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e2)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
	end
end
function c12847003.ctfilter(c)
	return c:IsFaceup() and c:IsCode(12847030) and c:IsControlerCanBeChanged(true)
end
function c12847003.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c12847003.ctfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c12847003.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c12847003.ctfilter,tp,0,LOCATION_MZONE,nil)
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		g=g:Select(tp,1,1,nil)
	end
	Duel.GetControl(g,tp)
end
