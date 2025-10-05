--·万魔殿·
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17338180)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(function(e,c) return not c:IsSetCard(0x5f50) end)
	e1:SetValue(function(e,c) return math.floor(c:GetAttack()/2) end)
	c:RegisterEffect(e1)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e6:SetValue(function(e,c) return math.floor(c:GetDefense()/2) end)
	c:RegisterEffect(e6)
	--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetTarget(function(e,c) return not c:IsSetCard(0x5f50) end)
	e7:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e7)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(function(e,c) return c:IsCode(17338180) and c:IsFaceup() end)
	c:RegisterEffect(e2)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTarget(function(e,c) return c:IsCode(17338180) and c:IsFaceup() end)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--effect count
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e9:SetCode(EVENT_CHAINING)
	e9:SetRange(LOCATION_FZONE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetOperation(s.count)
	c:RegisterEffect(e9)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(s.rst)
	c:RegisterEffect(e3)
	--activate limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(s.econ1)
	e4:SetValue(s.elimit)
	c:RegisterEffect(e4)
	local e10=e4:Clone()
	e10:SetTargetRange(0,1)
	e10:SetCondition(s.econ2)
	c:RegisterEffect(e10)
	--
	--attack limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e11:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e11:SetRange(LOCATION_FZONE)
	e11:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e11:SetCondition(s.atkcon)
	e11:SetTarget(s.atktg)
	c:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e12:SetCode(EVENT_ATTACK_ANNOUNCE)
	e12:SetRange(LOCATION_FZONE)
	e12:SetOperation(s.checkop)
	e12:SetLabelObject(e11)
	c:RegisterEffect(e12)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(1,0)
	e5:SetValue(function(e,re,tp)
		if not re then return false end
		local rc=re:GetHandler()
		return not ((rc:IsSetCard(0x5f50) and rc:IsType(TYPE_MONSTER)) or rc:IsSetCard(0x3f50))
	end)
	c:RegisterEffect(e5)
end
function s.count(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	if ep==tp then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	else
		e:GetHandler():RegisterFlagEffect(id+o,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function s.rst(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	if ep==tp then
		e:GetHandler():ResetFlagEffect(id)
	else
		e:GetHandler():ResetFlagEffect(id+o)
	end
end
function s.econ1(e)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.econ2(e)
	return e:GetHandler():GetFlagEffect(id+o)~=0
end
function s.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.atkcon(e)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(id)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end