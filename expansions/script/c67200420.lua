--术结天缘 安贝尔·洛奇
function c67200420.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableCounterPermit(0x671,LOCATION_PZONE+LOCATION_MZONE)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200420,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,67200433)
	e1:SetCondition(c67200420.pccon)
	e1:SetCost(c67200420.pccost)
	e1:SetTarget(c67200420.pctg)
	e1:SetOperation(c67200420.pcop)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	--e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c67200400.ctcon)
	--e2:SetTarget(c67200400.cttg)
	e2:SetOperation(c67200400.ctop)
	c:RegisterEffect(e2)  
	--pendulum scale up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetValue(c67200400.scaledown)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e4)  
end
--
function c67200420.pccon(e,tp,eg,ep,ev,re,r,rp)
	return c:GetCounter(0x671)>0
end
function c67200420.pccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c67200420.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsSetCard(0x5671) and c:IsFaceup()
end
function c67200420.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c67200420.pcfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c67200420.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c67200420.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--
function c67200400.ctfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsType(TYPE_PENDULUM) and c:IsPreviousSetCard(0x5671)
end
function c67200400.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200400.ctfilter,1,nil,tp)
end
function c67200400.actfilter(c)
	return c:IsSetCard(0x3671) and not c:IsForbidden()
end

function c67200400.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:GetHandler():AddCounter(0x671,2)
	if Duel.IsPlayerCanDraw(tp,1) and c:GetCounter(0x671)>5 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and c:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(67200400,2)) then
		Duel.BreakEffect()
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
--
function c67200400.scaledown(e,c)
	local count=c:GetCounter(0x671)
	local a=0
	if count>6 then
		a=6
	else
		a=count
	end
	return -a
end
--