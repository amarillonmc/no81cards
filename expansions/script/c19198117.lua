--星耀士-辉神三角
function c19198117.initial_effect(c)
  --pendulum summon
	aux.EnablePendulumAttribute(c)
	local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(19198117,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,19198117)
	e3:SetTarget(c19198117.rptg)
	e3:SetOperation(c19198117.rpop)
	c:RegisterEffect(e3)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c19198117.splimit)
	c:RegisterEffect(e2)   
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,19198118)
	e1:SetCost(c19198117.spcost)
	e1:SetTarget(c19198117.sptg)
	e1:SetOperation(c19198117.spop)
	c:RegisterEffect(e1)
end
function c19198117.rpfilter(c,e,tp)
	return ((c:IsSetCard(0x9c) and c:IsType(TYPE_SPELL+TYPE_TRAP) )or c:IsCode(41510920))  and c:IsAbleToHand()
end
function c19198117.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19198117.rpfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19198117.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c19198117.rpfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if c:IsRelateToEffect(e) and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		
   
	Duel.ConfirmCards(1-tp,g)
	Duel.Destroy(c,REASON_EFFECT)
	end
end
function c19198117.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x9c,0xc4) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
-- m EFFECT
--function c19198117.counterfilter(c)
  --  return c:IsSetCard(0x9c)
--end
function c19198117.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable()
		and Duel.GetCustomActivityCount(19198117,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Release(e:GetHandler(),REASON_COST)
   -- local e1=Effect.CreateEffect(e:GetHandler())
   --e1:SetType(EFFECT_TYPE_FIELD)
   -- e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
   -- e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
   -- e1:SetTargetRange(1,0)
   -- e1:SetTarget(c19198117.19198117)
   -- e1:SetReset(RESET_PHASE+PHASE_END)
   -- Duel.RegisterEffect(e1,tp)
end 
function c19198117.spfilter(c,e,tp)
	return c:IsSetCard(0x9c) and not c:IsCode(19198117)and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19198117.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c19198117.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end 
function c19198117.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c19198117.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end