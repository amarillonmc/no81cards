--南方夏日庆典——心跳假日
function c10700237.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c10700237.activate)
	c:RegisterEffect(e1) 
	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c10700237.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3) 
	--change ATTRIBUTE
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10700237,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,10700237)
	e4:SetTarget(c10700237.target)
	e4:SetOperation(c10700237.operation)
	c:RegisterEffect(e4)  
end
function c10700237.thfilter(c)
	return c:IsSetCard(0x3a02) and c:IsAbleToHand() and not c:IsCode(10700237)
end
function c10700237.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c10700237.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10700237,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c10700237.atktg(e,c)
	return c:IsSetCard(0x3a01) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c10700237.tgfilter(c,att)
	return c:IsSetCard(0x3a01) and not c:IsAttribute(ATTRIBUTE_WATER)
end
function c10700237.target(e,tp,eg,ep,ev,re,r,rp,chk,g)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700237.tgfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c10700237.operation(e,tp,eg,ep,ev,re,r,rp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10700237.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	   e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	   e1:SetReset(RESET_PHASE+PHASE_END)
	   e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,g:GetFirst():GetAttribute()))
	   e1:SetValue(ATTRIBUTE_WATER)
	   Duel.RegisterEffect(e1,tp)
	   local e2=Effect.CreateEffect(e:GetHandler())
	   e2:SetType(EFFECT_TYPE_FIELD)
	   e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	   e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	   e2:SetReset(RESET_PHASE+PHASE_END)
	   e2:SetTargetRange(1,0)
	   e2:SetTarget(c10700237.splimit)
	   Duel.RegisterEffect(e2,tp)
   end
end
function c10700237.splimit(e,c)
	return not (c:IsType(TYPE_DUAL) or c:IsSetCard(0x3a01))
end