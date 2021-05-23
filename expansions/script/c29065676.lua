--灵知隐者 猫眼的两仪织
function c29065676.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Destroy SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,29000038)
	e1:SetTarget(c29065676.desptg)
	e1:SetOperation(c29065676.despop)
	c:RegisterEffect(e1)
	--atk 
	local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x87aa))
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--search 
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCountLimit(1,29065676)
	e8:SetCondition(c29065676.thcon)
	e8:SetCost(c29065676.thcost)
	e8:SetTarget(c29065676.thtg)
	e8:SetOperation(c29065676.thop)
	c:RegisterEffect(e8)
end
function c29065676.spfil(c,e,tp)
	return c:IsSetCard(0x87aa) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29065676.desptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065676.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_PZONE)
end
function c29065676.despop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c29065676.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	sg=g:Select(tp,1,1,nil)
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) then
	Duel.BreakEffect()
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c29065676.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 
end
function c29065676.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c29065676.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0x87aa) and c:IsType(TYPE_MONSTER) and  not c:IsCode(29065676)
end
function c29065676.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065676.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29065676.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c29065676.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	dg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(dg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,dg)
end