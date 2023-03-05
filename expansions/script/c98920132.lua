--光道治疗师 伊阿索
function c98920132.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT),1)
	c:EnableReviveLimit()
--deckdes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920132,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c98920132.thcon)
	e1:SetTarget(c98920132.ddtg)
	e1:SetOperation(c98920132.ddop)
	c:RegisterEffect(e1)
--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920132,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98920132)
	e2:SetTarget(c98920132.rectg)
	e2:SetCondition(c98920132.spcon)
	e2:SetOperation(c98920132.spop)
	c:RegisterEffect(e2)
end
function c98920132.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98920132.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c98920132.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetMaterialCount()
	Duel.DiscardDeck(tp,ct,REASON_EFFECT)
end
function c98920132.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsType(TYPE_MONSTER) and c:IsPreviousControler(tp)
end
function c98920132.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920132.cfilter,1,nil,tp)
end
function c98920132.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c98920132.spfilter(c,e,tp)
	return c:IsSetCard(0x38) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920132.spop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	if eg:IsExists(c98920132.cfilter1,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c98920132.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(98920132,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920132.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if eg:IsExists(c98920132.cfilter3,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(98920132,3)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if eg:IsExists(c98920132.cfilter2,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(98920132,4)) then
		Duel.BreakEffect()
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
function c98920132.cfilter1(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c98920132.cfilter2(c)
	return c:IsCode(691925,22201234,24037702,30502181,32233746,35577420,36099620,57348141,60431417,61962135,66194206,83747250,94886282)
end
function c98920132.cfilter3(c)
	return c:IsSetCard(0x38)
end