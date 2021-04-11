--咏魂的史导者
function c72411770.initial_effect(c)
		--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72411770,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c72411770.tg)
	e1:SetOperation(c72411770.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c72411770.filter1(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function c72411770.filter2(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToGrave()
end
function c72411770.filter3(c)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
end
function c72411770.filter4(c)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToGrave()
end

function c72411770.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1=Duel.IsExistingMatchingCard(c72411770.filter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c72411770.filter4,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c72411770.filter3,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c72411770.filter2,tp,LOCATION_DECK,0,1,nil)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(72411770,1),aux.Stringid(72411770,2))
	elseif b1 then 
		op=Duel.SelectOption(tp,aux.Stringid(72411770,1))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(72411770,2))+1 
	end
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c72411770.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g4=Duel.SelectMatchingCard(tp,c72411770.filter4,tp,LOCATION_DECK,0,1,1,nil)
		if g4:GetCount()>0 and Duel.SendtoGrave(g4,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g1=Duel.SelectMatchingCard(tp,c72411770.filter1,tp,LOCATION_DECK,0,1,1,nil)
			if g1:GetCount()>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
			end
		end
	elseif op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,c72411770.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 and Duel.SendtoGrave(g2,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g3=Duel.SelectMatchingCard(tp,c72411770.filter3,tp,LOCATION_DECK,0,1,1,nil)
			if g3:GetCount()>0 then
			Duel.SendtoHand(g3,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g3)
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c72411770.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c72411770.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end