--神世界的引导者
local s,id=GetID()

function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon1)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local pz0=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local pz1=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	return (pz0 and s.Grandwalker(pz0)) or (pz1 and s.Grandwalker(pz1))
end

function s.gw_filter(c)
	return c:IsFaceup() and s.Grandwalker(c) and c:IsType(TYPE_PENDULUM)
end

function s.listed_spfilter(c, e, tp, code)
	if not (c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c, code)) then return false end
	return c:IsCanBeSpecialSummoned(e, 0, tp, true, false)
end

function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local gw_g = Duel.GetMatchingGroup(s.gw_filter, tp, LOCATION_PZONE+LOCATION_EXTRA, 0, nil)
		local valid_gw = Group.CreateGroup()
		for tc in aux.Next(gw_g) do
			local code = tc:GetCode()
			if Duel.IsExistingMatchingCard(s.listed_spfilter, tp, LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA, 0, 1, nil, e, tp, code) then
				valid_gw:AddCard(tc)
			end
		end
		
		if #valid_gw>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local gw_c = valid_gw:Select(tp,1,1,nil):GetFirst()
			if gw_c then
				local code = gw_c:GetCode()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sp_g = Duel.SelectMatchingCard(tp, s.listed_spfilter, tp, LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA, 0, 1, 1, nil, e, tp, code)
				if #sp_g>0 then
					Duel.SpecialSummon(sp_g,0,tp,tp,true,false,POS_FACEUP)
				end
			end
		end
	end
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsPreviousLocation(LOCATION_DECK) then return false end
	if not c:IsReason(REASON_EFFECT) then return false end
	local rc=c:GetReasonEffect()
	if not rc then return false end
	local rcard=rc:GetHandler()
	return rcard and s.Grandwalker(rcard)
end

function s.listed_thfilter(c, code)
	return c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c, code) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and c:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,c)
		local gw_g = Duel.GetMatchingGroup(s.gw_filter, tp, LOCATION_PZONE+LOCATION_EXTRA, 0, nil)
		local valid_gw = Group.CreateGroup()
		for tc in aux.Next(gw_g) do
			local code = tc:GetCode()
			if Duel.IsExistingMatchingCard(s.listed_thfilter, tp, LOCATION_GRAVE, 0, 1, nil, code) then
				valid_gw:AddCard(tc)
			end
		end
		
		if #valid_gw>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local gw_c = valid_gw:Select(tp,1,1,nil):GetFirst()
			if gw_c then
				local code = gw_c:GetCode()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local th_g = Duel.SelectMatchingCard(tp, s.listed_thfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil, code)
				if #th_g>0 then
					Duel.SendtoHand(th_g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,th_g)
				end
			end
		end
	end
end