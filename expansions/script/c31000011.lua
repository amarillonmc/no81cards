--Fallacio Paralogos
function c31000011.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c31000011.spcon)
	e1:SetCost(c31000011.spcst)
	e1:SetTarget(c31000011.sptg)
	e1:SetOperation(c31000011.spop)
	c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c31000011.target)
	e2:SetOperation(c31000011.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--Search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(c31000011.tg)
	e5:SetOperation(c31000011.op)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(31000011,ACTIVITY_SUMMON,c31000011.counterfilter)
	Duel.AddCustomActivityCounter(31000011,ACTIVITY_SPSUMMON,c31000011.counterfilter)
end

function c31000011.counterfilter(c)
	return c:IsSetCard(0x308) or not c:IsPreviousLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end

function c31000011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(31000011,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(31000011,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c31000011.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end

function c31000011.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x308) and c:IsLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end

function c31000011.spcon(e,tp,eg,ep,ev,re,r,rp)
	local spfilter=function(c)
		return c:IsSetCard(0x308) and not c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
	end
	local altfilter=function(c)
		return not c:IsSetCard(0x308) or c:IsAttribute(ATTRIBUTE_DARK)
	end
	return Duel.IsExistingMatchingCard(spfilter,tp,LOCATION_MZONE,nil,1,nil)
		and not Duel.IsExistingMatchingCard(altfilter,tp,LOCATION_MZONE,nil,1,nil)
end

function c31000011.spcst(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil)
		and c31000011.cost(e,tp,eg,ep,ev,re,r,rp,0) end
	local sg=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(sg,REASON_COST)
	c31000011.cost(e,tp,eg,ep,ev,re,r,rp)
end

function c31000011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c31000011.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c31000011.spfilter(c)
	return c:IsSetCard(0x308)
end

function c31000011.opfilter(c)
	return c:IsSetCard(0x308) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end

function c31000011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c31000011.cost(e,tp,eg,ep,ev,re,r,rp,0) end
	c31000011.cost(e,tp,eg,ep,ev,re,r,rp)
end

function c31000011.immtg(e,c)
	return c31000011.spfilter(c)
end

function c31000011.immval(e,te)
	local tp=te:GetOwner():GetControler()
	return tp~=e:GetHandler():GetControler() and te:IsActiveType(TYPE_MONSTER)
end

function c31000011.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTarget(c31000011.immtg)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c31000011.immval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c31000011.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31000011.opfilter,tp,LOCATION_DECK,nil,1,nil)
		and c31000011.cost(e,tp,eg,ep,ev,re,r,rp,0) end
	c31000011.cost(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end

function c31000011.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c31000011.opfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc and Duel.IsPlayerCanSendtoHand(tp,tc) then
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
