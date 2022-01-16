--术结天怨魔 兹娜米亚
function c67200412.initial_effect(c)
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcCodeFun(c,67200410,aux.FilterBoolFunction(c67200412.ffilter),1,true,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_ONFIELD,0,Duel.Release,REASON_COST+REASON_MATERIAL) 
	 --Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c67200412.spcon)
	e3:SetTarget(c67200412.sptg)
	e3:SetOperation(c67200412.spop)
	c:RegisterEffect(e3) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200412,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c67200412.descon)
	e2:SetTarget(c67200412.destg)
	e2:SetOperation(c67200412.desop)
	c:RegisterEffect(e2)	
end
function c67200412.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER)
end
--
function c67200412.ccfilter(c)
	return c:IsPreviousLocation(LOCATION_EXTRA)
end
function c67200412.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200412.ccfilter,1,nil,tp)
end
function c67200412.spfilter(c,e,tp)
	return c:IsCode(67200410) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200412.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.IsExistingMatchingCard(c67200412.spfilter,tp,LOCATION_DECKBOT,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECKBOT)
end
function c67200412.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g==0 then return end
	local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
	Duel.MoveSequence(tc,0)
	Duel.ConfirmDecktop(tp,1)
	Duel.MoveSequence(tc,1)
	if tc:GetCode()==67200410 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)  
	end
end
--
function c67200412.cfilter(c,tp)
	return c:IsFaceup() and c:IsCode(67200410) and c:IsSummonPlayer(tp)
end
function c67200412.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200412.cfilter,1,nil,tp)
end
function c67200412.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c67200412.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end


