--宛如流星
function c29010016.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c29010016.acon)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(29010016,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c29010016.dstg) 
	e1:SetOperation(c29010016.dsop) 
	c:RegisterEffect(e1) 
	local e4=e1:Clone()
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(c29010016.gravecost)
	c:RegisterEffect(e4)
	--Activate(effect)
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(29010016,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c29010016.negcon)
	e2:SetTarget(c29010016.negtg)
	e2:SetOperation(c29010016.negop)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(c29010016.gravecost)
	c:RegisterEffect(e5)
	--Activate(summon)
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(29010016,2))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_SUMMON)
	e3:SetCondition(c29010016.disscon)
	e3:SetTarget(c29010016.disstg)
	e3:SetOperation(c29010016.dissop)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCost(c29010016.gravecost)
	c:RegisterEffect(e6)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
	local e7=e4:Clone()
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCost(c29010016.gravecost)
	c:RegisterEffect(e7)
end
function c29010016.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c29010016.acon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c29010016.cfilter,0,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c29010016.cfilter,1,LOCATION_MZONE,0,1,nil)
end
function c29010016.dstg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD) 
end 
function c29010016.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,1,nil) 
	if g:GetCount()>0 then 
	local dg=g:Select(tp,1,1,nil) 
	Duel.Destroy(dg,REASON_EFFECT)
		if Duel.GetFlagEffect(tp,29010016)==1 then
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ResetFlagEffect(tp,29010016)
		end
	end 
end 
function c29010016.excon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c29010016.cfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetOriginalCodeRule)>=3
end
function c29010016.negcon(e,tp,eg,ep,ev,re,r,rp)
	return c29010016.excon(e,tp) and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)) and Duel.IsChainNegatable(ev) and rp==1-tp 
end
function c29010016.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c29010016.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
			if Duel.GetFlagEffect(tp,29010016)==1 then
			c:CancelToGrave()
			Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			Duel.ResetFlagEffect(tp,29010016)
		end
	end
end
function c29010016.disscon(e,tp,eg,ep,ev,re,r,rp)
	return c29010016.excon(e,tp) and Duel.GetCurrentChain()==0 and eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c29010016.disstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c29010016.dissop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
		if Duel.GetFlagEffect(tp,29010016)==1 then
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ResetFlagEffect(tp,29010016)
		end
end
function c29010016.gravecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerAffectedByEffect(tp,29010026) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetFlagEffect(tp,29010026)==0 end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.RegisterFlagEffect(tp,29010026,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,29010016,RESET_PHASE+PHASE_END,0,1)
end