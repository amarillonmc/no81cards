--骇骨龙 阴骇幽灵
function c35399009.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35399009,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,35399009)
	e1:SetCondition(c35399009.con1)
	e1:SetCost(c35399009.cost1)
	e1:SetTarget(c35399009.tg1)
	e1:SetOperation(c35399009.op1)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35399009,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,35399010)
	e2:SetCondition(c35399009.con2)
	e2:SetTarget(c35399009.tg2)
	e2:SetOperation(c35399009.op2)
	c:RegisterEffect(e2)
	local e2_1=e2:Clone()
	e2_1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2_1)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35399009,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,35399011)
	e3:SetTarget(c35399009.tg3)
	e3:SetOperation(c35399009.op3)
	c:RegisterEffect(e3)
--
end
--
function c35399009.con1(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return rp~=tp and (loc&(LOCATION_HAND+LOCATION_GRAVE))~=0
end
function c35399009.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c35399009.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(re:GetHandler():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,rc,1,0,0)
end
function c35399009.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetCode(EFFECT_DISABLE)
	e1_1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1_1:SetTarget(c35399009.tg1_1)
	e1_1:SetLabel(e:GetLabel())
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_1,tp)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_2:SetCode(EVENT_CHAIN_SOLVING)
	e1_2:SetCondition(c35399009.con1_2)
	e1_2:SetOperation(c35399009.op1_2)
	e1_2:SetLabel(e:GetLabel())
	e1_2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_2,tp)
end
function c35399009.tg1_1(e,c)
	local code=e:GetLabel()
	return c:IsCode(code) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c35399009.con1_2(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsCode(code)
end
function c35399009.op1_2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
--
function c35399009.cfilter2(c)
	return c:IsFaceup() and c:GetLevel()>=7
end
function c35399009.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c35399009.cfilter2,1,nil)
end
function c35399009.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c35399009.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c35399009.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c35399009.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAbleToHand() then
		Duel.SendtoHand(c,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
--