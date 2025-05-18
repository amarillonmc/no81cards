--神龙之地-里特司
local s,id,o=GetID()
function c75000025.initial_effect(c)
	aux.AddCodeList(c,75000001)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75000025+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c75000025.activate)
	c:RegisterEffect(e1)
------1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c75000025.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,75000025+o)
	e5:SetCondition(c75000025.thcon)
	e5:SetTarget(c75000025.thtg)
	e5:SetOperation(c75000025.thop)
	c:RegisterEffect(e5)
end
function c75000025.filter(c)
	return ((c:IsSetCard(0x3751) and c:IsType(TYPE_MONSTER)) or c:IsCode(75000001)) and c:IsAbleToHand()
end
function c75000025.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c75000025.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(75000025,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
-------1
function c75000025.atktg(e,c)
	return c:IsSetCard(0x3751)
end
-------2
function c75000025.cfilter(c,tp)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsSummonPlayer(tp)
end
function c75000025.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75000025.cfilter,1,nil,tp)
end
function c75000025.thfilter(c)
	return (c:IsCode(75000001) or aux.IsCodeListed(c,75000001) and c:IsType(TYPE_MONSTER)) and c:IsAbleToHand()
end
function c75000025.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000025.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75000025.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75000025.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end