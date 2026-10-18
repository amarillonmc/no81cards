function c4875137.initial_effect(c)
	c:EnableCounterPermit(0x52)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,6)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4875137,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c4875137.ctcon)
	e1:SetTarget(c4875137.cttg)
	e1:SetOperation(c4875137.ctop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,4875137)
	e2:SetCondition(c4875137.spcon1)
	e2:SetOperation(c4875137.spop)
	e2:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e2)
	   local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4875137,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c4875137.discon)
	e3:SetCost(c4875137.discost)
	e3:SetTarget(c4875137.distg)
	e3:SetOperation(c4875137.disop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4875137,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c4875137.dacon)
	e4:SetCost(c4875137.discost)
	e4:SetOperation(c4875137.daop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(4875137,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e4:SetCondition(c4875137.spcon)
	e5:SetCost(c4875137.spcost1)
	e5:SetTarget(c4875137.sptg1)
	e5:SetOperation(c4875137.spop1)
	c:RegisterEffect(e5)
end
function c4875137.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c4875137.cfilter2,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLP(tp)<=Duel.GetLP(1-tp)-4000
end
function c4875137.cfilter2(c,e,tp,ec)
	return c:IsCode(5043010) and c:IsFaceup()
end
function c4875137.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function c4875137.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()  end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c4875137.spfilter1(c,e,tp,ec)
	return c:IsCode(5043010) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c4875137.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4875137.spfilter1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c4875137.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c4875137.spfilter1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,tc):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,nil,tp,tp,false,false,POS_FACEUP)
	end
end
function c4875137.dacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE_STEP and e:GetHandler():GetAttackedCount()~=0
		and Duel.GetAttacker()==nil and Duel.GetCurrentChain()==0
end
function c4875137.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c4875137.chainlm(e,ep,tp)
	return tp==ep
end
function c4875137.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c4875137.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x52,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x52,1,REASON_COST)
end
function c4875137.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c4875137.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c4875137 .efilter(e,re)
	return re:GetOwner()~=e:GetOwner()
end
function c4875137.cfilter1(c)
	return c:IsType(TYPE_LINK) and c:IsAbleToRemove()
end
function c4875137.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c4875137.cfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	if #g==0 then return end
	Duel.Release(g,REASON_COST)
end
function c4875137.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c4875137.cfilter(c)
	return c:IsType(TYPE_LINK) and c:IsAbleToExtra() and c:IsFaceup()
end
function c4875137.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c4875137.cfilter,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return g:GetCount()>=2 end
	 Duel.SetChainLimit(c4875137.chainlm)
end
function c4875137.ctop(e,tp,eg,ep,ev,re,r,rp)
	   local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c4875137.cfilter,tp,LOCATION_REMOVED,0,2,99,nil)
	if #g==0 then return end
	local num=Duel.SendtoDeck(g,tp,1,REASON_EFFECT)
	num=math.floor(num/2)
	if num<1 then return end
	local atk=num*2000
	if atk>0 then
	 local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e1:SetValue(atk)
			c:RegisterEffect(e1)
			end
	c:AddCounter(0x52,num)
end