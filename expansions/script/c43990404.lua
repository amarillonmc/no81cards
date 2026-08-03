--N公司 破灭凶弹
function c43990404.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,43990404)
	e1:SetCondition(c43990404.discon)
	e1:SetTarget(c43990404.distg)
	e1:SetOperation(c43990404.disop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)--TIMING_END_PHASE
	e2:SetDescription(aux.Stringid(43990404,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,43990404+1)
	e2:SetTarget(c43990404.destg)
	e2:SetOperation(c43990404.desop)
	c:RegisterEffect(e2)
end
function c43990404.discon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x3510) and p==tp and rp==1-tp
end
function c43990404.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c43990404.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 and c:IsRelateToChain() then
		Duel.BreakEffect()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c43990404.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c43990404.actop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x3510) and ep==tp then Duel.SetChainLimit(c43990404.chainlm) end
end
function c43990404.chainlm(e,rp,tp)
	return tp==rp
end
function c43990404.desfilter(c)
	return (c:IsSetCard(0x3510) or c:IsRace(RACE_MACHINE)) and c:IsFaceup()
end
function c43990404.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c43990404.desfilter(chkc) end--
	if chk==0 then return Duel.IsExistingTarget(c43990404.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c43990404.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c43990404.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local res=tc:IsSetCard(0x3510) and tc:IsFaceup()
	if not tc:IsRelateToChain() or Duel.Destroy(tc,REASON_EFFECT)==0 or not res then return end
	local b1=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
	local b3=b1 and b2
	local b4=true
	if not (b1 or b2) then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(43990404,1)},
		{b2,aux.Stringid(43990404,2)},
		{b3,aux.Stringid(43990404,3)},
		{b4,aux.Stringid(43990404,0)})
	if op==4 then return end
	local dg=Group.CreateGroup()
	if op&1~=0 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
		dg:Merge(g)
	end
	if op&2~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(g)
		dg:Merge(g)
	end
	Duel.BreakEffect()
	Duel.Destroy(dg,REASON_EFFECT)
end
