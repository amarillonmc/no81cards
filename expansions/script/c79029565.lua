--贯穿之运
function c79029565.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c79029565.accost)
	e1:SetTarget(c79029565.actg)
	e1:SetOperation(c79029565.acop)
	c:RegisterEffect(e1)
end
function c79029565.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c79029565.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c79029565.tcck(c,flag)
	return c:GetFlagEffect(flag)~=0
end
function c79029565.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER)
	local xx=g:GetCount()
	local tc=g:GetFirst()
	local x=0
	while tc do 
	x=x+1
	tc:RegisterFlagEffect(79029565+xx-x,RESET_CHAIN,0,1)
	tc=g:GetNext()
	end
	local tc1=Duel.GetFirstMatchingCard(c79029565.tcck,tp,LOCATION_DECK,0,nil,79029565)
	local tc2=Duel.GetFirstMatchingCard(c79029565.tcck,tp,LOCATION_DECK,0,nil,79029566)
	local tc3=Duel.GetFirstMatchingCard(c79029565.tcck,tp,LOCATION_DECK,0,nil,79029567)
	local tc4=Duel.GetFirstMatchingCard(c79029565.tcck,tp,LOCATION_DECK,0,nil,79029568)
	local seq=tc4:GetSequence()
	Duel.ConfirmDecktop(tp,dcount-seq)
	local g=Group.FromCards(tc1,tc2,tc3,tc4)
	if g:IsExists(Card.IsLevel,1,nil,1) and g:IsExists(Card.IsLevel,1,nil,2) and g:IsExists(Card.IsLevel,1,nil,3) and g:IsExists(Card.IsLevel,1,nil,4) then 
	if ((tc1:IsLevel(1) and tc2:IsLevel(2) and tc3:IsLevel(3) and tc4:IsLevel(4)) or (tc1:IsLevel(4) and tc2:IsLevel(3) and tc3:IsLevel(2) and tc4:IsLevel(1))) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=4 and tc1:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc2:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc3:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc4:IsCanBeSpecialSummoned(e,0,tp,false,false) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.SelectYesNo(tp,aux.Stringid(79029565,0)) then 
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	end
	end
end










