--幻想鸣奏 荒芜地界
function c79029835.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c79029835.lpcon)
	e1:SetCode(EFFECT_LINK_SPELL_KOISHI)
	c:RegisterEffect(e1)  
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c79029835.lpcon)
	e2:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
	e2:SetValue(LINK_MARKER_TOP+LINK_MARKER_TOP_LEFT+LINK_MARKER_TOP_RIGHT)
	c:RegisterEffect(e2)  
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(c79029835.immcon)
	e3:SetTarget(c79029835.etarget)
	e3:SetValue(c79029835.efilter)
	c:RegisterEffect(e3)
	--disable field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_DISABLE_FIELD)
	e4:SetCondition(c79029835.discon)
	e4:SetValue(c79029835.disval)
	c:RegisterEffect(e4)
end
function c79029835.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function c79029835.immcon(e)
	return e:GetHandler():GetControler()==e:GetHandler():GetOwner()
end
function c79029835.etarget(e,c)
	return c:IsSetCard(0xa991) and e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c79029835.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c79029835.discon(e)
	return e:GetHandler():GetControler()~=e:GetHandler():GetOwner()
end
function c79029835.disval(e)
	local c=e:GetHandler() 
	local tp=c:GetControler()
	local seq=c:GetSequence()
	return aux.SequenceToGlobal(tp,LOCATION_MZONE,seq)+aux.SequenceToGlobal(tp,LOCATION_MZONE,seq-1)+aux.SequenceToGlobal(tp,LOCATION_MZONE,seq+1) 
end

