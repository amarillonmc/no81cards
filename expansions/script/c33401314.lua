--守护精灵之心
function c33401314.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c33401314.condition)
	e1:SetTarget(c33401314.target)
	e1:SetOperation(c33401314.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c33401314.condition2)
	e2:SetTarget(c33401314.target2)
	e2:SetOperation(c33401314.activate2)
	c:RegisterEffect(e2)
end
function c33401314.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x341)
end
function c33401314.condition(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c33401314.filter,1,nil,tp)
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c33401314.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,0)
end
function c33401314.spfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsLevelAbove(8) and c:IsSetCard(0xad)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial()
end
function c33401314.activate(e,tp,eg,ep,ev,re,r,rp)   
if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	 if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c33401314.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) then
	  if Duel.SelectYesNo(tp,aux.Stringid(33401314,0)) then
	  local tc=Duel.SelectMatchingCard(tp,c33401314.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	  end
	 end   
end
function c33401314.filter2(c,e,tp)
	return  c:IsSetCard(0xc342) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c33401314.condition2(e,tp,eg,ep,ev,re,r,rp)
   local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d and d:IsControler(tp) and d:IsFaceup() and d:IsSetCard(0x341)
end
function c33401314.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=Duel.GetAttacker()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,0)
end
function c33401314.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
   if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c33401314.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) then
	  if Duel.SelectYesNo(tp,aux.Stringid(33401314,0)) then
	  local tc=Duel.SelectMatchingCard(tp,c33401314.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	  end
	 end   
end
