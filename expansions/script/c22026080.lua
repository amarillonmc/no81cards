--人理之星 尼莫/诺亚
function c22026080.initial_effect(c)
	aux.AddCodeList(c,22025820)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,3,4,c22026080.lcheck)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22026080,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,22026080)
	e1:SetCondition(c22026080.thcon)
	e1:SetTarget(c22026080.thtg)
	e1:SetOperation(c22026080.thop)
	c:RegisterEffect(e1)
	--ATTRIBUTE_WATER
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22026080,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,22026081)
	e2:SetTarget(c22026080.atttg)
	e2:SetOperation(c22026080.attop)
	c:RegisterEffect(e2)
	--ATTRIBUTE_WATER ere
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22026080,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,22026081)
	e3:SetCondition(c22026080.attconere)
	e3:SetCost(c22026080.erecost)
	e3:SetTarget(c22026080.atttg)
	e3:SetOperation(c22026080.attop)
	c:RegisterEffect(e3)
	--ATTRIBUTE_WATER aeg
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22026080,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,22026081)
	e4:SetCondition(c22026080.spcon)
	e4:SetTarget(c22026080.atttg)
	e4:SetOperation(c22026080.attop)
	c:RegisterEffect(e4)
	--ATTRIBUTE_WATER aeg ere
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22026080,1))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,22026081)
	e5:SetCondition(c22026080.spcon1)
	e5:SetCost(c22026080.erecost)
	e5:SetTarget(c22026080.atttg)
	e5:SetOperation(c22026080.attop)
	c:RegisterEffect(e5)
end
function c22026080.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end
function c22026080.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c22026080.filter(c,e,tp,check)
	return (c:IsSetCard(0xff1) or c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST+RACE_DINOSAUR)) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand()
		or check and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c22026080.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=1
		return Duel.IsExistingMatchingCard(c22026080.filter,tp,LOCATION_DECK,0,1,nil,e,tp,check)
	end
end
function c22026080.thop(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c22026080.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,check)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	local b=check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if tc:IsAbleToHand() and (not b or Duel.SelectOption(tp,1190,1152)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22026080.tgfilter(c)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_WATER)
end
function c22026080.tgfilter1(c)
	return not c:IsAttribute(ATTRIBUTE_WATER) or c:IsFacedown()
end
function c22026080.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.nzatk(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22026080.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22026080.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,12,nil)
end
function c22026080.attop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c22026080.tgfilter,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_WATER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	Duel.BreakEffect()
	local g1=Duel.GetMatchingGroup(c22026080.tgfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
end
function c22026080.attconere(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22026080.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22026080.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(22025820) and ep==tp
end
function c22026080.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(22025820) and ep==tp and Duel.IsPlayerAffectedByEffect(tp,22020980)
end