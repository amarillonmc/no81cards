--锻溶 内甲裁缝
function c33200008.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to extra
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,33200008)
	e1:SetTarget(c33200008.tetg)
	e1:SetOperation(c33200008.teop)
	c:RegisterEffect(e1)	
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PSYCHO))
	e2:SetValue(200)
	c:RegisterEffect(e2)
	--special summon from hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200008,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,33200009)
	e3:SetCost(c33200008.DRcost)
	e3:SetTarget(c33200008.sptg)
	e3:SetOperation(c33200008.spop)
	c:RegisterEffect(e3) 
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,332000010)
	e4:SetTarget(c33200008.thtg)
	e4:SetOperation(c33200008.thop)
	c:RegisterEffect(e4) 
end

--e1
function c33200008.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x321) and not c:IsCode(33200008)
end
function c33200008.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200008.tefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c33200008.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33200008,1))
	local g=Duel.SelectMatchingCard(tp,c33200008.tefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	end
end

--e3
function c33200008.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsReleasable()
end
function c33200008.DRcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200008.tgfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c33200008.tgfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c33200008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33200008.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--e4
function c33200008.spfilter(c,e,tp,tc)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_PSYCHO) and c:IsLevelBelow(8) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33200008.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return c:IsControler(tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c33200008.spfilter,tp,LOCATION_HAND,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33200008.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c33200008.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc)
			if g:GetCount()~=0 then
				local tc=g:GetFirst()  
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)  
			end
			Duel.SpecialSummonComplete()
		end
	end
end
