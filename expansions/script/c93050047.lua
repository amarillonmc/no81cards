--逻辑锁定员
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,93050047)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--初始化全局表
	if not s.global_check then
		s.global_check=true
		s.act_table={{},{},{}}
	end
	--回合结束清空
	s.act_table[1]={}
	--记录发动
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(s.count)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--被无效时删除
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(s.rst)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	--发动限制
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetCondition(s.econ)
	e4:SetValue(s.elimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function s.count(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local tc=re:GetHandler()
	local loc=re:GetActivateLocation()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) or loc&(LOCATION_MZONE|LOCATION_SZONE|LOCATION_OVERLAY)~=0 then
		loc=LOCATION_ONFIELD
	end
	local code=tc:GetCode()
	local p=rp+1
	Debug.Message(loc)
	if not s.act_table[p][code] then
		s.act_table[p][code]={}
	end
	s.act_table[p][code][loc]=true
end
function s.rst(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local tc=re:GetHandler()
	local loc=re:GetActivateLocation()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) or loc&(LOCATION_MZONE|LOCATION_SZONE|LOCATION_OVERLAY)~=0 then
		loc=LOCATION_ONFIELD
	end
	local code=tc:GetCode()
	local p=rp+1
	Debug.Message(loc)
	if s.act_table[p][code] then
		s.act_table[p][code][loc]=nil
	end
end
function s.econ(e)
	return true
end
function s.elimit(e,re,tp)
	local loc=re:GetActivateLocation()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) or loc&(LOCATION_MZONE|LOCATION_SZONE|LOCATION_OVERLAY)~=0 then
		loc=LOCATION_ONFIELD
	end
	local code=re:GetHandler():GetCode()
	local p=re:GetHandlerPlayer()+1
	if s.act_table[p][code]
		and s.act_table[p][code][loc] then
		return true
	end
	return false
end