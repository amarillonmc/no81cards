--伽摩
function c9951602.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xba5),1,2)
	c:EnableReviveLimit()
   --reflect battle dam
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951602.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951602,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c9951602.thcost)
	e1:SetTarget(c9951602.thtg)
	e1:SetOperation(c9951602.thop)
	c:RegisterEffect(e1)
  --atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951602,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9951602.atkcon)
	e3:SetOperation(c9951602.atkop)
	c:RegisterEffect(e3)
end
function c9951602.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9951602.filter(c)
	return c:IsLevelBelow(2) and c:IsSetCard(0xba5) and c:IsAbleToHand()
end
function c9951602.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9951602.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9951602.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9951602.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9951602.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c9951602.sumlimit)
		e1:SetLabel(tc:GetCode())
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SUMMON)
		Duel.RegisterEffect(e2,tp)
	end
end
function c9951602.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function c9951602.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951602,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951602,1))
end
function c9951602.atkfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c9951602.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9951602.atkfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function c9951602.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=eg:FilterCount(c9951602.atkfilter,nil)
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951602,2))
end
