--罗德岛·辅助干员-梓兰
function c79029157.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--to field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83414006,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c79029157.condition)
	e1:SetTarget(c79029157.target)
	e1:SetOperation(c79029157.operation)
	c:RegisterEffect(e1)	
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c79029157.counterop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c79029157.econ)
	e4:SetValue(c79029157.elimit)
	e4:SetLabel(0)
	c:RegisterEffect(e4) 
end
function c79029157.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c79029157.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c79029157.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then
	end
end
function c79029157.counterop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) then return end
	if ep==tp then
		e:GetHandler():RegisterFlagEffect(c79029157,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	else
		e:GetHandler():RegisterFlagEffect(c79029157,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c79029157.cfilter(c,type)
	return c:IsFaceup() and c:IsType(type)
end
function c79029157.econ(e)
	local ct=0
	for i,type in ipairs({TYPE_FUSION,TYPE_RITUAL,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM,TYPE_LINK}) do
		if Duel.IsExistingMatchingCard(c79029157.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,type) then
			ct=ct+1
		end
	end
	return e:GetHandler():GetFlagEffect(79029157+e:GetLabel())>=ct
end
function c79029157.elimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end