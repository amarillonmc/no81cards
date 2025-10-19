--Legend-Arms 直达撞击者
function c16310060.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,16310060)
	e1:SetCondition(c16310060.condition)
	e1:SetTarget(aux.nbtg)
	e1:SetOperation(c16310060.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16310060)
	e2:SetTarget(c16310060.reptg)
	e2:SetValue(c16310060.repval)
	e2:SetOperation(c16310060.repop)
	c:RegisterEffect(e2)
end
function c16310060.cfilter(c)
	return c:IsFaceup() and (c:IsAttack(0) or c:IsDefense(0))
end
function c16310060.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c16310060.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c16310060.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_REMOVED) and not tc:IsReason(REASON_REDIRECT) then
		local g1=Duel.GetMatchingGroup(c16310060.filter1,tp,LOCATION_REMOVED,0,nil)
		local g2=Duel.GetMatchingGroup(c16310060.filter2,tp,LOCATION_REMOVED,0,nil)
		if g1:GetCount()>0 and g2:GetCount()>0 
			and Duel.SelectYesNo(tp,aux.Stringid(16310060,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg2=g2:Select(tp,1,1,nil)
			sg1:Merge(sg2)
			Duel.BreakEffect()
			Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_RETURN)
		end
	end
end
function c16310060.filter1(c)
	return c:IsSetCard(0x3dc6) and c:IsAttack(0) and c:IsAbleToGrave() and c:IsFaceup()
end
function c16310060.filter2(c)
	return c:IsSetCard(0x3dc6) and c:IsDefense(0) and c:IsAbleToGrave() and c:IsFaceup()
end
function c16310060.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3dc6) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c16310060.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c16310060.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c16310060.repval(e,c)
	return c16310060.repfilter(c,e:GetHandlerPlayer())
end
function c16310060.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end