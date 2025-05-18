--水戏之月神
function c9910090.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9910090)
	e1:SetCost(c9910090.spcost)
	e1:SetTarget(c9910090.sptg)
	e1:SetOperation(c9910090.spop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910090,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,9910091)
	e2:SetTarget(c9910090.atktg)
	e2:SetOperation(c9910090.atkop)
	c:RegisterEffect(e2)
end
function c9910090.cfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsRace(RACE_FAIRY)
end
function c9910090.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9910090.cfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c9910090.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c9910090.tgfilter(c)
	return c:IsSetCard(0x9951) and c:IsAbleToGrave() and not c:IsCode(9910090)
end
function c9910090.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c9910090.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9910090.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and aux.NecroValleyFilter()(c) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if c:IsSummonLocation(LOCATION_GRAVE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			c:RegisterEffect(e1,true)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c9910090.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c9910090.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function c9910090.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910090.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910090.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9910090.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9910090.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910090,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local tg=g:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
			Duel.Destroy(tg,REASON_EFFECT)
		end
	end
end
