--饮食艺术·三色猫
function c1184001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1184001,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c1184001.tg1)
	e1:SetOperation(c1184001.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c1184001.tg2)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
--
end
--
function c1184001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and not e:GetHandler():IsForbidden() end
end
--
function c1184001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetCode(EFFECT_CHANGE_TYPE)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1_1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1_1)
end
--
function c1184001.tg2(e,c)
	local seq=c:GetSequence()
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x3e12)
		and seq<5 and math.abs(e:GetHandler():GetSequence()-seq)==1
end
--
