--六花圣 尾花絮
function c98920108.initial_effect(c)
		--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),4,2)
	c:EnableReviveLimit()   
 --special summon (hand)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920108,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920108)
	e1:SetCondition(c98920108.spcon1)
	e1:SetTarget(c98920108.sptg1)
	e1:SetOperation(c98920108.spop1)
	c:RegisterEffect(e1)   
 --search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920108,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,98930108)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c98920108.thcost)
	e3:SetTarget(c98920108.thtg)
	e3:SetOperation(c98920108.thop)
	c:RegisterEffect(e3)
end
function c98920108.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c98920108.spfilter1(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920108.drfilter(c)
	return c:IsSetCard(0x141)
end
function c98920108.sptg1(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920108.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end  
	local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsSetCard,nil,0x141)
	local num=g:GetCount()   
	Duel.SetTargetParam(num)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,num,tp,LOCATION_HAND)	  
end
function c98920108.spop1(e,tp,eg,ep,ev,re,r,rp) 
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(c98920108.spfilter1,tp,LOCATION_HAND,0,nil,e,tp)
	if ft<1 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft,ct))
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
function c98920108.cfilter(c,tp)
	local sum=math.max(c:GetOriginalLevel(),0)
	return c:IsAttackAbove(0) and c:IsDefenseAbove(0) and c:IsLevelAbove(0)
		and Duel.IsExistingMatchingCard(c.thfilter,tp,LOCATION_DECK,0,1,nil,sum)
end
function c98920108.thfilter(c,csum)
	local sum=math.max(c:GetOriginalLevel(),0)
	return c:IsAttackAbove(0) and c:IsDefenseAbove(0) and c:IsSetCard(0x141) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and csum==sum
end
function c98920108.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c98920108.cfilter,1,nil,tp) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local g=Duel.SelectReleaseGroup(tp,c98920108.cfilter,1,1,nil,tp)
	local sum=math.max(g:GetFirst():GetOriginalLevel(),0)
	e:SetLabel(sum)
	Duel.Release(g,REASON_COST)   
end
function c98920108.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920108.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920108.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end