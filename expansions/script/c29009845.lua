--方舟骑士-格雷伊
c29009845.named_with_Arknight=1
function c29009845.initial_effect(c)
	--tohand race_thunder
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29009845,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29009845)
	e1:SetOperation(c29009845.thop1)
	c:RegisterEffect(e1)
	--tohand type_ritual arknights monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29009845,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCountLimit(1,29009846)
	e2:SetCost(c29009845.thtg)
	e2:SetOperation(c29009845.thop3)
	c:RegisterEffect(e2)
end
function c29009845.thop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c29009845.thop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c29009845.filter1(c)
	return c:IsRace(RACE_THUNDER) and c:IsAbleToHand()
end
function c29009845.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,29009845)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c29009845.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c29009845.rthfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL) and c:IsRace(RACE_SPELLCASTER)
end
function c29009845.rfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsReleasableByEffect()
end
function c29009845.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c29009845.rfilter,1,nil) and Duel.IsExistingMatchingCard(c29009845.rthfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29009845.thop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c29009845.rthfilter,tp,LOCATION_DECK,0,1,nil) then return end
	local g3=Duel.GetMatchingGroup(c29009845.rthfilter,tp,LOCATION_DECK,0,nil)
	local ct=g3:GetClassCount(Card.GetCode)
	if ct>3 then ct=3 end
	local g=Duel.SelectReleaseGroupEx(tp,c29009845.rfilter,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local rct=Duel.Release(g,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g1=Duel.GetMatchingGroup(c29009845.rthfilter,tp,LOCATION_DECK,0,nil)
			local g2=g1:SelectSubGroup(tp,aux.dncheck,false,rct,rct)
			if g2:GetCount()>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
			if c:IsLocation(LOCATION_HAND) and c:IsDiscardable() then
			Duel.BreakEffect()
			Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)
			end
	end
end



















