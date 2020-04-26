--韶光歌后 玛丽亚·毕肖普
function c9910457.initial_effect(c)
	c:EnableCounterPermit(0x950)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9950),c9910457.matfilter,2,63,true)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9910457.adcon)
	e1:SetOperation(c9910457.adop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9910457.discon)
	e2:SetCost(c9910457.discost)
	e2:SetTarget(c9910457.distg)
	e2:SetOperation(c9910457.disop)
	c:RegisterEffect(e2)
	--remove counter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9910457.rctcon)
	e3:SetTarget(c9910457.rcttg)
	e3:SetOperation(c9910457.rctop)
	c:RegisterEffect(e3)
end
function c9910457.matfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsFusionType(TYPE_EFFECT)
end
function c9910457.adcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION 
end
function c9910457.cfilter(c,loc)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetSummonLocation()==loc
end
function c9910457.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=0
	if c:GetMaterial():IsExists(c9910457.cfilter,1,nil,LOCATION_HAND) then ct=ct+1 end
	if c:GetMaterial():IsExists(c9910457.cfilter,1,nil,LOCATION_DECK) then ct=ct+1 end
	if c:GetMaterial():IsExists(c9910457.cfilter,1,nil,LOCATION_GRAVE) then ct=ct+1 end
	if c:GetMaterial():IsExists(c9910457.cfilter,1,nil,LOCATION_EXTRA) then ct=ct+1 end
	if c:GetMaterial():IsExists(c9910457.cfilter,1,nil,LOCATION_REMOVED) then ct=ct+1 end
	if c:GetMaterial():IsExists(c9910457.cfilter,1,nil,LOCATION_SZONE) then ct=ct+1 end
	if ct>0 and c:IsCanAddCounter(0x950,ct) then
		Duel.Hint(HINT_CARD,0,9910457)
		c:AddCounter(0x950,ct)
	end
end
function c9910457.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c9910457.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x950,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x950,1,REASON_COST)
end
function c9910457.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9910457.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c9910457.rctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c9910457.rcttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not e:GetHandler():IsCanRemoveCounter(tp,0x950,1,REASON_EFFECT) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	end
end
function c9910457.rctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if c:IsCanRemoveCounter(tp,0x950,1,REASON_EFFECT) then
			c:RemoveCounter(tp,0x950,1,REASON_EFFECT)
		else
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end
