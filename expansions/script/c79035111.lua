--驶向明日的方舟
function c79035111.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79035111+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c79035111.tg)
	e1:SetOperation(c79035111.op)
	c:RegisterEffect(e1)
end
function c79035111.spfil(c,e,tp)
	return c:IsSetCard(0xca3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 ) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 )) 
end
function c79035111.thfil(c)
	return c:IsSetCard(0xca3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c79035111.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c79035111.spfil,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c79035111.thfil,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0 
	if b1 and b2 then
	op=Duel.SelectOption(tp,aux.Stringid(79035111,0),aux.Stringid(79035111,1))
	elseif b1 then
	op=Duel.SelectOption(tp,aux.Stringid(79035111,0))
	else
	op=Duel.SelectOption(tp,aux.Stringid(79035111,1))+1
	end
	e:SetLabel(op)
	if op==0 then 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
	else
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c79035111.op(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
	local g=Duel.GetMatchingGroup(c79035111.spfil,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()<=0 then return end
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	else
	local g=Duel.GetMatchingGroup(c79035111.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	local tc=g:Select(tp,1,1,nil)
	Duel.SendtoHand(tc,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,tc)   
	end
end





