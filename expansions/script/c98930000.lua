--超古代的战士
function c98930000.initial_effect(c)
	--special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98930000,4))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,98930000)
	e3:SetCondition(c98930000.spcont)
	e3:SetTarget(c98930000.sptg)
	e3:SetOperation(c98930000.spop)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98930000,5))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,98990000)
	e4:SetTarget(c98930000.tgtg)
	e4:SetOperation(c98930000.tgop)
	c:RegisterEffect(e4)
end
function c98930000.cfilter(c,tp)
	return c:IsSetCard(0xad0) and c:IsControler(tp) and not c:IsPreviousLocation(LOCATION_GRAVE)
end
function c98930000.spcont(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98930000.cfilter,1,nil,tp)
end
function c98930000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,98930000)==0 end
	Duel.RegisterFlagEffect(tp,98930000,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c98930000.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0xad0)
end
function c98930000.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c98930000.thfilter,tp,LOCATION_DECK,0,nil)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98930000,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,EASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2,true)
end
function c98930000.tgfilter(c)
	return c:IsSetCard(0xad0) and c:IsAbleToGrave()
end
function c98930000.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98930000.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98930000.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98930000.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

