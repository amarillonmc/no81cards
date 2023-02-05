--焰圣骑士 布拉达曼特
function c98920172.initial_effect(c)
		--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,98920172)
	e1:SetCost(c98920172.spcost)
	e1:SetTarget(c98920172.sptg)
	e1:SetOperation(c98920172.spop)
	c:RegisterEffect(e1)  
  --tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920172,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,98930172)
	e2:SetTarget(c98920172.tgtg)
	e2:SetOperation(c98920172.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c98920172.cfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsCode(98920172) and c:IsAbleToGraveAsCost()
end
function c98920172.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c98920172.cfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920172.cfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98920172.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c98920172.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920172.tgfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsCode(98920172) and c:IsAbleToGrave()
end
function c98920172.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920172.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98920172.tgop(e,tp,eg,ep,ev,re,r,rp)   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920172.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local tc=g:GetFirst()
	   if tc and Duel.Summon(tp,tc,true,nil)~=0 and tc:IsLevel(1) then
		  local sg=Duel.GetMatchingGroup(c40392714.thfilter,tp,LOCATION_DECK,0,nil)
		  if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40392714,0)) then
			 Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 sg=sg:Select(tp,1,1,nil)
			 Duel.SendtoHand(sg,tp,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c40392714.thfilter(c)
	return c:IsLevel(4) and c:IsRace(RACE_WARRIOR) and c;IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end