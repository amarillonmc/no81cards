--真樱修正者 觅影
function c67200946.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pzone spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(67200946,0))
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_TOEXTRA)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,67200947)
	e0:SetCondition(c67200946.pspcon)
	e0:SetTarget(c67200946.psptg)
	e0:SetOperation(c67200946.pspop)
	c:RegisterEffect(e0)
	--spsummon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200946,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,67200946)
	e1:SetCost(c67200946.setcost)
	e1:SetTarget(c67200946.settg)
	e1:SetOperation(c67200946.setop)
	c:RegisterEffect(e1)
end
--
function c67200946.pspcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x67a) and rc:IsControler(tp)
end
function c67200946.thfilter(c)
	return c:IsSetCard(0x567a) and c:IsType(TYPE_PENDULUM)
end
function c67200946.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() and Duel.IsExistingMatchingCard(c67200946.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c67200946.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200946,3))
		local g=Duel.SelectMatchingCard(tp,c67200946.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoExtraP(g,nil,REASON_EFFECT)
		end
	end
end
--
function c67200946.costfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x567a)
end
function c67200946.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b2=Duel.IsExistingMatchingCard(c67200946.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c)
	if chk==0 then return b2 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200946,3))
	local g=Duel.SelectMatchingCard(tp,c67200946.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c)
	Duel.SendtoExtraP(g,nil,REASON_COST)
end
function c67200946.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67200946.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end