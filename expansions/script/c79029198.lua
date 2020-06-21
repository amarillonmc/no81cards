--毅星壳·怒轮
function c198.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2,nil,nil,99) 
	c:EnableReviveLimit()  
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCost(c198.setcost)
	e2:SetTarget(c198.settg)
	e2:SetOperation(c198.setop)
	c:RegisterEffect(e2)
	--multi attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e3:SetValue(c198.raval)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c198.efilter)
	e4:SetCondition(c198.imcon)
	c:RegisterEffect(e4)
end
function c198.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c198.fil(c)
	return c:IsType(TYPE_XYZ)
end
function c198.imcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:GetMaterial():IsExists(c198.fil,1,nil)
end
function c198.raval(e,c)
	return e:GetHandler():GetOverlayCount()
end
function c198.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c198.setfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function c198.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_DECK) and c198.setfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c198.setfilter,tp,0,LOCATION_DECK,1,nil,tp) end
	local a=Duel.GetMatchingGroup(c198.setfilter,tp,0,LOCATION_DECK,nil)
	Duel.ConfirmCards(tp,a)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c198.setfilter,tp,0,LOCATION_DECK,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,g,1,0,0)
	Duel.SetChainLimit(c198.chlimit)
end
function c198.chlimit(e,ep,tp)
	return tp==ep
end
function c198.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end








