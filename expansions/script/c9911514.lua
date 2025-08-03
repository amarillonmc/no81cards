--觅迹人法术 蛊毒之刺
function c9911514.initial_effect(c)
	--spsummon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911514+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9911514.sprcon)
	e1:SetOperation(c9911514.sprop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CUSTOM+9911514)
	e2:SetOperation(c9911514.regop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CUSTOM+9911515)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9911514,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,9911515)
	e4:SetCondition(c9911514.thcon1)
	e4:SetCost(c9911514.thcost)
	e4:SetTarget(c9911514.thtg1)
	e4:SetOperation(c9911514.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetDescription(aux.Stringid(9911514,1))
	e5:SetCode(EVENT_BECOME_TARGET)
	e5:SetCondition(c9911514.thcon2)
	e5:SetTarget(c9911514.thtg2)
	c:RegisterEffect(e5)
end
function c9911514.costfilter(c)
	return c:IsSetCard(0x5952) and c:IsAbleToGraveAsCost()
end
function c9911514.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetDecktopGroup(1-tp,1)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911514.costfilter,tp,LOCATION_DECK,0,1,nil) and g:GetFirst():IsAbleToGraveAsCost()
end
function c9911514.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c9911514.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	local g2=Duel.GetDecktopGroup(1-tp,1)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_SPSUMMON)
	local og=Duel.GetOperatedGroup():Filter(Card.IsControler,nil,1-tp)
	local tc1=og:GetFirst()
	if tc1 then Duel.RaiseSingleEvent(c,EVENT_CUSTOM+9911514,e,0,0,tp,tc1:GetOriginalCodeRule()) end
	local tc2=og:GetNext()
	if tc2 then Duel.RaiseSingleEvent(c,EVENT_CUSTOM+9911515,e,0,0,tp,tc2:GetOriginalCodeRule()) end
end
function c9911514.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c9911514.aclimit)
	e1:SetLabel(ev)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9911514.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function c9911514.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local b1=Duel.IsPlayerAffectedByEffect(tp,9911506) and rc:IsControler(1-tp)
	local b2=Duel.IsPlayerAffectedByEffect(tp,9911511) and re:IsActiveType(TYPE_MONSTER) and bit.band(loc,LOCATION_HAND)~=0
	return b2 or ((b1 or rc:IsSetCard(0x5952)) and bit.band(loc,LOCATION_ONFIELD)~=0)
end
function c9911514.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9911514.deckfilter(c,tp)
	return c:IsSetCard(0x5952) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c9911514.thfilter,tp,LOCATION_DECK,0,1,c)
end
function c9911514.thfilter(c)
	return c:IsSetCard(0x5952) and c:IsAbleToHand()
end
function c9911514.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local fe=Duel.IsPlayerAffectedByEffect(tp,9911520)
	local b0=fe and Duel.IsExistingMatchingCard(c9911514.deckfilter,tp,LOCATION_DECK,0,1,nil,tp)
	local g=Duel.GetMatchingGroup(c9911514.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return c:IsAbleToRemoveAsCost() and rc:IsRelateToEffect(re) and #g>0 and (rc:IsReleasable() or b0)
		else
			return #g>0
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Remove(c,POS_FACEUP,REASON_COST)
		if b0 and Duel.SelectYesNo(tp,aux.Stringid(9911520,1)) then
			Duel.Hint(HINT_CARD,0,9911520)
			fe:UseCountLimit(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local dg=Duel.SelectMatchingCard(tp,c9911514.deckfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
			Duel.Release(dg,REASON_COST)
			Duel.SendtoGrave(dg,REASON_RELEASE+REASON_COST)
		else
			Duel.Release(rc,REASON_COST)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911514.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911514.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9911514.tgcfilter1(c,check,re)
	if not c:IsOnField() or not c:IsRelateToEffect(re) then return false end
	local b0=c:IsFaceup() and c:IsSetCard(0x5952)
	return (b0 and c:IsControler(tp)) or (not b0 and check)
end
function c9911514.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsPlayerAffectedByEffect(tp,9911509)
	return eg:FilterCount(c9911514.tgcfilter1,nil,check,re)>0
end
function c9911514.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local check=Duel.IsPlayerAffectedByEffect(tp,9911509)
	local sg=eg:Filter(c9911514.tgcfilter1,nil,check,re)
	local fe=Duel.IsPlayerAffectedByEffect(tp,9911520)
	local b0=fe and Duel.IsExistingMatchingCard(c9911514.deckfilter,tp,LOCATION_DECK,0,1,nil,tp)
	local g=Duel.GetMatchingGroup(c9911514.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return c:IsAbleToRemoveAsCost() and #g>0 and (sg:FilterCount(Card.IsReleasable,nil,re)>0 or b0)
		else
			return #g>0
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Remove(c,POS_FACEUP,REASON_COST)
		if b0 and Duel.SelectYesNo(tp,aux.Stringid(9911520,1)) then
			Duel.Hint(HINT_CARD,0,9911520)
			fe:UseCountLimit(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local dg=Duel.SelectMatchingCard(tp,c9911514.deckfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
			Duel.Release(dg,REASON_COST)
			Duel.SendtoGrave(dg,REASON_RELEASE+REASON_COST)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local rg=sg:FilterSelect(tp,Card.IsReleasable,1,1,nil)
			Duel.Release(rg,REASON_COST)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
