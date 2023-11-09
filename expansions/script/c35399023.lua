--离子炮龙-光型
function c35399023.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
--
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1_1:SetRange(LOCATION_MZONE)
	e1_1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1_1:SetValue(c35399023.efilter1)
	c:RegisterEffect(e1_1)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1_2:SetRange(LOCATION_MZONE)
	e1_2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1_2:SetValue(1)
	c:RegisterEffect(e1_2)
	local e1_3=e1_2:Clone()
	e1_3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e1_3)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35399023,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,35399023)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c35399023.con2)
	e2:SetTarget(c35399023.tg2)
	e2:SetOperation(c35399023.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35399023,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,35399024)
	e3:SetCondition(c35399023.con3)
	e3:SetTarget(c35399023.tg3)
	e3:SetOperation(c35399023.op3)
	c:RegisterEffect(e3)
--
end
--
function c35399023.efilter1(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
--
function c35399023.con2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
		and Duel.IsChainNegatable(ev)
end
function c35399023.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c35399023.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(35399023,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
--
function c35399023.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)
		and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c35399023.tfilter3(c)
	return c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function c35399023.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35399023.tfilter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c35399023.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c35399023.tfilter3),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end