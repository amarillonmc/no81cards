--方舟騎士·水灵漫步者 锡兰
function c82567836.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--plimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c82567836.pcon)
	e2:SetTarget(c82567836.splimit)
	c:RegisterEffect(e2)
	--spsummon proc
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetCountLimit(1,82567836+EFFECT_COUNT_CODE_OATH)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c82567836.spcon)
	c:RegisterEffect(e3)
	--AddCounter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82567796,2))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,82567836)
	e4:SetCondition(c82567836.ctcon)
	e4:SetCost(c82567836.ctcost)
	e4:SetTarget(c82567836.cttg)
	e4:SetOperation(c82567836.ctop)
	c:RegisterEffect(e4)
	--effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e5:SetCondition(c82567836.efcon)
	e5:SetOperation(c82567836.efop)
	c:RegisterEffect(e5)
end
function c82567836.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c82567836.pcon(e,c,tp,sumtp,sumpos)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x5825)==0
end
function c82567836.tunerfilter(c,e,tp)
	return c:IsSetCard(0x825)
		and c:IsLevel(3) and c:IsType(TYPE_TUNER) and c:IsFaceup()
end 
function c82567836.spcon(e,c,tp)
	if c==nil then return true end
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c82567836.tunerfilter,tp,LOCATION_MZONE,0,1,nil)
	 and  Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	  and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c82567836.filter(c)
	return c:IsSetCard(0x825) and c:IsFaceup()
end
function c82567836.costfilter(c)
	return c:IsDiscardable()
end
function c82567836.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82567836.filter,tp,LOCATION_MZONE,0,1,nil)
				and Duel.IsExistingMatchingCard(c82567836.costfilter,tp,LOCATION_HAND,0,1,nil)
end
function c82567836.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567836.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c82567836.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c82567836.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsSetCard(0x825) and chkc:IsFaceup() and chkc:IsCanAddCounter(0x5825,1) end
	if chk==0 then return Duel.IsExistingTarget(c82567836.filter,tp,LOCATION_MZONE,0,1,nil,0x5825,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82567836.filter,tp,LOCATION_MZONE,0,1,3,nil,0x5825,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,nil,0x5825,1)
end
	
function c82567836.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	  while tc and tc:IsRelateToEffect(e) do	
	  tc:AddCounter(0x5825,1)
	 tc=g:GetNext()
   end
end
function c82567836.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsSetCard(0x825)
end
function c82567836.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	 local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetValue(c82567836.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		rc:RegisterEffect(e1)
end
function c82567836.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
		and te:IsActiveType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER)
end