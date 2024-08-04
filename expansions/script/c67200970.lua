--众星修正者 障月
function c67200970.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200970,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,67200970)
	e1:SetCondition(c67200970.spcon)
	e1:SetTarget(c67200970.sptg)
	e1:SetOperation(c67200970.spop)
	c:RegisterEffect(e1)	 
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200970,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,67200970)
	e2:SetCondition(c67200970.negcon)
	e2:SetTarget(c67200970.negtg)
	e2:SetOperation(c67200970.negop)
	c:RegisterEffect(e2)
end
--
function c67200970.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsSetCard(0x67a) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c67200970.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c67200970.cfilter,1,c,tp) and not eg:IsContains(c)
end
function c67200970.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67200970.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c67200970.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c67200970.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function c67200970.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		Duel.SendtoExtraP(e:GetHandler(),nil,REASON_EFFECT)
	end
end
