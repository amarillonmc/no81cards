--阳炎兽 阿穆特
function c22348467.initial_effect(c)
	--antica spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(c22348467.spcon)
	e1:SetTarget(c22348467.sptg)
	e1:SetOperation(c22348467.spop)
	c:RegisterEffect(e1)
	--cannot be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348467,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c22348467.rmcon)
	--e3:SetCost(c22348467.rmcost)
	e3:SetTarget(c22348467.rmtg)
	e3:SetOperation(c22348467.rmop)
	c:RegisterEffect(e3)
end
function c22348467.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c22348467.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c22348467.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsXyzSummonable(nil)
end
function c22348467.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if not g or #g==0 then return end
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 and g:GetFirst():IsSetCard(0x7d) and Duel.IsExistingMatchingCard(c22348467.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22348467,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xg=Duel.SelectMatchingCard(tp,c22348467.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil)
			Duel.XyzSummon(tp,xg:GetFirst(),nil)
		end
	end
end
function c22348467.chkfilter(c,p)
	return c:IsType(TYPE_MONSTER) and c:IsControler(p)
end
function c22348467.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_FIRE) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and eg:IsExists(c22348467.chkfilter,1,nil,1-tp)
end
function c22348467.rmfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:IsCanBeEffectTarget(e)
end
function c22348467.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c22348467.rmfilter,tp,0,LOCATION_GRAVE,nil,e)
	if chkc then return chkc:IsInGroup(g) end
	if chk==0 then return #g>0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local max=math.max(#g,3)
	local ct=e:GetHandler():RemoveOverlayCard(tp,1,max,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c22348467.rmfilter,tp,0,LOCATION_GRAVE,ct,ct,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c22348467.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
