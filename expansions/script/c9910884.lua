--基因重塑
function c9910884.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910884,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9910884)
	e2:SetCost(c9910884.racost)
	e2:SetTarget(c9910884.ratg)
	e2:SetOperation(c9910884.raop)
	c:RegisterEffect(e2)
	--to hand/spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910884,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,9910884)
	e3:SetTarget(c9910884.thtg)
	e3:SetOperation(c9910884.thop)
	c:RegisterEffect(e3)
end
function c9910884.racost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c9910884.rafilter(c,race)
	return c:IsFaceup() and c:GetRace()~=race
end
function c9910884.costfilter(c)
	return aux.IsCodeListed(c,9910871) and c:GetRace()>0 and c:IsAbleToGraveAsCost()
		and Duel.IsExistingTarget(c9910884.rafilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetRace())
end
function c9910884.ratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c9910884.costfilter,tp,LOCATION_DECK,0,1,nil,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910884.costfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetRace())
end
function c9910884.raop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c9910884.cfilter(c,tp)
	return c:GetFlagEffect(9910871)>0 and c:GetReasonPlayer()==1-tp and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c9910884.thfilter(c,e,tp,fusc)
	local res=c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
		and c:GetReason()&(REASON_FUSION+REASON_MATERIAL)==(REASON_FUSION+REASON_MATERIAL)
		and c:GetReasonCard()==fusc
	if not res then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c9910884.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c9910884.cfilter,nil,tp)
	local mg=Group.CreateGroup()
	for sc in aux.Next(g) do
		mg:Merge(sc:GetMaterial():Filter(c9910884.thfilter,nil,e,tp,sc))
	end
	if chk==0 then return mg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c9910884.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c9910884.cfilter,nil,tp)
	local mg=Group.CreateGroup()
	for sc in aux.Next(g) do
		mg:Merge(sc:GetMaterial():Filter(aux.NecroValleyFilter(c9910884.thfilter),nil,e,tp,sc))
	end
	if mg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=mg:Select(tp,1,1,nil):GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
