--极翼灵兽 Galar闪电鸟
function c45745914.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x881),9,2)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45745914,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,45745914)
	e1:SetCondition(c45745914.descon)
	e1:SetTarget(c45745914.destg)
	e1:SetOperation(c45745914.desop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45745914,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,45745984)
	e2:SetCost(c45745914.cost)
	e2:SetTarget(c45745914.target)
	e2:SetOperation(c45745914.operation)
	c:RegisterEffect(e2)
end
--Summon
function c45745914.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c45745914.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,45745914)>0 and Duel.GetFlagEffect(tp,45745984)==0 end
	Duel.RegisterFlagEffect(tp,45745984,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c45745914.check(c)
	return c and c:IsType(TYPE_SYNCHRO)
end
function c45745914.checkop(e,tp,eg,ep,ev,re,r,rp)
	if c45745914.check(Duel.GetAttacker()) or c45745914.check(Duel.GetAttackTarget()) then
		Duel.RegisterFlagEffect(tp,45745914,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1-tp,45745914,RESET_PHASE+PHASE_END,0,1)
	end
end
--e1
function c45745914.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c45745914.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c45745914.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--e2
function c45745914.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c45745914.refilter(c)
	return  c:IsAbleToRemove()
end
function c45745914.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c45745914.refilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c45745914.refilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c45745914.refilter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c45745914.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
end
end