--魔餐管家
function c51930020.initial_effect(c)
	--pendulum
	aux.EnablePendulumAttribute(c)
	--pendulum effect
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1191)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c51930020.tgtg)
	e1:SetOperation(c51930020.tgop)
	c:RegisterEffect(e1)
	--ritual
	local e2=aux.AddRitualProcEqual2(c,nil,LOCATION_HAND+LOCATION_GRAVE,nil,c51930020.mfilter,true)
	e2:SetDescription(1168)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(0)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCost(c51930020.rscost)
	c:RegisterEffect(e2)
	--monster effect
	--pzone move
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,51930020)
	e3:SetTarget(c51930020.settg)
	e3:SetOperation(c51930020.setop)
	c:RegisterEffect(e3)
end
function c51930020.tgfilter(c)
	return c:IsType(0x81) and c:IsAbleToGrave()
end
function c51930020.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51930020.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c51930020.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c51930020.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c51930020.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c51930020.mfilter(c)
	return c:IsSetCard(0x5258)
end
function c51930020.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c51930020.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
