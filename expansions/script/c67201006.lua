--天垣修正者 巧构
local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1193)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.ptg)
	e1:SetOperation(s.pop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetCountLimit(2,id)
	e2:SetCost(s.cost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(2,id)
	e3:SetTarget(s.pctg)
	e3:SetOperation(s.pcop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function s.pfilter(c)
	return c:IsSetCard(0x67a) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsFaceup()
end
function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
end
function s.pop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.pfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function s.costfilter(c)
	return c:IsSetCard(0x67a) and c:GetOriginalType()&TYPE_PENDULUM~=0 and c:IsFaceup() and c:IsAbleToExtra()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoExtraP(g,nil,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not c:IsForbidden()
	local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) and
	((c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
	(c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local b1=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not c:IsForbidden()
		local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) and
		((c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
		(c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
		if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(id,0),1118)==0) then
			Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.pcfilter(c)
	return c:IsSetCard(0xC67A) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) 
	and Duel.IsExistingMatchingCard(s.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.pcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	local g=Duel.SelectMatchingCard(tp,s.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end