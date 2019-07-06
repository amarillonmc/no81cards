--磷光的荒野 ～旅途开始之地～
function c33700902.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c33700902.condition)
	c:RegisterEffect(e1)	
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(c33700902.aclimit)
	c:RegisterEffect(e2)
end
function c33700902.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c33700902.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e) and Duel.GetFieldGroupCount(re:GetHandlerPlayer(),LOCATION_MZONE,0)<=0
end
