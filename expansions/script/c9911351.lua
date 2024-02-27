--雪狱之罪人 负重
function c9911351.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911351)
	e1:SetCondition(c9911351.spcon)
	e1:SetCost(c9911351.spcost)
	e1:SetTarget(c9911351.sptg)
	e1:SetOperation(c9911351.spop)
	c:RegisterEffect(e1)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911351,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9911352)
	e1:SetCondition(c9911351.setcon)
	e1:SetTarget(c9911351.settg)
	e1:SetOperation(c9911351.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c9911351.spcon(e,tp,eg,ep,ev,re,r,rp)
	local b1=re:GetActivateLocation()==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER)
	local b2=re:GetActivateLocation()==LOCATION_SZONE and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
	return b1 or b2
end
function c9911351.thfilter(c)
	return c:IsAbleToHand() and (c:IsOnField() or (c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0xc956)))
end
function c9911351.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911351.thfilter,rp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c9911351.repop)
end
function c9911351.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9911351.thfilter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c9911351.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND,0,1,e:GetHandler(),0xc956) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911351.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911351,1))
		local tc=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND,0,1,1,nil,0xc956):GetFirst()
		if tc then
			Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
			tc:RegisterFlagEffect(9911351,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			Duel.ShuffleHand(tp)
		end
	end
end
function c9911351.confilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c9911351.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9911351.confilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function c9911351.setfilter(c)
	return c:IsSetCard(0xc956) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c9911351.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911351.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function c9911351.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9911351.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
		local og=Duel.GetOperatedGroup()
		local tg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
		if og:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(9911351,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.BreakEffect()
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
