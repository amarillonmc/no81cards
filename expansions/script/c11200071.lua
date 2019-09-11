--『Ancient Duper』
function c11200071.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,11200071+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11200071.tg1)
	e1:SetOperation(c11200071.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11200071,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,11200171)
	e3:SetCost(c11200071.cost3)
	e3:SetTarget(c11200071.tg3)
	e3:SetOperation(c11200071.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e4)
--
end
--
c11200071.xig_ihs_0x133=1
--
function c11200071.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if not eg then return false end
	local tc=eg:GetFirst()
	if chkc then return chkc==tc end
	if chk==0 then return ep~=tp and tc:IsFaceup() and tc:GetAttack()>=1000 and tc:IsOnField() and tc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
--
function c11200071.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetDescription(aux.Stringid(11200071,0))
		e1_1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e1_1:SetValue(1)
		e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1_1)
		local e1_2=Effect.CreateEffect(c)
		e1_2:SetType(EFFECT_TYPE_SINGLE)
		e1_2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e1_2:SetValue(1)
		e1_2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1_2)
		local e1_3=Effect.CreateEffect(c)
		e1_3:SetType(EFFECT_TYPE_SINGLE)
		e1_3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e1_3:SetValue(1)
		e1_3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1_3)
		local e1_4=Effect.CreateEffect(c)
		e1_4:SetType(EFFECT_TYPE_SINGLE)
		e1_4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1_4:SetValue(1)
		e1_4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1_4)
		local e1_5=Effect.CreateEffect(c)
		e1_5:SetType(EFFECT_TYPE_SINGLE)
		e1_5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_5:SetCode(EFFECT_DISABLE)
		e1_5:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1_5)
	end
end
--
function c11200071.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
--
function c11200071.tfilter3(c,tp)
	return c.xig_ihs_0x133 and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or c:IsType(TYPE_FIELD)) and not c:IsCode(11200071)
end
function c11200071.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200071.tfilter3,tp,LOCATION_GRAVE,0,1,nil,tp) end
end
--
function c11200071.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c11200071.tfilter3,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SSet(tp,g)
	Duel.ConfirmCards(1-tp,g)
end
--
