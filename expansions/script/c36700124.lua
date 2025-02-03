--arc-你即是我 我即是你
function c36700124.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c36700124.fstg)
	e1:SetOperation(c36700124.fsop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,36700124)
	e2:SetCondition(c36700124.thcon)
	e2:SetTarget(c36700124.thtg)
	e2:SetOperation(c36700124.thop)
	c:RegisterEffect(e2)
	if not c36700124.global_check then
		c36700124.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c36700124.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c36700124.checkfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function c36700124.checkop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if eg:IsExists(c36700124.checkfilter,1,nil,p) then Duel.RegisterFlagEffect(p,36700124,RESET_PHASE+PHASE_END,0,1) end
	end
end
function c36700124.fsfilter1(c,e)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED)) and c:IsType(TYPE_MONSTER)
		and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function c36700124.fsfilter2(c,e,tp,m,chkf)
	if not (c:IsType(TYPE_FUSION) and aux.IsMaterialListSetCard(c,0xc22)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)) then return false end
	aux.FCheckAdditional=c36700124.fscheck
	local res=c:CheckFusionMaterial(m,nil,chkf,true)
	aux.FCheckAdditional=nil
	return res
end
function c36700124.fscheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionSetCard,1,nil,0xc22)
end
function c36700124.fscfilter(c)
	return c:IsLocation(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED) or (c:IsLocation(LOCATION_MZONE) and c:IsFacedown())
end
function c36700124.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp|0x200
		local mg=Duel.GetMatchingGroup(c36700124.fsfilter1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
		return Duel.IsExistingMatchingCard(c36700124.fsfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,chkf) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c36700124.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp|0x200
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c36700124.fsfilter1),tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	local sg=Duel.GetMatchingGroup(c36700124.fsfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,chkf)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		aux.FCheckAdditional=c36700124.fscheck
		local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf,true)
		aux.FCheckAdditional=nil
		local cf=mat:Filter(c36700124.fscfilter,nil)
		if cf:GetCount()>0 then
			Duel.ConfirmCards(1-tp,cf)
		end
		local ng=mat:Filter(Card.IsCode,nil,36700102,36700109)
		aux.PlaceCardsOnDeckBottom(tp,mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		if ng:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(c36700124.efilter)
			e1:SetOwnerPlayer(tp)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
		end
	end
end
function c36700124.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c36700124.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,36700124)>0 and Duel.GetCurrentPhase()==PHASE_END
end
function c36700124.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() or c:IsSSetable() end
end
function c36700124.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1=c:IsAbleToHand()
	local b2=c:IsSSetable()
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(36700124,1)},
		{b2,aux.Stringid(36700124,2)})
	if op==1 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	else
		Duel.SSet(tp,c)
	end
end
