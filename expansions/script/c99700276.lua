--龙界咒 跨界回归
function c99700276.initial_effect(c)
	c:SetUniqueOnField(1,0,99700276)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99700276,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,99700276)
	e2:SetCost(c99700276.cost)
	e2:SetCondition(c99700276.thcon)
	e2:SetTarget(c99700276.thtg)
	e2:SetOperation(c99700276.thop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(99700276,ACTIVITY_SPSUMMON,c99700276.counterfilter)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99700276,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,99700288)
	e3:SetTarget(c99700276.thtg1)
	e3:SetOperation(c99700276.thop1)
	c:RegisterEffect(e3)
end
function c99700276.counterfilter(c)
	return not c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_MONSTER) and (c:IsSetCard(0xfd00) or c:IsSetCard(0xfd04))
end
function c99700276.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xfd04) and c:IsType(TYPE_MONSTER) and (c:IsType(TYPE_FUSION) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_LINK)) and c:IsControler(tp)
end
function c99700276.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99700276.cfilter,1,nil,tp)
end
function c99700276.thfilter(c)
	return (c:IsSetCard(0xfd00) or c:IsSetCard(0xfd04)) and c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c99700276.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99700276.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE)
end
function c99700276.thop(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(c99700276.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
		if g:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
end
function c99700276.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(99700276,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99700276.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c99700276.splimit(e,c)
	return not (c:IsSetCard(0xfd00) or c:IsSetCard(0xfd04)) and c:IsLocation(LOCATION_EXTRA)
end
function c99700276.thfilter1(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xfd04) and c:IsAbleToHand()
end
function c99700276.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99700276.thfilter1,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function c99700276.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99700276.thfilter1,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end