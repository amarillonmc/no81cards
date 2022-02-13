--键★等 －选美星探 | K.E.Y Etc. Ricognizione
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x460) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.spcheck(g)
	return g:GetClassCount(Card.GetCode)==1
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x460) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,1-tp,true,false,POS_FACEUP,1-tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local ft=math.min(3,#g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=g:SelectSubGroup(tp,s.spcheck,false,1,ft)
		if #hg>0 and Duel.SendtoHand(hg,nil,REASON_EFFECT)>0 and hg:Filter(Card.IsLocation,nil,LOCATION_HAND):FilterCount(Card.IsControler,nil,tp)>0 then
			local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND):Filter(Card.IsControler,nil,tp)
			Duel.ConfirmCards(1-tp,og)
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)+#og*2000)
		end
	end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,0,LOCATION_HAND,1,nil,e,tp) and Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(1-tp,s.spfilter,tp,0,LOCATION_HAND,1,1,nil,e,tp)
		if #sg>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(sg:GetFirst(),0,1-tp,1-tp,true,false,POS_FACEUP)
		end
	end
end