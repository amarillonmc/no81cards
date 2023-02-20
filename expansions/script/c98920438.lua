--云与朝的春化精
function c98920438.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920438,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c98920438.discon)
	e1:SetCost(c98920438.discost)
	e1:SetTarget(c98920438.distg)
	e1:SetOperation(c98920438.disop)
	c:RegisterEffect(e1)
--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c98920438.chainop)
	c:RegisterEffect(e3)
end
function c98920438.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c98920438.costfilter(c)
	return ((c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_EARTH)) or c:IsSetCard(0x182)) and c:IsDiscardable()
end
function c98920438.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fe=Duel.IsPlayerAffectedByEffect(tp,14108995)
	local b2=Duel.IsExistingMatchingCard(c98920438.costfilter,tp,LOCATION_HAND,0,1,c)
	if chk==0 then return c:IsDiscardable() and (fe or b2) end
	if fe and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(14108995,0))) then
		Duel.Hint(HINT_CARD,0,14108995)
		fe:UseCountLimit(tp)
		Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,c98920438.costfilter,tp,LOCATION_HAND,0,1,1,c)
		g:AddCard(c)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	end
end
function c98920438.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)		
	end
end
function c98920438.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920438.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	   if Duel.Destroy(eg,REASON_EFFECT)~=0 then
		   local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c98920438.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		   if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			  and Duel.SelectYesNo(tp,aux.Stringid(98920438,0)) then
			  Duel.BreakEffect()
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			  local sc=sg:Select(tp,1,1,nil)
			  Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c98920438.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98920438.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x182) and ep==tp then
		Duel.SetChainLimit(c98920438.chainlm)
	end
end
function c98920438.chainlm(e,rp,tp)
	return tp==rp
end
function c98920438.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsNonAttribute(ATTRIBUTE_EARTH)
end