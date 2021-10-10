--骇骨龙 阴骇幽灵
function c35399012.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsType,TYPE_TUNER),aux.TRUE,2,2,true)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c35399012.val0)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35399012,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,35399012)
	e1:SetTarget(c35399012.tg1)
	e1:SetOperation(c35399012.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35399012,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,35399013)
	e2:SetCost(c35399012.cost2)
	e2:SetTarget(c35399012.tg2)
	e2:SetOperation(c35399012.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35399012,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,35399014)
	e3:SetCondition(c35399012.con3)
	e3:SetTarget(c35399012.tg3)
	e3:SetOperation(c35399012.op3)
	c:RegisterEffect(e3)
--
end
--
function c35399012.val0(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or (bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION)
end
--
function c35399012.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,3000)
end
function c35399012.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,3000,REASON_EFFECT)
	Duel.Recover(1-tp,3000,REASON_EFFECT)
end
--
function c35399012.cfilter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c35399012.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35399012.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c35399012.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c35399012.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c35399012.op2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local sg=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2_1:SetCode(EFFECT_DISABLE)
		e2_1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e2_1)
		local e2_2=Effect.CreateEffect(c)
		e2_2:SetType(EFFECT_TYPE_SINGLE)
		e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2_2:SetCode(EFFECT_DISABLE_EFFECT)
		e2_2:SetValue(RESET_TURN_SET)
		e2_2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e2_2)
	end
end
--
function c35399012.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c35399012.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD)
end
function c35399012.op3(e,tp,eg,ep,ev,re,r,rp)
	local e3_1=Effect.CreateEffect(e:GetHandler())
	e3_1:SetDescription(aux.Stringid(35399012,3))
	e3_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3_1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3_1:SetCountLimit(1)
	e3_1:SetLabel(Duel.GetTurnCount())
	e3_1:SetCondition(c35399012.con3_1)
	e3_1:SetOperation(c35399012.op3_1)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e3_1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e3_1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e3_1,tp)
end
function c35399012.con3_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c35399012.op3_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,35399012)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end