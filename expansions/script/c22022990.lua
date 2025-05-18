--人理之基 尼莫船长
function c22022990.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6ff1),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_WATER),true)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022990,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,22022990)
	e1:SetCondition(c22022990.thcon)
	e1:SetTarget(c22022990.thtg)
	e1:SetOperation(c22022990.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022990,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22022990.rmcon)
	e2:SetCost(c22022990.cost)
	e2:SetTarget(c22022990.sptg)
	e2:SetOperation(c22022990.spop)
	c:RegisterEffect(e2)
	--spsummon ere
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022990,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c22022990.rmcon1)
	e3:SetCost(c22022990.cost1)
	e3:SetTarget(c22022990.sptg)
	e3:SetOperation(c22022990.spop)
	c:RegisterEffect(e3)
end
function c22022990.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c22022990.thfilter(c)
	return ((c:IsSetCard(0xff1) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or c:IsCode(22702055)) and c:IsAbleToHand()
end
function c22022990.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22022990.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22022990.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22022990.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22022990.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsEnvironment(22702055,PLAYER_ALL,LOCATION_ONFIELD)
	if check then return e:GetHandler():GetFlagEffect(22022990)<2
	else return e:GetHandler():GetFlagEffect(22022990)<1 end
end
function c22022990.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22022991,0x6ff1,TYPES_TOKEN_MONSTER,500,500,1,RACE_AQUA,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	e:GetHandler():RegisterFlagEffect(22022990,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c22022990.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,22022991,0x6ff1,TYPES_TOKEN_MONSTER,500,500,1,RACE_AQUA,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,22022991)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c22022990.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,2000)
end
function c22022990.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsEnvironment(22702055,PLAYER_ALL,LOCATION_ONFIELD)
	if check then return e:GetHandler():GetFlagEffect(22022990)<2
	else return e:GetHandler():GetFlagEffect(22022990)<1 end
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22022990.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,2000)
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end