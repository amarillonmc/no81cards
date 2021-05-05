--真武神逐
function c40009382.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(c40009382.cost)
	e1:SetCondition(c40009382.condition)
	e1:SetTarget(c40009382.target)
	e1:SetOperation(c40009382.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c40009382.handcon)
	c:RegisterEffect(e3)
end
function c40009382.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c40009382.rfilter(c,e,tp)
	return c:IsSetCard(0x88) and c:IsRace(RACE_BEASTWARRIOR)
		and Duel.IsExistingTarget(c40009382.spfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetCode(),e,tp) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c40009382.spfilter(c,code,e,tp)
	return c:IsSetCard(0x88) and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009382.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c40009382.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c40009382.spfilter(chkc,e:GetLabel(),e,tp) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c40009382.rfilter,1,nil,e,tp)
	end
	local g=Duel.SelectReleaseGroup(tp,c40009382.rfilter,1,1,nil,e,tp)
	local code=g:GetFirst():GetCode()
	e:SetLabel(code)
	Duel.Release(g,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,c40009382.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,code,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c40009382.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
   end
end
function c40009382.handfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x88) and c:IsType(TYPE_XYZ)
end
function c40009382.handcon(e)
	return Duel.IsExistingMatchingCard(c40009382.handfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
