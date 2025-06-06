--赛博空间机甲 雪翼
function c9910427.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910427)
	e1:SetCondition(c9910427.spcon)
	e1:SetTarget(c9910427.sptg)
	e1:SetOperation(c9910427.spop)
	c:RegisterEffect(e1)
	--destroy & set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910428)
	e2:SetTarget(c9910427.destg)
	e2:SetOperation(c9910427.desop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9910427.negcon)
	e3:SetOperation(c9910427.negop)
	c:RegisterEffect(e3)
end
function c9910427.spcfilter(c)
	return c:IsFaceupEx() and c:IsCode(9910409)
end
function c9910427.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910427.spcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function c9910427.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9910427.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function c9910427.desfilter(c,tp)
	if c:IsFacedown() then return false end
	return Duel.GetSZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c9910427.setfilter,tp,LOCATION_DECK,0,1,nil,true)
end
function c9910427.setfilter(c,ignore)
	return c:IsSetCard(0x6950) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(ignore)
end
function c9910427.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c9910427.desfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910427.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c9910427.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9910427.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c9910427.setfilter,tp,LOCATION_DECK,0,1,1,nil,false)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
		end
	end
end
function c9910427.cfilter(c,e)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and c:IsDefensePos() and not c:IsImmuneToEffect(e)
end
function c9910427.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910427.cfilter,tp,LOCATION_MZONE,0,1,nil,e)
		and rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,9910427)<1
end
function c9910427.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,9910427)<1 and not Duel.IsChainDisabled(ev)
		and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(9910427,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local tc=Duel.SelectMatchingCard(tp,c9910427.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e):GetFirst()
		if tc and Duel.ChangePosition(tc,POS_FACEUP_ATTACK)>0 then
			Duel.Hint(HINT_CARD,0,9910427)
			Duel.NegateEffect(ev)
		end
		Duel.RegisterFlagEffect(tp,9910427,RESET_PHASE+PHASE_END,0,1)
	end
end
