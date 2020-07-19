--不死列车 冥界旅者号
function c50891924.initial_effect(c)
	--Attribute EARTH And MACHINE
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(LOCATION_MZONE+LOCATION_DECK)
	e0:SetValue(ATTRIBUTE_EARTH)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_RACE)
	e3:SetRange(LOCATION_MZONE+LOCATION_DECK)
	e3:SetValue(RACE_MACHINE)
	c:RegisterEffect(e3)
	--search and changelevel
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50891924,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c50891924.eftg)
	e1:SetOperation(c50891924.efop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(50891924,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetCountLimit(1,50891924)
	e4:SetCost(c50891924.spcost)
	e4:SetCondition(c50891924.sscon)
	e4:SetTarget(c50891924.sstg)
	e4:SetOperation(c50891924.ssop)
	c:RegisterEffect(e4)
end
function c50891924.thfilter(c)
	return c:IsCode(4064256) and c:IsAbleToHand()
end
function c50891924.ssfilter(c)
	return not (c:IsRace(RACE_MACHINE) or c:IsRace(RACE_ZOMBIE)) and c:IsFaceup() and c:GetCode()~=50891924 and c:IsType(TYPE_MONSTER)
end
function c50891924.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c50891924.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c50891924.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=e:GetHandler()
	if chk==0 then return b1 or b2 end
	local off=1
	local ops,opval,g={},{}
	if b1 then
		ops[off]=aux.Stringid(50891924,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(50891924,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	
	end
end
function c50891924.efop(e,tp,eg,ep,ev,re,r,rp)
	local sel,g=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c50891924.thfilter),tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
		end
	else
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(10)
		e2:SetReset(RESET_EVENT+0xff0000)
		e:GetHandler():RegisterEffect(e2)
		Duel.BreakEffect()
		if not e:GetHandler():IsRelateToEffect(e) then return end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c50891924.thfilter),tp,LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(50891924,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c50891924.sscon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c50891924.ssfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c50891924.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetTargetCard(e:GetHandler())
end
function c50891924.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
