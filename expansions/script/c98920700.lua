--白帝 巴德尔
function c98920700.initial_effect(c)
	--summon with s/t
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetTargetRange(LOCATION_SZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(c98920700.gfilter))
	e0:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920700,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,98920700)
	e1:SetTarget(c98920700.sptg)
	e1:SetOperation(c98920700.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c98920700.gfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0xbe)
end
function c98920700.filter(c,e,tp,ft)
	return c:IsAttack(800) and c:IsDefense(1000) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c98920700.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920700.filter,tp,LOCATION_DECK,0,1,nil,e,tp,ft) end
end
function c98920700.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c98920700.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local opt=Duel.SelectOption(tp,aux.Stringid(98920700,0),aux.Stringid(98920700,1))
		if opt==0 then
			Duel.Recover(tp,800,REASON_EFFECT)
		else
			if Duel.GetFlagEffect(tp,22404675)~=0 then return end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(22404675,0))
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetTargetRange(LOCATION_HAND,0)
			e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
			e1:SetValue(0x1)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_EXTRA_SET_COUNT)
			Duel.RegisterEffect(e2,tp)
			Duel.RegisterFlagEffect(tp,22404675,RESET_PHASE+PHASE_END,0,1)
		end
	end
end