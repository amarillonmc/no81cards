--奥山修正者 梦影
function c67200950.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--xyz summon
	aux.AddXyzProcedure(c,c67200950.mfilter,4,2,c67200950.ovfilter,aux.Stringid(67200950,0),3,c67200950.xyzop)
	c:EnableReviveLimit()  
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c67200950.atktg)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200950,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,67200950)
	e1:SetCost(c67200950.thcost)
	e1:SetTarget(c67200950.thtg)
	e1:SetOperation(c67200950.thop)
	c:RegisterEffect(e1)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200950,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,67200951)
	e2:SetCondition(c67200950.stcon)
	e2:SetTarget(c67200950.sttg)
	e2:SetOperation(c67200950.stop)
	c:RegisterEffect(e2)	 
end
function c67200950.atktg(e,c)
	return c:IsSetCard(0x67a) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c67200950.mfilter(c)
	return c:IsSetCard(0x67a)
end
function c67200950.ovfilter(c)
	return c:IsFaceup() and c:IsCode(67200911)
end
function c67200950.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,67200950)==0 end
	Duel.RegisterFlagEffect(tp,67200950,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
--
function c67200950.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x67a) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
--
function c67200950.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c67200950.thfilter(c)
	return c:IsSetCard(0x367a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceup()
end
function c67200950.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200950.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c67200950.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200950.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c67200950.stcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function c67200950.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not e:GetHandler():IsForbidden() end
end
function c67200950.stop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then 
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end