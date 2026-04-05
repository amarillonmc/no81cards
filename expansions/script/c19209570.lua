--判决牢狱的转变 樫木优乃
function c19209570.initial_effect(c)
	--xyz summon
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedure(c,nil,3,2,c19209570.ovfilter,aux.Stringid(19209570,0),2,c19209570.xyzop)
	c:EnableReviveLimit()
	--change name
	aux.EnableChangeCode(c,19209516,LOCATION_PZONE)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19209570,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c19209570.thcon)
	e1:SetTarget(c19209570.thtg)
	e1:SetOperation(c19209570.thop)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	--pendulum
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c19209570.pencon)
	e2:SetTarget(c19209570.pentg)
	e2:SetOperation(c19209570.penop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19209570,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c19209570.thcost)
	e3:SetTarget(c19209570.thtg)
	e3:SetOperation(c19209570.thop)
	e3:SetLabel(2)
	c:RegisterEffect(e3)
end
function c19209570.ovfilter(c)
	return c:IsCode(19209516) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(Card.IsCode,c:GetControler(),LOCATION_GRAVE,0,1,nil,19209528)
end
function c19209570.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,19209570)==0 end
	Duel.RegisterFlagEffect(tp,19209570,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c19209570.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c19209570.cfilter(c)
	return c:IsCode(19209554) and c:IsAbleToRemoveAsCost()
end
function c19209570.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209570.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c19209570.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c19209570.thfilter(c,op)
	return (op==1 and c:IsSetCard(0x3b50) and c:IsType(TYPE_MONSTER) or op==2 and c:IsSetCard(0xb51) and not c:IsCode(19209554)) and c:IsAbleToHand()
end
function c19209570.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local op=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(c19209570.thfilter,tp,LOCATION_GRAVE,0,1,nil,op) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c19209570.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 and not (c:IsRelateToEffect(e) and c:IsFaceup()) then return
	elseif e:GetLabel()==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(19209516)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c19209570.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e:GetLabel()):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c19209570.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function c19209570.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c19209570.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
