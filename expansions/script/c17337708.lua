--合辛的最优骑士
function c17337708.initial_effect(c)
	aux.AddCodeList(c,17337400)
	--material redirect-hoshin
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_HAND)
	e0:SetCondition(c17337708.redcon)
	c:RegisterEffect(e0)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17337708,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,17337708)
	e1:SetCondition(c17337708.spcon)
	e1:SetTarget(c17337708.sptg)
	e1:SetOperation(c17337708.spop)
	c:RegisterEffect(e1)
	--attr
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,17337708+1)
	e2:SetCost(c17337708.attrcost)
	--e2:SetTarget(c17337708.attrtg)
	e2:SetOperation(c17337708.attrop)
	c:RegisterEffect(e2)
end
function c17337708.redcon(e)
	local c=e:GetHandler()
	return c:IsOnField() and c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_SYNCHRO)
end
function c17337708.chkfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0x3f51)
end
function c17337708.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c17337708.chkfilter,1,nil,tp)
end
function c17337708.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c17337708.setfilter(c,tp)
	return c:IsSetCard(0x3f51) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c17337708.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) and Duel.GetSZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c17337708.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(17337708,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c17337708.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c17337708.costfilter(c)
	return (c:IsSetCard(0x3f51) or c:IsCode(17337400) and c:IsType(TYPE_MONSTER)) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function c17337708.pfilter(c,ec)
	return c:IsType(TYPE_MONSTER) and c:IsNonAttribute(ec:GetAttribute()) and not c:IsPublic()
end
function c17337708.attrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c17337708.costfilter,tp,LOCATION_ONFIELD,0,1,c) and Duel.IsExistingMatchingCard(c17337708.pfilter,tp,LOCATION_HAND,0,1,nil,c) end
	--to hand
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,c17337708.costfilter,tp,LOCATION_ONFIELD,0,1,1,c):GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_COST)
	--confirm
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c17337708.pfilter,tp,LOCATION_HAND,0,1,1,nil,c)
	e:SetLabel(g:GetFirst():GetAttribute())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c17337708.disfilter(c,ec)
	return aux.NegateMonsterFilter() and c:IsAttribute(ec:GetAttribute())
end
function c17337708.attrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_ATTRIBUTE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		if not Duel.IsExistingMatchingCard(c17337708.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c) or not Duel.SelectYesNo(tp,aux.Stringid(17337708,3)) then return end
		--
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local tc=Duel.SelectMatchingCard(tp,c17337708.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
