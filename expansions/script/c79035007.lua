--小驴子交响曲
function c79035007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c79035007.con)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_NORMAL))
	e2:SetValue(500)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_NORMAL))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79035007,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,79035007)
	e2:SetTarget(c79035007.sptg2)
	e2:SetOperation(c79035007.spop2)
	c:RegisterEffect(e2)   
end
function c79035007.hfil(c)
	return not c:IsType(TYPE_NORMAL)
end
function c79035007.con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c79035007.hfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_NORMAL)
end
function c79035007.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c79035007.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_NORMAL)
end
function c79035007.spfilter2(c,e,tp)
	return c:IsAbleToHand() and c:IsType(TYPE_NORMAL)
end
function c79035007.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:GetCount()
	if ct>0 and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:FilterCount(c79035007.spfilter1,nil,e,tp)>0) or (g:FilterCount(c79035007.spfilter2,nil,e,tp)>0))
		and Duel.SelectYesNo(tp,aux.Stringid(79035007,2)) then
	local op=0 
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:FilterCount(c79035007.spfilter1,nil,e,tp)>0
	local b2=g:FilterCount(c79035007.spfilter2,nil,e,tp)>0
	if b1 and b2 then
	op=Duel.SelectOption(tp,aux.Stringid(79035007,0),aux.Stringid(79035007,1))
	elseif b1 then
	op=Duel.SelectOption(tp,aux.Stringid(79035007,1))
	else
	op=Duel.SelectOption(tp,aux.Stringid(79035007,0))
	end
		Duel.DisableShuffleCheck()
	if op==1 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:FilterSelect(tp,c79035007.spfilter1,1,1,nil,e,tp)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	else 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:FilterSelect(tp,c79035007.spfilter2,1,1,nil,e,tp)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	end
	end
end











