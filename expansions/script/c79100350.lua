--律法塔魂的民间传说 卡希娅
function c79100350.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3a11),c79100350.mfilter,true)
	--to hand or grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79100350,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79100350)
	e1:SetCondition(c79100350.condition)
	e1:SetTarget(c79100350.target)
	e1:SetOperation(c79100350.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,79100350+1)
	e2:SetTarget(c79100350.reptg)
	e2:SetValue(c79100350.repval)
	e2:SetOperation(c79100350.repop)
	c:RegisterEffect(e2)
end
function c79100350.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c79100350.mfilter(c)
	return c:IsRace(RACE_FAIRY) or c:IsFusionAttribute(ATTRIBUTE_LIGHT)
end
function c79100350.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3a11) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c79100350.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79100350.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c79100350.thfilter(c)
	return c:IsCode(24094653) and c:IsAbleToHand()
end
function c79100350.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c79100350.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local ck=0
		local tc=g:GetFirst()
		if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			ck=Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			ck=Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		if ck>0 and tc:IsLocation(LOCATION_HAND+LOCATION_GRAVE) then
			if Duel.IsExistingMatchingCard(c79100350.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(79100350,3)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c79100350.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
					if g:GetCount()>0 then
						Duel.BreakEffect()
						Duel.SendtoHand(g,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,g)
					end
			end
		end
	end
end
function c79100350.repfilter(c,tp)
	return not c:IsReason(REASON_REPLACE) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c79100350.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c79100350.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c79100350.repval(e,c)
	return c79100350.repfilter(c,e:GetHandlerPlayer())
end
function c79100350.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c79100350.indtg)
	e1:SetValue(c79100350.valcon)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	Duel.RegisterEffect(e1,tp)
end
function c79100350.indtg(e,c)
	return c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function c79100350.valcon(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end