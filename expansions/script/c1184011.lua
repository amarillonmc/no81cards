--饮食艺术·小牛乳
function c1184011.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1184011,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1184011)
	e1:SetCost(c1184011.cost1)
	e1:SetTarget(c1184011.tg1)
	e1:SetOperation(c1184011.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1184011,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c1184011.op2)
	c:RegisterEffect(e2)
--
end
--
function c1184011.tfilter1_1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3e12)
		and not c:IsForbidden()
end
function c1184011.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0
		and Duel.IsExistingMatchingCard(c1184011.tfilter1_1,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE,0)
	local dg=Duel.GetMatchingGroup(c1184011.tfilter1_1,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local sg=dg:Select(tp,1,math.min(ft,dg:GetCount()),e:GetHandler())
	for tc in aux.Next(sg) do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetCode(EFFECT_CHANGE_TYPE)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1_1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1_1)
	end
end
function c1184011.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1184011.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
--
function c1184011.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetCode(EFFECT_DUAL_SUMMONABLE)
	c:RegisterEffect(e2_1)
	local e2_2=Effect.CreateEffect(c)
	e2_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2_2:SetTargetRange(LOCATION_MZONE,0)
	e2_2:SetTarget(c1184011.tg2_2)
	e2_2:SetLabelObject(e2_1)
	e2_2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2_2,tp)
end
function c1184011.tg2_2(e,c)
	return c:IsSetCard(0x3e12) and c:IsFaceup()
end