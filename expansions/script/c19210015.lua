--我乃异界的扭曲之翼
function c19210015.initial_effect(c)
	aux.AddCodeList(c,19210000)
	aux.AddSetNameMonsterList(c,0xb56)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c19210015.cost)
	e1:SetTarget(c19210015.target)
	e1:SetOperation(c19210015.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19210015,0))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,19210015)
	e2:SetTarget(c19210015.settg)
	e2:SetOperation(c19210015.setop)
	c:RegisterEffect(e2)
end
function c19210015.rmfilter(c,e,tp)
	if not ((c:GetOriginalType()&TYPE_MONSTER)~=0 and c:IsFaceupEx() and c:IsAbleToRemoveAsCost()) then return false end
	local b1=Duel.IsExistingMatchingCard(c19210015.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetMZoneCount(tp,c)>0
	local b2=Duel.IsExistingTarget(c19210015.tfilter,tp,0,LOCATION_ONFIELD,1,nil)
	return b1 or b2
end
function c19210015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19210015.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c19210015.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c19210015.tfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c19210015.spfilter(c,e,tp)
	return c:IsCode(19210000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19210015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c19210015.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0
	local b2=Duel.IsExistingTarget(c19210015.tfilter,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return e:IsCostChecked() or (b1 or b2) end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(19210015,0)},
		{b2,aux.Stringid(19210015,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	elseif op==2 then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectTarget(tp,c19210015.tfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	end
end
function c19210015.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		if Duel.GetMZoneCount(tp)<=0 then return end
		--local ft=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or Duel.GetMZoneCount(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c19210015.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,1):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		local tc=Duel.GetFirstTarget()
		if not tc:IsRelateToChain() then return end
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c19210015.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c19210015.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(19210015,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
