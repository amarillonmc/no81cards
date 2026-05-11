--禁止复读
local s,id=GetID()
function s.initial_effect(c)
	--activation limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--global check
	if not s.global_check then
		s.global_check=true
		s.act_table_0={}
		s.act_table_1={}
		s.chain_codes={}
		--
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
		--
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(s.negop)
		Duel.RegisterEffect(ge2,0)
		--
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_TURN_END)
		ge3:SetOperation(s.clearop)
		Duel.RegisterEffect(ge3,0)
	end
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local codes={rc:GetCode()}
	s.chain_codes[ev]=codes
	local tab=(ep==0) and s.act_table_0 or s.act_table_1
	local raised=false
	for _,code in ipairs(codes) do
		tab[code]=(tab[code] or 0)+1
		if tab[code]==2 then 
			raised=true 
		end
	end
	if raised then
		Duel.RaiseEvent(rc,EVENT_CUSTOM+id,re,r,rp,ep,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local codes=s.chain_codes[ev]
	if not codes then return end
	local tab=(ep==0) and s.act_table_0 or s.act_table_1
	for _,code in ipairs(codes) do
		if tab[code] and tab[code]>0 then
			tab[code]=tab[code]-1
		end
	end
end
function s.clearop(e,tp,eg,ep,ev,re,r,rp)
	s.act_table_0={}
	s.act_table_1={}
	s.chain_codes={}
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	local codes={rc:GetCode()}
	for _,code in ipairs(codes) do
		local count0=s.act_table_0[code] or 0
		local count1=s.act_table_1[code] or 0
		if (count0+count1)>=1 then
			return true
		end
	end
	return false
end