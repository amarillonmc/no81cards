--幻影旅团 拍卖会
function c45746037.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,45746037+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c45746037.target)
	e1:SetOperation(c45746037.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(45746037,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,45746137)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(c45746037.cost)
	e2:SetTarget(c45746037.thtg)
	e2:SetOperation(c45746037.thop)
	c:RegisterEffect(e2)

end
function c45746037.spfilter1(c,e,tp)
	return c:IsSetCard(0x5880) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function c45746037.fselect1(g,tp)
	return Duel.IsExistingMatchingCard(c45746037.synfilter,tp,LOCATION_EXTRA,0,1,nil,g) and aux.dncheck(g)
end
function c45746037.synfilter(c,g)
	return c:IsSetCard(0x5880) and c:IsSynchroSummonable(nil,g,g:GetCount()-1,g:GetCount()-1)
end
function c45746037.fselect2(g,tp)
	return Duel.IsExistingMatchingCard(c45746037.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g) and aux.dncheck(g)
end
function c45746037.xyzfilter(c,g)
	return c:IsSetCard(0x5880) and c:IsXyzSummonable(g,g:GetCount(),g:GetCount())
end
function c45746037.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),3)
	local g=Duel.GetMatchingGroup(c45746037.spfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	local b1=g:CheckSubGroup(c45746037.fselect1,1,ft,tp)
	local b2=g:CheckSubGroup(c45746037.fselect2,1,ft,tp)
	if chk==0 then return ft>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) and (b1 or b2) end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(45746037,0),aux.Stringid(45746037,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(45746037,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(45746037,1))+1
	end
	e:SetLabel(op)
	local sg=nil
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=g:SelectSubGroup(tp,c45746037.fselect1,false,1,ft,tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=g:SelectSubGroup(tp,c45746037.fselect2,false,1,ft,tp)
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function c45746037.spfilter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c45746037.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c45746037.spfilter2,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	local og=Duel.GetOperatedGroup()
	Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
	if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<g:GetCount() then return end
	if op==0 then
		local tg=Duel.GetMatchingGroup(c45746037.synfilter,tp,LOCATION_EXTRA,0,nil,og)
		if og:GetCount()==g:GetCount() and tg:GetCount()>0 then
			local tc=og:GetFirst()
			while tc do
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				e3:SetValue(LOCATION_DECKBOT)
				tc:RegisterEffect(e3)
				tc=og:GetNext()
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=tg:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,rg:GetFirst(),nil,og,og:GetCount()-1,og:GetCount()-1)
		end
	else
		local tg=Duel.GetMatchingGroup(c45746037.xyzfilter,tp,LOCATION_EXTRA,0,nil,og)
		if og:GetCount()==g:GetCount() and tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=tg:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,rg:GetFirst(),og,og:GetCount(),og:GetCount())
		end
	end
end
--e2
function c45746037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():IsFaceup() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_RETURN)
end
function c45746037.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x5880) and c:IsFaceup()
end
function c45746037.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c45746037.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c45746037.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c45746037.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
