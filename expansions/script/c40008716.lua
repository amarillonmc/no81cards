--森罗的姬芽神 树精
function c40008716.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c40008716.matfilter,1,1)
	c:EnableReviveLimit()	
	--deck check
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008716,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40008716)
	e1:SetTarget(c40008716.target)
	e1:SetOperation(c40008716.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(40008716,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,40008716)
	e2:SetCondition(c40008716.descon)
	e2:SetTarget(c40008716.sptg)
	e2:SetOperation(c40008716.spop)
	c:RegisterEffect(e2)
end
function c40008716.matfilter(c)
	return c:IsLinkSetCard(0x90) and not c:IsLinkCode(40008716)
end
function c40008716.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c40008716.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
		Duel.DisableShuffleCheck()
	if tc:IsRace(RACE_PLANT) then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	local ct=tc:GetLevel()
		if ct>0 then
		Duel.DiscardDeck(tp,ct,REASON_EFFECT)
	end
	elseif tc:IsAbleToHand() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c40008716.descfilter(c,lg)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and lg:IsContains(c)
end
function c40008716.descon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c40008716.descfilter,1,nil,lg)
end
function c40008716.spfilter(c,e,tp)
	return c:IsSetCard(0x90) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40008716.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40008716.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c40008716.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup() 
	local ct=lg:GetSum(Card.GetRank)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c40008716.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		if Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP) and Duel.SelectYesNo(tp,aux.Stringid(40008716,2)) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct then
		Duel.BreakEffect()
		Duel.SortDecktop(tp,tp,ct)
		end
	end
end