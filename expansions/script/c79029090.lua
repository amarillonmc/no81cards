--拉特兰·狙击干员-送葬人
function c79029090.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--atk up 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c79029090.rmcon)
	e1:SetValue(1500)
	c:RegisterEffect(e1) 
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(c79029090.rmcon1)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)  
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79029090.rmcon1)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e4)
	--Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(3167573,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCountLimit(1)
	e5:SetCondition(c79029090.rmcon3)
	e5:SetTarget(c79029090.destg)
	e5:SetOperation(c79029090.desop1)
	c:RegisterEffect(e5)
	--hand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(95372220,0))
	e6:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,79029090)
	e6:SetCondition(c79029090.descon)
	e6:SetTarget(c79029090.destg)
	e6:SetOperation(c79029090.desop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
	--negate
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(17573739,0))
	e8:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e8:SetCode(EVENT_CHAINING)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(c79029090.rmcon2)
	e8:SetTarget(c79029090.negtg)
	e8:SetOperation(c79029090.negop)
	c:RegisterEffect(e8)
end
function c79029090.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroupCount()>=1
end
function c79029090.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroupCount()>=2
end
function c79029090.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroupCount()>=3
end
function c79029090.rmcon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroupCount()>=4
end
function c79029090.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c79029090.desop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c79029090.cfilter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return ec:GetLinkedGroup():IsContains(c)
	else
		return bit.band(ec:GetLinkedZone(c:GetPreviousControler()),bit.lshift(0x1,c:GetPreviousSequence()))~=0
	end
end
function c79029090.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029090.cfilter,1,nil,e:GetHandler())
end
function c79029090.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c79029090.desop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(p,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
end
function c79029090.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c79029090.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end


