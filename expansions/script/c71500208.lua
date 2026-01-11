--命运预见『太阳』
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x781)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Double Recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(id)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--Add Counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.ctcon)
	e3:SetOperation(s.ctop)
	c:RegisterEffect(e3)
	--0 ATK/DEF
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCondition(s.atkcon)
	e4:SetValue(0)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e5)
	--Skip Draw
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_SKIP_DP)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(1,1)
	e6:SetCondition(s.skipcon)
	c:RegisterEffect(e6)
	--Bad Reaction
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EFFECT_REVERSE_RECOVER)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(1,1)
	e7:SetCondition(s.badcon)
	c:RegisterEffect(e7)
	if not s.global_check then
		s.global_check=true
		_Recover=Duel.Recover
		function Duel.Recover(p,val,r,step)
			if not step then step=false end
			if Duel.GetFlagEffect(p,id)>0 and Duel.GetFlagEffect(p,EFFECT_REVERSE_RECOVER)==0 then val=val*2 end
			_Recover(p,val,r,step)
		end
	end
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>0 and (not re or re:GetHandler()~=e:GetHandler())
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>0
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x781,1)
end
function s.atkcon(e)
	return e:GetHandler():GetCounter(0x781)>=3
end
function s.skipcon(e)
	return e:GetHandler():GetCounter(0x781)>=5
end
function s.badcon(e)
	return e:GetHandler():GetCounter(0x781)>=7
end
