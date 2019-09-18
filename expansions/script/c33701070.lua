--朱音 ～日常的收获祭～
function c33701070.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c33701070.cost)
	e2:SetTarget(c33701070.pentg)
	e2:SetOperation(c33701070.penop)
	c:RegisterEffect(e2)
end
function c33701070.costfilter(c)
	return c:IsSetCard(0x6440) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c33701070.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) or Duel.IsExistingMatchingCard(c33701070.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.PayLPCost(tp,1000)
	Duel.DiscardHand(tp,c33701070.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c33701070.penfilter(c)
	return c:IsSetCard(0x3440) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c33701070.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33701070.penfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c33701070.penop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 if not e:GetHandler():IsRelateToEffect(e) then return end
	  Duel.SendtoHand(c,nil,REASON_EFFECT)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	 local g=Duel.SelectMatchingCard(tp,c33701070.penfilter,tp,LOCATION_DECK,0,1,1,nil)
	 local tc=g:GetFirst()
	 if tc then
	  Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	  end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(33701070,0))
end