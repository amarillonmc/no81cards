--心象风景 赎罪
function c19209557.initial_effect(c)
	aux.AddCodeList(c,19209525)
	--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(c19209557.actcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,19209557+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c19209557.condition)
	e1:SetTarget(c19209557.target)
	e1:SetOperation(c19209557.activate)
	c:RegisterEffect(e1)
	if not c19209557.global_check then
		c19209557.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c19209557.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c19209557.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re or not re:GetHandler():IsSetCard(0xb50) then return end
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(19209557,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c19209557.actcon(e)
	return e:GetHandler():GetFlagEffect(19209557)>0
end
function c19209557.chkfilter(c)
	return c:IsCode(19209525) and c:IsFaceup()
end
function c19209557.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19209557.chkfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,1,nil)
end
function c19209557.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c19209557.spfilter(c,e,tp)
	return c:IsSetCard(0xb50) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function c19209557.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c19209557.cfilter,tp,0,LOCATION_GRAVE,1,nil) and Duel.IsExistingMatchingCard(c19209557.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c19209557.cfilter,tp,0,LOCATION_GRAVE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,1-tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c19209557.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and Duel.GetMZoneCount(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19209557.spfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
