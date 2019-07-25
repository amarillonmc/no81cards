--神谕之环-诹访子
function c9981013.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_AQUA),5,4)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981013,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9981013.condition)
	e1:SetTarget(c9981013.target)
	e1:SetOperation(c9981013.operation)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981013,1))
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,7121)
	e2:SetCondition(c9981013.dircon)
	e2:SetTarget(c9981013.target1)
	e2:SetOperation(c9981013.operation1)
	c:RegisterEffect(e2)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981013,2))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,7122)
	e1:SetCost(c9981013.cost)
	e1:SetCondition(c9981013.condition)
	e1:SetTarget(c9981013.target2)
	e1:SetOperation(c9981013.operation2)
	c:RegisterEffect(e1)
end
function c9981013.condition(e,tp,eg,ep,ev,re,r,rp)
	 return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c9981013.filter(c)
	return c:IsCode(9981009) and c:IsAbleToHand()
end
function c9981013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981013.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c9981013.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9981013.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9981013.filter1(c)
	return c:IsSetCard(0x5bc1)
end
function c9981013.dircon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c9981013.filter1,1,nil)
end
function c9981013.filter(c,tp)
	return not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c9981013.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and c9981013.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c9981013.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9981013.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,e:GetHandler(),tp)
end
function c9981013.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c9981013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9981013.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and e:GetHandler():GetOverlayGroup():IsExists(c9981013.filter1,1,nil)
end
function c9981013.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9981013.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and Duel.Destroy(rc,REASON_EFFECT)~=0 and rc:GetBaseAttack()>=0
		and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e1:SetValue(rc:GetBaseAttack())
		c:RegisterEffect(e1)
	end
end