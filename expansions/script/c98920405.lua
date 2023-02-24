--诅咒遗式术师
function c98920405.initial_effect(c)
	 --ritual level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_RITUAL_LEVEL)
	e2:SetValue(c98920405.rlevel)
	c:RegisterEffect(e2)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920405,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920405)
	e1:SetCost(c98920405.spcost)
	e1:SetTarget(c98920405.sptg)
	e1:SetOperation(c98920405.spop)
	c:RegisterEffect(e1)
end
function c98920405.rlevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	if c:IsSetCard(0x3a) then
		local clv=c:GetLevel()
		return (lv<<16)+clv
	else return lv end
end
function c98920405.costfilter(c,e,tp,g,ft,sg)
	local lv=c:GetLevel()
	return c:IsSetCard(0x3a) and c:IsType(TYPE_RITUAL) and Duel.GetMatchingGroup(c98920405.spfilter,tp,LOCATION_DECK,LOCATION_DECK,nil,e,tp):CheckWithSumEqual(Card.GetLevel,lv,1,3)
end
function c98920405.spfilter(c,e,tp)
	return c:IsSetCard(0x3a) and not c:IsType(TYPE_RITUAL) and c:IsAbleToHand() and c:IsLevelAbove(1)
end
function c98920405.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=e:GetOwner():GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(c98920405.costfilter,tp,LOCATION_DECK,0,1,nil) and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920405.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.SendtoGrave(g,REASON_COST) 
end
function c98920405.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tp=e:GetOwner():GetControler()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920405.spop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetOwner():GetControler()
	local g=Duel.GetMatchingGroup(c98920405.spfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectWithSumEqual(tp,Card.GetLevel,e:GetLabel(),1,3)
	if sg and sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98920405.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98920405.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end