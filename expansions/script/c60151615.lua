--来自虚无中的希望 鹿目圆香
function c60151615.initial_effect(c)
	c:SetUniqueOnField(1,1,60151615)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c60151615.xyzcon)
	e1:SetOperation(c60151615.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--Atk update
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c60151615.setcon)
	e2:SetValue(c60151615.val)
	c:RegisterEffect(e2)
	--inactivatable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c60151615.setcon)
	e3:SetValue(c60151615.efilter)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(c60151615.setcon)
	e4:SetTarget(c60151615.destg)
	e4:SetOperation(c60151615.desop)
	c:RegisterEffect(e4)
	--destroy replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c60151615.reptg)
	c:RegisterEffect(e7)
end
function c60151615.spfilter(c,sc)
	return c:IsSetCard(0xcb25) and c:IsFaceup() and c:IsType(TYPE_XYZ+TYPE_SYNCHRO) and c:IsCanBeXyzMaterial(sc)
end
function c60151615.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c60151615.spfilter,tp,LOCATION_MZONE,0,3,nil)
end
function c60151615.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c60151615.spfilter,tp,LOCATION_MZONE,0,3,3,nil)
	local tc=g:GetFirst()
	local sg=Group.CreateGroup()
	while tc do
		sg:Merge(tc:GetOverlayGroup())
		tc=g:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c60151615.confilter(c)
	return c:IsSetCard(0xcb25) and c:IsType(TYPE_MONSTER) 
end
function c60151615.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c60151615.confilter,1,nil)
end
function c60151615.val(e,c)
	return math.abs(Duel.GetLP(0)-Duel.GetLP(1))
end
function c60151615.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_MONSTER) and tc:IsSetCard(0xcb25) 
		and (tc:IsLocation(LOCATION_HAND) or (tc:IsLocation(LOCATION_EXTRA) and tc:IsFaceup()))
end
function c60151615.filter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) and c:IsAbleToGrave()
end
function c60151615.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local atk=(math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp)))
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return Duel.IsExistingMatchingCard(c60151615.filter,tp,0,LOCATION_MZONE,1,nil,atk) and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) end
	local g=Duel.GetMatchingGroup(c60151615.filter,tp,0,LOCATION_MZONE,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c60151615.desop(e,tp,eg,ep,ev,re,r,rp)
	local atk=(math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp)))
	local g=Duel.GetMatchingGroup(c60151615.filter,tp,0,LOCATION_MZONE,nil,atk)
	Duel.SendtoGrave(g,REASON_RULE)
end
function c60151615.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(60151615,1)) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		local lp1=Duel.GetLP(tp)
		local lp2=Duel.GetLP(1-tp)
		if lp1<lp2 then
			Duel.SetLP(tp,lp2)
			Duel.SetLP(1-tp,lp1)
		end
		return true
	else return false end
end