--魔圣骑士 莫德雷德
function c98920382.initial_effect(c)
--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_WARRIOR),1)
	c:EnableReviveLimit()
	--destroy equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920382,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_EQUIP)
	e1:SetCondition(c98920382.con)
	e1:SetCountLimit(1)
	e1:SetTarget(c98920382.destg)
	e1:SetOperation(c98920382.desop)
	c:RegisterEffect(e1)
end
function c98920382.fil(c,ec)
	return c:IsSetCard(0x207a) and not c:IsCode(41359411)
end
function c98920382.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920382.fil,1,nil)
end
function c98920382.filter1(c,ec)
	return c:GetEquipTarget()==ec
end
function c98920382.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c98920382.filter1,1,nil,e:GetHandler()) end
	local g=eg:Filter(c98920382.filter1,nil,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98920382.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c98920382.filter1,nil,e:GetHandler())
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then		
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1) 
	 --negate
		local e10=Effect.CreateEffect(c)
		e10:SetDescription(aux.Stringid(98920382,0))
		e10:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		e10:SetType(EFFECT_TYPE_QUICK_O)
		e10:SetCode(EVENT_CHAINING)
		e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e10:SetRange(LOCATION_MZONE)
		e10:SetCountLimit(1)
		e10:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
		e10:SetCondition(c98920382.discon)
		e10:SetCost(c98920382.discost)
		e10:SetTarget(c98920382.distg)
		e10:SetOperation(c98920382.disop)
		c:RegisterEffect(e10)
	 end
end
function c98920382.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c98920382.disfilter(c)
	return c:IsSetCard(0xa7) and c:IsAbleToGraveAsCost()
end
function c98920382.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920382.disfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920382.disfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98920382.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98920382.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end