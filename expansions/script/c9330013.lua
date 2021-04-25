--陷阵营·反击！
function c9330013.initial_effect(c)
	--act in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c9330013.handcon)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,9330013+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c9330013.discon)
	e2:SetTarget(c9330013.distg)
	e2:SetOperation(c9330013.disop)
	c:RegisterEffect(e2)
	--set/to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.exccon)
	e3:SetCountLimit(1,9330113+EFFECT_COUNT_CODE_DUEL)
	e3:SetCost(c9330013.thcost)
	e3:SetTarget(c9330013.settg)
	e3:SetOperation(c9330013.setop)
	c:RegisterEffect(e3)
end
function c9330013.filter(c)
	return c:IsFaceup() and c:IsCode(9330001)
end
function c9330013.handcon(e)
	return Duel.IsExistingMatchingCard(c9330013.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c9330013.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf9c) and c:IsType(TYPE_MONSTER)
end
function c9330013.discon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return ((te and p==tp and rp==1-tp) or ( rp==1-tp and tp==Duel.GetTurnPlayer()))
			and Duel.IsExistingMatchingCard(c9330013.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9330013.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9330013.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9330013.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		if not Duel.IsExistingMatchingCard(c9330013.filter2,tp,LOCATION_MZONE,0,1,nil) then
		Duel.Destroy(eg,REASON_EFFECT) end
		if Duel.IsExistingMatchingCard(c9330013.filter2,tp,LOCATION_MZONE,0,1,nil) and
		   Duel.SelectYesNo(tp,aux.Stringid(9330013,0)) then
		   local xyzg=Duel.GetMatchingGroup(c9330013.filter2,tp,LOCATION_MZONE,0,nil,g) 
		   if xyzg:GetCount()>0 then
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			  local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			  rc:CancelToGrave()
			  c:CancelToGrave()
			  Duel.Overlay(xyz,eg)
			  Duel.Overlay(xyz,c)
			  else
			  Duel.Destroy(eg,REASON_EFFECT)
			end
		end
	end
end
function c9330013.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c9330013.setfilter(c)
	if not (c:IsSetCard(0xf9c) and c:IsType(TYPE_TRAP) and not c:IsCode(9330013)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function c9330013.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9330013.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c9330013.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9330013.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end













