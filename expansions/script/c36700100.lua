--skip-咖啡饮用
function c36700100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,36700100)
	e1:SetTarget(c36700100.target)
	e1:SetOperation(c36700100.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,36700101)
	e2:SetCondition(c36700100.thcon)
	e2:SetTarget(c36700100.thtg)
	e2:SetOperation(c36700100.thop)
	c:RegisterEffect(e2)
	if not c36700100.global_check then
		c36700100.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c36700100.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c36700100.checkfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function c36700100.checkop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if eg:IsExists(c36700100.checkfilter,1,nil,p) then Duel.RegisterFlagEffect(p,36700100,RESET_PHASE+PHASE_END,0,1) end
	end
end
function c36700100.tgfilter(c)
	return c:IsSetCard(0xc22) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c36700100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c36700100.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c36700100.spfilter(c,e,tp,code)
	return c:IsSetCard(0xc22) and not c:IsCode(code) and c:IsFaceupEx() and aux.NecroValleyFilter()(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c36700100.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c36700100.tgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		local b1=tc:IsLevelAbove(1)
		local b2=tc:IsAttackAbove(1) or tc:IsDefenseAbove(1)
		local b3=Duel.IsExistingMatchingCard(c36700100.spfilter,tp,0x32,0,1,nil,e,tp,tc:GetCode()) and Duel.GetMZoneCount(tp)>0
		local b4=true
		local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(36700100,0)},
			{b2,aux.Stringid(36700100,1)},
			{b3,aux.Stringid(36700100,2)},
			{b4,aux.Stringid(36700100,3)})
		if op~=4 then Duel.BreakEffect() end
		if op==1 then
			Duel.Damage(1-tp,tc:GetLevel()*100,REASON_EFFECT)
		elseif op==2 then
			Duel.Recover(tp,math.max(tc:GetAttack(),tc:GetDefense()),REASON_EFFECT)
		elseif op==3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,c36700100.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
			if sc then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c36700100.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,36700100)>0 and Duel.GetCurrentPhase()==PHASE_END
end
function c36700100.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() or c:IsSSetable() end
end
function c36700100.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsAbleToHand() and (not c:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	else
		Duel.SSet(tp,c)
	end
end
