--幻影旅团·镇魂协奏曲 终章
function c45746036.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c45746036.handcon)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,45746036+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c45746036.discon)
	e2:SetTarget(c45746036.distg)
	e2:SetOperation(c45746036.disop)
	c:RegisterEffect(e2)


	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(45746036,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCountLimit(1,45746036+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c45746036.eqcon)
	e3:SetCost(c45746036.cost)
	e3:SetTarget(c45746036.settg)
	e3:SetOperation(c45746036.setop)
	c:RegisterEffect(e3)

end
--e1e2
function c45746036.filter(c)
	return c:IsFaceup() and c:IsCode(45746000)
end
function c45746036.handcon(e)
	return Duel.IsExistingMatchingCard(c45746036.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c45746036.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf93) and c:IsType(TYPE_MONSTER)
end
function c45746036.discon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return ((te and p==tp and rp==1-tp) or ( rp==1-tp and tp==Duel.GetTurnPlayer()))
			and Duel.IsExistingMatchingCard(c45746036.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c45746036.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c45746036.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c45746036.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		if not Duel.IsExistingMatchingCard(c45746036.filter2,tp,LOCATION_MZONE,0,1,nil) then
		Duel.Destroy(eg,REASON_EFFECT) end
		if Duel.IsExistingMatchingCard(c45746036.filter2,tp,LOCATION_MZONE,0,1,nil) and
		   Duel.SelectYesNo(tp,aux.Stringid(45746036,0)) then
		   local xyzg=Duel.GetMatchingGroup(c45746036.filter2,tp,LOCATION_MZONE,0,nil,g) 
		   if xyzg:GetCount()>0 then
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			  local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			  rc:CancelToGrave()
			  c:CancelToGrave()
			  Duel.Overlay(xyz,c)
			  Duel.Overlay(xyz,Group.FromCards(rc))
			  else
			  Duel.Destroy(eg,REASON_EFFECT)
			end
		end
	end
end
--e3
function c45746036.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c45746036.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():IsFaceup() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_RETURN)
end
function c45746036.setfilter(c)
	return c:IsSetCard(0x5880) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c45746036.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c45746036.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c45746036.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c45746036.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		tc:RegisterEffect(e2)
	end
end