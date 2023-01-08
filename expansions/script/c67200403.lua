--术结天缘 库娜
function c67200403.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	c:SetSPSummonOnce(67200403)
	aux.AddLinkProcedure(c,c67200403.mfilter,1,1)  
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200403,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c67200403.thcon1)
	e1:SetTarget(c67200403.thtg1)
	e1:SetOperation(c67200403.thop1)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(94243005,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c67200403.thtg)
	e3:SetOperation(c67200403.thop)
	c:RegisterEffect(e3)
end
function c67200403.mfilter(c)
	return c:IsLinkRace(RACE_SPELLCASTER) and c:IsLinkType(TYPE_PENDULUM)
end
--
function c67200403.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c67200403.thfilter1(c)
	return c:IsCode(67200429) and c:IsAbleToHand()
end
function c67200403.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200403.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200403.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200403.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c67200403.thfilter11(c,tp)
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and lv>0 and c:IsCanHaveCounter(0x671)
		and Duel.IsCanRemoveCounter(tp,1,0,0x671,lv,REASON_COST) and c:IsAbleToHand()
end
function c67200403.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200403.thfilter11,tp,LOCATION_EXTRA,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c67200403.thfilter11,tp,LOCATION_EXTRA,0,nil,tp)
	local lvt={}
	local tc=g:GetFirst()
	while tc do
		local tlv=tc:GetLevel()
		lvt[tlv]=tlv
		tc=g:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200403,1))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.RemoveCounter(tp,1,0,0x671,lv,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c67200403.thfilter2(c,lv)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsCanHaveCounter(0x671)
		and c:IsLevel(lv) and c:IsAbleToHand()
end
function c67200403.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200403.thfilter2,tp,LOCATION_EXTRA,0,1,1,nil,lv)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
