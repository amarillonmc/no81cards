--ZEXAL II -重构宇宙-
function c75038082.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75038082+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c75038082.cost)
	e1:SetTarget(c75038082.target)
	e1:SetOperation(c75038082.activate)
	c:RegisterEffect(e1)
	--counter
	Duel.AddCustomActivityCounter(75038082,ACTIVITY_SPSUMMON,c75038082.counterfilter)
end
function c75038082.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_XYZ)
end
function c75038082.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(75038082,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c75038082.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c75038082.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ)
end
function c75038082.spfilter(c,e,tp)
	return c:IsCode(84013237) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c75038082.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand() and (Duel.GetFieldGroupCount(c:GetControler(),LOCATION_DECK,0)>1 or code==48333324 or c:IsLocation(LOCATION_GRAVE))-- and (chk==0 or aux.NecroValleyFilter()(c))
end
function c75038082.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c75038082.thfilter,tp,LOCATION_DECK,0,1,nil,48333324)
	local b2=Duel.IsExistingMatchingCard(c75038082.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,62623659)-- and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(75038082,0)},
		{b2,aux.Stringid(75038082,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
		e:SetProperty(0)
	end
end
function c75038082.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c75038082.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		if not sc or Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		--to hand
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c75038082.thfilter,tp,LOCATION_DECK,0,1,1,nil,48333324):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75038082.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,62623659):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
