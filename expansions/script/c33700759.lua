--圣山之楔 天蓝薮猫
local m=33700759
local cm=_G["c"..m]
function cm.initial_effect(c)
	--GY effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.rmcon)
	e1:SetTarget(cm.rmlimit)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x442))
	e2:SetCondition(cm.indcon)
	e2:SetValue(cm.indes)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.filter)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(cm.sumcon)
	e4:SetOperation(cm.sumop)
	c:RegisterEffect(e4)
end
function cm.confilter(c)
	return c:IsCode(m)
end
function cm.rmcon(e,c)
	local g=Duel.GetMatchingGroup(cm.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetCount()>=1
end
function cm.rmlimit(e,c,tp)
	return not c:IsSetCard(0x442)
end
function cm.indcon(e,c)
	local g=Duel.GetMatchingGroup(cm.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetCount()>=2
end
function cm.indes(e,c)
	return c:IsDefenseBelow(e:GetHandler():GetDefense())
end
function cm.con(e,c)
	local g=Duel.GetMatchingGroup(cm.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetCount()>=3
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.filter(e,c)
	return c:IsFaceup() and c:IsSetCard(0x442) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return eg:IsExists(cm.cfilter,1,nil,tp) and g:GetCount()>=3
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.cfilter,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(cm.efilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end