--逆元构造 黎明
function c79029804.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,3,c79029804.lcheck)
	c:EnableReviveLimit() 
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029804,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,79029804)
	e2:SetCost(c79029804.descost)
	e2:SetTarget(c79029804.destg)
	e2:SetOperation(c79029804.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79029804.atkcon)
	e3:SetValue(1500)
	c:RegisterEffect(e3)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetCondition(c79029804.atkcon)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c79029804.atkcon)
	e5:SetValue(aux.indoval)
	c:RegisterEffect(e5)
end
function c79029804.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xa991)
end
function c79029804.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true 
end
function c79029804.costfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c79029804.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then 
		if e:GetLabel()~=100 then 
			e:SetLabel(0) 
			return false
		end
		return Duel.GetMatchingGroupCount(c79029804.costfilter,tp,LOCATION_MZONE,0,nil)>0 and dg:GetCount()>0 
	end
	e:SetLabel(0)
	local cg=Duel.SelectMatchingCard(tp,c79029804.costfilter,tp,LOCATION_MZONE,0,1,dg:GetCount(),nil)
	local dct=Duel.SendtoGrave(cg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,dct,tp,LOCATION_ONFIELD)
	e:SetValue(dct)
end
function c79029804.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dct=e:GetValue()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local dg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,dct,dct,nil)
	if #dg>0 then
		Duel.HintSelection(dg)
		local tc=dg:GetFirst()
		while tc do 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=dg:GetNext()
		end
	end
end
function c79029804.cfilter(c)
	return c:GetSequence()<5
end
function c79029804.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c79029804.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end