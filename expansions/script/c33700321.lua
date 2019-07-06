--革新者的肝心 尼克斯
function c33700321.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700321,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c33700321.atg)
	e2:SetOperation(c33700321.aop)
	c:RegisterEffect(e2)
	--battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)   
	--tof
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_DESTROY)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,33700321)
	e5:SetCondition(c33700321.tfcon)
	e5:SetCost(c33700321.tfcost)
	e5:SetTarget(c33700321.tftg)
	e5:SetOperation(c33700321.tfop)
	c:RegisterEffect(e5)
end
function c33700321.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD)
end
function c33700321.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD+REASON_COST)
end
function c33700321.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700321.cfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>=1 end
end
function c33700321.tfop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	local ct=math.min(2,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33700321.cfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,ct,ct,nil)
	if tg:GetCount()<=0 then return end
	for tc in aux.Next(tg) do
	   if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetCode(EFFECT_CHANGE_TYPE)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		  e1:SetReset(RESET_EVENT+0x1fc0000)
		  e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		  tc:RegisterEffect(e1)
	   end
	end
end
function c33700321.cfilter(c)
	return c:IsSetCard(0x1449) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c33700321.tgfilter(c)
	return c:IsSetCard(0x1449) and c:GetTextAttack()>0 and c:IsAbleToGrave()
end
function c33700321.atg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700321.tgfilter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_SZONE)
end
function c33700321.aop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33700321.tgfilter,tp,LOCATION_SZONE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then
	  local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) 
	  local code=EFFECT_UPDATE_ATTACK 
	  if Duel.SelectYesNo(tp,aux.Stringid(33700321,1)) then code=EFFECT_UPDATE_DEFENSE end
	  for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(code)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-1*g:GetFirst():GetBaseAttack())
		tc:RegisterEffect(e1)
	  end
	end
end