--合辛的骑士授勋
function c17337713.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17337713,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(2,17337713)
	e1:SetCost(c17337713.thcost)
	--e1:SetTarget(c17337713.thtg)
	e1:SetOperation(c17337713.thop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,17337713+1)
	e2:SetCondition(c17337713.setcon)
	e2:SetCost(c17337713.setcost)
	e2:SetTarget(c17337713.settg)
	e2:SetOperation(c17337713.setop)
	c:RegisterEffect(e2)
end
function c17337713.costfilter(c,e,tp)
	return c:IsCode(17337700,17337708) and c:IsFaceup() and c:IsAbleToHandAsCost()
		and Duel.IsExistingMatchingCard(c17337713.thfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c17337713.thfilter(c,e,tp,code)
	return c:IsCode(17337700,17337708) and not c:IsCode(code) and (c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsLocation(LOCATION_HAND) or Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c17337713.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17337713.costfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,17337713+1)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,c17337713.costfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	e:SetLabel(tc:GetCode())
	Duel.HintSelection(Group.FromCards(tc))
	--if tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	--limit
	Duel.RegisterFlagEffect(tp,17337713,RESET_PHASE+PHASE_END,0,1)
end
function c17337713.thop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c17337713.thfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,code):GetFirst()
	if not tc then return end
	if tc:IsAbleToHand() and not tc:IsLocation(LOCATION_HAND) and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetMZoneCount(tp)<=0 or Duel.SelectOption(tp,1190,1152)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c17337713.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c17337713.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c17337713.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,17337713)==0 end
	Duel.RegisterFlagEffect(tp,17337713+1,RESET_PHASE+PHASE_END,0,1)
end
function c17337713.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
