--狂暴大鸡鸡
function c10173028.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173028,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,10173028)
	e1:SetTarget(c10173028.settg)
	e1:SetOperation(c10173028.setop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173028,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,10173128)
	e2:SetTarget(c10173028.destg)
	e2:SetOperation(c10173028.desop)
	c:RegisterEffect(e2)
end
function c10173028.desfilter(c)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:IsSetCard(0xa338)
end
function c10173028.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10173028.desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c10173028.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c10173028.desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 and g:GetFirst():IsPreviousLocation(LOCATION_ONFIELD) then
	   g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	   if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10173028,2)) then
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		  local dg=g:Select(tp,1,1,nil)
		  Duel.HintSelection(dg)
		  Duel.Destroy(dg,REASON_EFFECT)
	   end
	end
end
function c10173028.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function c10173028.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,c)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden() and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
	   if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		  local e1=Effect.CreateEffect(c)
		  e1:SetCode(EFFECT_CHANGE_TYPE)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		  e1:SetReset(RESET_EVENT+0x1fc0000)
		  e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		  c:RegisterEffect(e1)
		  g=Duel.GetMatchingGroup(c10173028.tdfilter,tp,LOCATION_GRAVE,0,nil)
		  if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10173028,3)) then
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			 local tg=g:Select(tp,1,3,nil)
			 Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		  end
	   end
	end
end
function c10173028.tdfilter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsAbleToDeck()
end