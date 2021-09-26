--幻星龙 光源
function c35399005.initial_effect(c)
--
	Duel.EnableGlobalFlag(GLOBALFLAG_SPSUMMON_COUNT)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c35399005.MatFilter,3,3)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c35399005.val0)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c35399005.val1)
	c:RegisterEffect(e1)
--
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetCode(59822133)
	e2_1:SetRange(LOCATION_MZONE)
	e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_1:SetTargetRange(1,1)
	c:RegisterEffect(e2_1)
	local e2_2=Effect.CreateEffect(c)
	e2_2:SetType(EFFECT_TYPE_FIELD)
	e2_2:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e2_2:SetRange(LOCATION_MZONE)
	e2_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_2:SetTargetRange(1,1)
	e2_2:SetValue(1)
	c:RegisterEffect(e2_2)
	local e2_3=Effect.CreateEffect(c)
	e2_3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2_3:SetCode(EVENT_CHAINING)
	e2_3:SetRange(LOCATION_MZONE)
	e2_3:SetOperation(c35399005.op2_3)
	c:RegisterEffect(e2_3)
	local e2_4=Effect.CreateEffect(c)
	e2_4:SetType(EFFECT_TYPE_FIELD)
	e2_4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2_4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_4:SetRange(LOCATION_MZONE)
	e2_4:SetTargetRange(1,0)
	e2_4:SetValue(c35399005.val2_4)
	c:RegisterEffect(e2_4)
	local e2_5=Effect.CreateEffect(c)
	e2_5:SetType(EFFECT_TYPE_FIELD)
	e2_5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2_5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_5:SetRange(LOCATION_MZONE)
	e2_5:SetTargetRange(0,1)
	e2_5:SetValue(c35399005.val2_5)
	c:RegisterEffect(e2_5)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35399005,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,35399005)
	e3:SetTarget(c35399005.tg3)
	e3:SetOperation(c35399005.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(35399005,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,35399006)
	e4:SetCondition(c35399005.con4)
	e4:SetCost(c35399005.cost4)
	e4:SetTarget(c35399005.tg4)
	e4:SetOperation(c35399005.op4)
	c:RegisterEffect(e4)
--
end
--
function c35399005.MatFilter(c)
	return c:GetLevel()>=8 and c:IsLinkType(TYPE_SYNCHRO) and c:IsLinkRace(RACE_DRAGON)
end
--
function c35399005.val0(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or (bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK)
end
--
function c35399005.val1(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c35399005.op2_3(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) then return end
	if rp==tp then
		e:GetHandler():RegisterFlagEffect(35399005,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	else
		e:GetHandler():RegisterFlagEffect(35399006,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c35399005.val2_4(e,te,tp)
	return e:GetHandler():GetFlagEffect(35399005)>0
end
function c35399005.val2_5(e,te,tp)
	return e:GetHandler():GetFlagEffect(35399006)>0
end
--
function c35399005.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2500)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2500)
end
function c35399005.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
--
function c35399005.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c35399005.cfilter4(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c35399005.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35399005.cfilter4,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c35399005.cfilter4,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
end
function c35399005.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c35399005.op4(e,tp,eg,ep,ev,re,r,rp)
	local e4_1=Effect.CreateEffect(e:GetHandler())
	e4_1:SetDescription(aux.Stringid(35399005,2))
	e4_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4_1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4_1:SetCountLimit(1)
	e4_1:SetLabel(Duel.GetTurnCount())
	e4_1:SetCondition(c35399005.con4_1)
	e4_1:SetOperation(c35399005.op4_1)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e4_1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e4_1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e4_1,tp)
end
function c35399005.cfilter4_1(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c35399005.con4_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c35399005.cfilter4_1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
end
function c35399005.op4_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,35399005)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c35399005.cfilter4_1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--