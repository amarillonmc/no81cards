--炯眼银角
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1152)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1190)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCountLimit(1,id+1000)
	e2:SetCondition(aux.NOT(s.qcon))
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e6=e2:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCondition(s.qcon)
	c:RegisterEffect(e6)
end
function s.cfilter(c)
	return c:IsFacedown() or not (c:IsRace(RACE_WYRM) and c:IsAttribute(ATTRIBUTE_FIRE))
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.qcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsPlayerAffectedByEffect(tp,89490011)~=nil and c:IsOriginalSetCard(0xc30) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER)
end
function s.tgfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function s.rlfilter(c)
	return c:IsFaceup() and c:IsReleasable()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fe1=Duel.IsPlayerAffectedByEffect(tp,89490052)
	local b1=fe1 and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local fe2=Duel.IsPlayerAffectedByEffect(tp,89490080)
	local b2=fe2 and Duel.IsExistingMatchingCard(s.rlfilter,tp,0,LOCATION_MZONE,1,nil)
	local b3=c:IsReleasable()
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,{b1,fe1 and fe1:GetDescription() or nil},{b2,fe2 and fe2:GetDescription() or nil},{b3,1150})
	if op==1 then
		Duel.Hint(HINT_CARD,0,89490052)
		fe1:UseCountLimit(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
		e:SetLabel(0)
	elseif op==2 then
		Duel.Hint(HINT_CARD,0,89490080)
		fe2:UseCountLimit(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,s.rlfilter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.Release(g,REASON_COST)
		e:SetLabel(0)
	else
		Duel.Release(c,REASON_COST)
		if c:IsLocation(LOCATION_HAND) then e:SetLabel(1) else e:SetLabel(0) end
	end
end
function s.thfilter(c)
	return c:IsSetCard(0xc30) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thfilter2(c,tc)
	return c:IsAllTypes(TYPE_MONSTER+TYPE_RITUAL) and aux.IsCodeListed(tc,c:GetCode()) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 and sg:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,sg)
		local tc=sg:GetFirst()
		if e:GetLabel()>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(s.aclimit)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
		local g2=Duel.GetMatchingGroup(s.thfilter2,tp,LOCATION_DECK,0,nil,tc)
		if #g2>0 and tc:IsType(TYPE_RITUAL) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg2=g2:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(sg2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg2)
			if e:GetLabel()>0 and sg2:GetFirst():IsLocation(LOCATION_HAND) then
				local e2=e1:Clone()
				e2:SetLabel(sg2:GetFirst():GetCode())
				Duel.RegisterEffect(e2,tp)
			end
		end
	end
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
