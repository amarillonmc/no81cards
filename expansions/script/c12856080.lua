--塔尔塔罗斯 无上之溟渤波塞冬
function c12856080.initial_effect(c)
	c:SetSPSummonOnce(12856080)
	c:SetCounterLimit(0xa7d,12)
	c:EnableCounterPermit(0xa7d)
	--xyz
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsXyzType,TYPE_RITUAL),12,2,c12856080.ovfilter,aux.Stringid(12856080,0),2,c12856080.xyzop)
	c:EnableReviveLimit()
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c12856080.regcon)
	e1:SetOperation(c12856080.regop)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c12856080.acop)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c12856080.immcon)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3a7d))
	e4:SetValue(c12856080.immval)
	c:RegisterEffect(e4)
c12856080.SetRarity_UTR=true
end
function c12856080.ovfilter(c)
	return c:IsSetCard(0x3a7d) and c:IsXyzType(TYPE_RITUAL) and c:IsFaceup()
end
function c12856080.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xa7d,12,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xa7d,12,REASON_COST)
end
function c12856080.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c12856080.cfilter(c)
	return c:IsSetCard(0x3a7d) and c:IsXyzType(TYPE_RITUAL) and c:IsLevelAbove(1)
end
function c12856080.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	if c:IsCanAddCounter(0xa7d,1) and og:IsExists(c12856080.cfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(12856080,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
		local sg=og:FilterSelect(tp,c12856080.cfilter,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		local tc=Duel.GetOperatedGroup():GetFirst()
		c:AddCounter(0xa7d,tc:GetLevel())
	end
end
function c12856080.acop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0xa7d,1)
	end
end
function c12856080.immcon(e)
	return Duel.GetCounter(e:GetHandlerPlayer(),LOCATION_ONFIELD,0,0xa7d)>=24
end
function c12856080.immval(e,re)
	return re:IsActivated() and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
