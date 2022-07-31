--青之记忆
function c189121.initial_effect(c)
	--Activate 
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_ACTIVATE) 
	e0:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e0)
	--avoid damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c189121.damval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e2)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e2) 
	--effect gain 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c189121.eftg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c189121.efilter)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT) 
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c189121.eftg)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
end
function c189121.damval(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then 
		return 0
	end
	return val
end
function c189121.eftg(e,c)
	local x=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) 
	if x==1 then 
	return true 
	else return false end   
end
function c189121.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end





