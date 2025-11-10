--机巧祝-空狐之御先稻荷
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,24793135)
	c:EnableReviveLimit()
	--link summon
	aux.AddLinkProcedure(c,s.mfilter,1,1)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)   
	--special summon
	local se2=Effect.CreateEffect(c)
	se2:SetDescription(aux.Stringid(id,2))
	se2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	se2:SetType(EFFECT_TYPE_QUICK_O)
	se2:SetCode(EVENT_FREE_CHAIN)
	se2:SetRange(LOCATION_MZONE)
	se2:SetCountLimit(1,id+1)
	se2:SetCondition(function()return Duel.IsMainPhase() end)
	se2:SetTarget(s.target)
	se2:SetOperation(s.operation)
	c:RegisterEffect(se2) 
end
function s.mfilter(c)
	if not c:IsType(TYPE_MONSTER) or c:IsType(TYPE_LINK) then return false end
	return c:GetAttack()==c:GetDefense()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.thfilter(c)
	return c:IsCode(24793135) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	local b2=fc and fc:IsFaceup() and fc:IsCode(24793135) and fc:IsCanAddCounter(0x5d,3)
	if chk==0 then return b1 or b2  end
	if b1 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if b2 then
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,fc,3,tp,0x5d)
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	local b2=fc and fc:IsFaceup() and fc:IsCode(24793135) and fc:IsCanAddCounter(0x5d,3)
	if not b1 then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		fc:AddCounter(0x5d,3)
	end
end

function s.filter(c,e,tp,zone)
	if not c:IsType(TYPE_MONSTER) or c:IsType(TYPE_LINK) then return false end
	return c:GetAttack()==c:GetDefense() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end
