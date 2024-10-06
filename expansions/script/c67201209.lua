--狂暴轮回者-『貉』
function c67201209.initial_effect(c)
	--link summon
	local e0=aux.AddLinkProcedure(c,c67201209.matfilter,2,2)
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_ONFIELD,0)
	e0:SetValue(c67201209.matval)
	c:RegisterEffect(e0)  
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c67201209.atkval)
	c:RegisterEffect(e1)  
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c67201209.effcon)
	e3:SetOperation(c67201209.effop)
	c:RegisterEffect(e3)  
end
function c67201209.matfilter(c)
	return c:IsLinkSetCard(0x567b) or (c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP))
end
function c67201209.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true, true
end
--
function c67201209.atkfilter(c)
	return c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP)
end
function c67201209.atkval(e,c)
	return Duel.GetMatchingGroupCount(c67201209.atkfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)*500
end
--
function c67201209.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK and e:GetHandler():GetReasonCard():IsSetCard(0x567b)
end
function c67201209.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end