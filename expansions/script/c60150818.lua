--死神·死亡本能
function c60150818.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3b23),3)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c60150818.linklimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c60150818.condition)
	e2:SetOperation(c60150818.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_ACTIVATING)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c60150818.damcon)
	e4:SetOperation(c60150818.damop)
	c:RegisterEffect(e4)
	--die
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(c60150818.descon)
	e8:SetCost(c60150818.descost)
	e8:SetTarget(c60150818.destg)
	e8:SetOperation(c60150818.desop)
	c:RegisterEffect(e8)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c60150818.e5con)
	e5:SetValue(c60150818.efilter)
	c:RegisterEffect(e5)
end
function c60150818.linklimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c60150818.cfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c60150818.ccfilter(c)
	return c:IsType(TYPE_XYZ)
end
function c60150818.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	return eg:IsExists(c60150818.cfilter,1,nil,1-tp) and g:FilterCount(c60150818.ccfilter,nil)>0
end
function c60150818.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60150818)
	local tc=eg:GetFirst()
	while tc do
		local dm=tc:GetLevel()
		local dm2=tc:GetRank()
		if tc:GetSummonLocation()==LOCATION_EXTRA then
			local g=Duel.GetLP(1-tp)
			Duel.SetLP(1-tp,g-(dm+dm2)*200)
		else
			local g=Duel.GetLP(1-tp)
			Duel.SetLP(1-tp,g-(dm+dm2)*100)
		end
		tc=eg:GetNext()
	end
end
function c60150818.damcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and g:FilterCount(c60150818.ccfilter,nil)>0
end
function c60150818.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60150818)
	local rc=re:GetHandler()
	local dm=rc:GetLevel()
	local dm2=rc:GetRank()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if (loc==LOCATION_HAND or loc==LOCATION_DECK or loc==LOCATION_OVERLAY 
		or loc==LOCATION_GRAVE or loc==LOCATION_REMOVED or loc==LOCATION_EXTRA) then
		local g=Duel.GetLP(1-tp)
		Duel.SetLP(1-tp,g-(dm+dm2)*200)
	else
		local g=Duel.GetLP(1-tp)
		Duel.SetLP(1-tp,g-(dm+dm2)*100)
	end
end
function c60150818.filter(c)
	return c:IsFaceup() and c:GetBaseAttack()>0 and c:IsSetCard(0x3b23)
end
function c60150818.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	return Duel.GetTurnPlayer()==tp and g:FilterCount(c60150818.ccfilter,nil)>0
end
function c60150818.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c60150818.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c60150818.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60150818.filter,tp,LOCATION_MZONE,0,nil)
	local atk=g:GetSum(Card.GetBaseAttack)
	local lp=Duel.GetLP(1-tp)
	if lp>atk then
		Duel.SetLP(1-tp,lp-atk)
	else
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150818,0))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150818,1))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150818,2))
		Duel.SelectOption(1-tp,aux.Stringid(60150818,3))
		Duel.Hint(HINT_CARD,0,60150818)
		Duel.SetLP(1-tp,0)
	end
end
function c60150818.e5con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c60150818.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end