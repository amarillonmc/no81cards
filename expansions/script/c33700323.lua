--革新者的追猎 莫洛
function c33700323.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33700323.thtg)
	e1:SetOperation(c33700323.thop)
	c:RegisterEffect(e1)	
end
function c33700323.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsSetCard(0x6449)
end
function c33700323.tffilter(c)
	return c:IsFaceup() and not c:IsCode(33700323) and not c:IsForbidden()
end
function c33700323.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() and (Duel.IsExistingMatchingCard(c33700323.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) or Duel.IsExistingMatchingCard(c33700323.tffilter,tp,LOCATION_EXTRA,0,1,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c33700323.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c33700323.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c33700323.tffilter,tp,LOCATION_EXTRA,0,nil)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
	   g1:Merge(g2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	if not tc then return end
	if tc:IsLocation(LOCATION_EXTRA) then
	   Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	else
	   Duel.SendtoHand(tc,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,tc)
	end
end