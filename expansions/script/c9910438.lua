--始祖龙的羽庇
function c9910438.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c9910438.target)
	e1:SetOperation(c9910438.activate)
	c:RegisterEffect(e1)
end
function c9910438.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if chkc then return false end
	if chk==0 then return g:CheckSubGroup(aux.drccheck,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=g:SelectSubGroup(tp,aux.drccheck,false,2,#g)
	Duel.SetTargetCard(sg)
end
function c9910438.filter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c9910438.adfilter(c,f)
	return math.max(f(c),0)
end
function c9910438.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c9910438.filter,nil,e)
	if #tg==0 then return end
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c9910438.efilter)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
	if #tg<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910438,0))
	local sc=tg:Select(tp,1,1,nil):GetFirst()
	if not sc then return end
	tg:RemoveCard(sc)
	if #tg==0 then return end
	local atk=tg:GetSum(c9910438.adfilter,Card.GetAttack)
	local def=tg:GetSum(c9910438.adfilter,Card.GetDefense)
	if sc:IsFaceup() and sc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(def)
		sc:RegisterEffect(e2)
	end
end
function c9910438.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
