--人理之诗 诉状箭书
function c22026360.initial_effect(c)
	aux.AddCodeList(c,22025820,22021020)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCondition(c22026360.descon)
	e1:SetTarget(c22026360.target)
	e1:SetOperation(c22026360.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c22026360.aegcon)
	e3:SetOperation(c22026360.aegop)
	c:RegisterEffect(e3)
end
function c22026360.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(22021020)
end
function c22026360.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22026360.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22026360.cfilter1,tp,LOCATION_ONFIELD,0,1,nil) or Duel.IsExistingMatchingCard(c22026360.cfilter2,tp,LOCATION_MZONE,0,2,nil)
end
function c22026360.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c22026360.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c22026360.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c22026360.aegcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==tp and re:GetHandler():IsCode(22025820) and Duel.GetFlagEffect(tp,22026360)==0 and c:IsAbleToRemove()
		 and Duel.IsExistingMatchingCard(c22026360.filter,tp,0,LOCATION_ONFIELD,1,c)
end
function c22026360.aegop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(22026360,0)) then
		Duel.Hint(HINT_CARD,0,22026360)
		local sg=Duel.GetMatchingGroup(c22026360.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		Duel.Destroy(sg,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,22026360,RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(22026360,1))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,tp)
	end
end
