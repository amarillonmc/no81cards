--联协者 天穹·龙苍
function c62501521.initial_effect(c)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62501521,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,62501521)
	e1:SetCondition(c62501521.spcon)
	e1:SetTarget(c62501521.sptg)
	e1:SetOperation(c62501521.spop)
	c:RegisterEffect(e1)
	--select
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62501521,3))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,62501521+1)
	e2:SetTarget(c62501521.sltg)
	e2:SetOperation(c62501521.slop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c62501521.cfilter(c)
	return c:IsSetCard(0xea3) and c:IsFaceup()
end
function c62501521.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c62501521.cfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c62501521.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c62501521.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c62501521.tgfilter(c)
	return c:IsSetCard(0xea3) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c62501521.eqfilter(c,e,tp,chk)
	return c:IsSetCard(0xea3) and c:IsType(TYPE_EQUIP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckEquipTarget(e:GetHandler()) and (chk==0 or aux.NecroValleyFilter()(c))
end
function c62501521.sltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c62501521.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c62501521.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,0)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(62501521,1)},
		{b2,aux.Stringid(62501521,2)})
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
end
function c62501521.slop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c62501521.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		local c=e:GetHandler()
		if c:IsRelateToChain() and c:IsFaceup() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sc=Duel.SelectMatchingCard(tp,c62501521.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,1):GetFirst()
			Duel.Equip(tp,sc,c)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c62501521.splimit)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c62501521.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
