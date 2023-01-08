--神造遗物的愤怒
function c72409185.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,72409185)
	e1:SetCondition(c72409185.condition)
	e1:SetTarget(c72409185.target)
	e1:SetOperation(c72409185.activate)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,72409185)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c72409185.target2)
	e2:SetOperation(c72409185.operation)
	c:RegisterEffect(e2)
end 

function c72409185.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6729) and c:IsType(TYPE_EQUIP) and (Card.GetEquipTarget(c)):IsSetCard(0xe729)
end
function c72409185.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c72409185.cfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c72409185.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c72409185.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c72409185.filter(c,e,tp)
	return c:IsSetCard(0xe729) 
		and Duel.IsExistingTarget(c72409185.eqfilter,tp,LOCATION_GRAVE,0,1,nil,tp,c)
end
function c72409185.eqfilter(c,tp,ec)
	return c:IsSetCard(0x6729) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function c72409185.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingTarget(c72409185.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c72409185.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g2=Duel.SelectTarget(tp,c72409185.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp,g1:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,1,0,0)
end
function c72409185.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ec=tg:GetFirst()
	if ec==tc then ec=tg:GetNext() end
	if tc:IsRelateToEffect(e) and ec:IsRelateToEffect(e) and ec:CheckUniqueOnField(tp) and ec:CheckEquipTarget(tc) then
		Duel.Equip(tp,ec,tc)
	end
end