--天空漫步者-惊人得分
function c9910223.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e1:SetCondition(c9910223.condition)
	e1:SetCost(c9910223.cost)
	e1:SetTarget(c9910223.target)
	e1:SetOperation(c9910223.activate)
	c:RegisterEffect(e1)
end
function c9910223.cfilter(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsRace(RACE_PSYCHO))
end
function c9910223.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9910223.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910223.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c9910223.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckLPCost(tp,100) and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	local maxlp=2000
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCurrentChain()>2 then
		maxlp=3000
		Duel.SetChainLimit(c9910223.chainlm)
	end
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,maxlp)/100)
	local t={}
	for i=1,m do
		t[i]=i*100
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	e:SetLabel(ac)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c9910223.chainlm(e,rp,tp)
	return tp==rp
end
function c9910223.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ac=e:GetLabel()
	if not tc:IsRelateToEffect(e) or not tc:IsFaceup() then return end
	if tc:IsAttackAbove(ac) and Duel.SelectOption(tp,aux.Stringid(9910223,0),aux.Stringid(9910223,1))==1 then
		ac=-1*ac
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ac)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local atkb=tc:GetBaseAttack()
	local atkn=tc:GetAttack()
	if atkn==0 or (atkb>0 and math.fmod(atkn,atkb)==0) then
		Duel.BreakEffect()
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
	end
end
