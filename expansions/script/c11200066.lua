--兔☆兔
function c11200066.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c11200066.FusFilter,2,true)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200066,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_LEAVE_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,11200066)
	e1:SetCondition(c11200066.con1)
	e1:SetTarget(c11200066.tg1)
	e1:SetOperation(c11200066.op1)
	c:RegisterEffect(e1)
	e2=e1:Clone()
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c11200066.con2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11200066,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c11200066.op3)
	c:RegisterEffect(e3)
--
end
--
function c11200066.FusFilter(c)
	return c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
--
function c11200066.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION)
		and c:GetMaterialCount()>0
end
function c11200066.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION)
end
--
function c11200066.tfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand() and c:GetLevel()<5
end
function c11200066.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c11200066.tfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
--
function c11200066.ofilter1(c,tc)
	return c:IsCode(tc:GetCode()) and c:IsAbleToRemove()
end
function c11200066.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c11200066.tfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if tg:GetCount()<1 then return end
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	local off=1
	local ops={}
	local opval={}
	local b1=Duel.IsExistingMatchingCard(c11200066.ofilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tg:GetFirst())
	local b2=true
	if b1 then
		ops[off]=aux.Stringid(11200066,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(11200066,2)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local lg=Duel.SelectMatchingCard(tp,c11200066.ofilter1,tp,  LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tg:GetFirst())
		if lg:GetCount()<1 then return end
		Duel.Remove(lg,POS_FACEUP,REASON_EFFECT)
	end
	if sel==2 then
		if Duel.GetFlagEffect(tp,11200066)~=0 then return end
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetDescription(aux.Stringid(11200066,2))
		e1_1:SetType(EFFECT_TYPE_FIELD)
		e1_1:SetTargetRange(LOCATION_HAND,0)
		e1_1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1_1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_BEAST))
		e1_1:SetValue(0x1)
		e1_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_1,tp)
		Duel.RegisterFlagEffect(tp,11200066,RESET_PHASE+PHASE_END,0,1)
	end
end
--
function c11200066.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,11200066)==0 then
		local e3_1=Effect.CreateEffect(e:GetHandler())
		e3_1:SetDescription(aux.Stringid(11200066,3))
		e3_1:SetType(EFFECT_TYPE_FIELD)
		e3_1:SetTargetRange(LOCATION_HAND,0)
		e3_1:SetCode(EFFECT_SUMMON_PROC)
		e3_1:SetCountLimit(1)
		e3_1:SetCondition(c11200066.con3_1)
		e3_1:SetTarget(c11200066.tg3_1)
		e3_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3_1,tp)
		Duel.RegisterFlagEffect(tp,11200066,RESET_PHASE+PHASE_END,0,1)
	end
end
--
function c11200066.con3_1(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c11200066.tg3_1(e,c)
	return c:IsLevelAbove(5) and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
--
