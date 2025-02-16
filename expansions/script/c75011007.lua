--炼金工房大小姐 克洛蒂娅·巴兰茨
function c75011007.initial_effect(c)
	aux.AddCodeList(c,5318639)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END)
	e1:SetCountLimit(1,75011007)
	e1:SetCondition(c75011007.thcon)
	e1:SetTarget(c75011007.thtg)
	e1:SetOperation(c75011007.thop)
	c:RegisterEffect(e1)
	--summon reg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c75011007.regop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--spsummon-self
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75011007,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,75011008)
	e4:SetCondition(c75011007.spcon)
	e4:SetTarget(c75011007.sptg)
	e4:SetOperation(c75011007.spop)
	c:RegisterEffect(e4)
end
function c75011007.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(75011007)~=0
end
function c75011007.thfilter(c)
	return c:IsSetCard(0x75e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c75011007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75011007.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75011007.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c75011007.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c75011007.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(75011007,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75011007,3))
end
function c75011007.chkfilter(c,tp,rp)
	return c:IsPreviousControler(1-tp) and rp==tp
end
function c75011007.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75011007.chkfilter,1,nil,tp,rp)
end
function c75011007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c75011007.tgfilter(c)
	return c:IsCode(5318639) and c:IsAbleToGrave()
end
function c75011007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c75011007.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
