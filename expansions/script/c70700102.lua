--沃伊 真赖欧一
function c70700102.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70700102,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c70700102.cost)
	e1:SetTarget(c70700102.target)
	e1:SetOperation(c70700102.activate)
	c:RegisterEffect(e1)
	--remain field
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e0)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70700102,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,70700102)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c70700102.sptg)
	e2:SetOperation(c70700102.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(70700102,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c70700102.spcon2)
	e3:SetTarget(c70700102.sptg2)
	e3:SetOperation(c70700102.spop2)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(70700102,3))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c70700102.econ)
	e4:SetValue(c70700102.efilter)
	c:RegisterEffect(e4)
	--ignition effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(70700102,4))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c70700102.econ)
	e5:SetTarget(c70700102.ietg)
	e5:SetOperation(c70700102.ieop)
	c:RegisterEffect(e5)
	--clienthint
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(c70700102.clienthint)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(70700102,ACTIVITY_CHAIN,c70700102.chainfilter)
end
function c70700102.clienthint(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(70700102,3))
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(70700102,4))
	c:RegisterEffect(e2,true)
end
function c70700102.chainfilter(re,tp,cid)
	return not re:GetHandler():IsCode(70700102)
end
function c70700102.filter(c,loc)
	if loc==nil then 
		return c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand() and c:IsSetCard(0x901) and not c:IsCode(70700102)
	else 
		return c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
	end
end
function c70700102.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(70700102,tp,ACTIVITY_CHAIN)==0 end
end
function c70700102.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c70700102.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c70700102.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c70700102.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c70700102.spfilter(c,e)
	return not c:IsImmuneToEffect(e)
end
function c70700102.spcheck(sg,e,tp)
	return (#sg==2 and sg:FilterCount(Card.IsControler,nil,1-tp)<=1 and Duel.GetMZoneCount(tp,sg)>0 and sg:IsExists(Card.IsType,1,e:GetHandler(),TYPE_SPELL))
end
function c70700102.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		local mg=Duel.GetMatchingGroup(c70700102.spfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_MZONE,e:GetHandler(),e)
		return Duel.IsPlayerCanSpecialSummonMonster(tp,70700102,0x901,0x21,3000,3300,10,RACE_REPTILE,ATTRIBUTE_FIRE) 
		and mg:CheckSubGroup(c70700102.spcheck,2,2,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c70700102.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c70700102.spfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_MZONE,e:GetHandler(),e)
	if not mg:CheckSubGroup(c70700102.spcheck,2,2,e,tp) then return end
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,70700102,0x901,0x21,3000,3300,10,RACE_REPTILE,ATTRIBUTE_FIRE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=mg:SelectSubGroup(tp,c70700102.spcheck,false,2,2,e,tp)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RELEASE)
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY)
		c:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_REPTILE)
		c:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_FIRE)
		c:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_LEVEL)
		e4:SetValue(10)
		c:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_ATTACK)
		e5:SetValue(3000)
		c:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_SET_BASE_DEFENSE)
		e6:SetValue(3300)
		c:RegisterEffect(e6,true)
		Duel.SpecialSummonComplete()
	end
end
function c70700102.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c70700102.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,70700102,0x901,0x21,3300,3000,10,RACE_REPTILE,ATTRIBUTE_FIRE) 
		and Duel.GetFlagEffect(tp,70700102)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.RegisterFlagEffect(tp,70700102,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c70700102.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,70700102,0x901,0x21,3300,3000,10,RACE_REPTILE,ATTRIBUTE_FIRE) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY)
		c:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_REPTILE)
		c:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_FIRE)
		c:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_LEVEL)
		e4:SetValue(10)
		c:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_ATTACK)
		e5:SetValue(3000)
		c:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_SET_BASE_DEFENSE)
		e6:SetValue(3300)
		c:RegisterEffect(e6,true)
		Duel.SpecialSummonComplete()
	end
end
function c70700102.econ(e)
	local rc=e:GetHandler():GetReasonEffect():GetHandler()
	return rc:IsSetCard(0x901) and rc:IsType(TYPE_MONSTER) and e:GetHandler():IsType(TYPE_MONSTER)
end
function c70700102.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c70700102.ietg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c70700102.filter,tp,LOCATION_GRAVE,0,1,nil,LOCATION_GRAVE) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
end
function c70700102.ieop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c70700102.filter,tp,LOCATION_GRAVE,0,nil,LOCATION_GRAVE)
	if g:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
