--匪魔追缉者 受洗捍法士
function c9910188.initial_effect(c)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c9910188.thtg)
	e1:SetOperation(c9910188.thop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c9910188.rmcost)
	e2:SetTarget(c9910188.rmtg)
	e2:SetOperation(c9910188.rmop)
	c:RegisterEffect(e2)
	if not c9910188.global_check then
		c9910188.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c9910188.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(c9910188.checkop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAIN_SOLVED)
		ge3:SetOperation(c9910188.checkop1)
		Duel.RegisterEffect(ge3,0)
	end
end
function c9910188.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) or not re:IsActiveType(TYPE_MONSTER) then return end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if (LOCATION_MZONE+LOCATION_GRAVE)&loc==0 then return end
	if rc:GetFlagEffect(9910188)==0 then
		rc:RegisterFlagEffect(9910188,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
	else
		local flag=rc:GetFlagEffectLabel(9910188)
		if flag then rc:SetFlagEffectLabel(9910188,flag+1) end
	end
end
function c9910188.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) or not re:IsActiveType(TYPE_MONSTER) then return end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if (LOCATION_MZONE+LOCATION_GRAVE)&loc==0 or rc:GetFlagEffect(9910188)==0 then return end
	local flag=rc:GetFlagEffectLabel(9910188)
	if flag==1 then
		rc:ResetFlagEffect(9910188)
	elseif flag then
		rc:SetFlagEffectLabel(9910188,flag-1)
	end
end
function c9910188.thfilter(c)
	return c:IsSetCard(0x3954) and c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function c9910188.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910188.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c9910188.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910188.thfilter),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		Duel.RegisterFlagEffect(tp,tc:GetOriginalCode()+10000,0,0,1)
	end
end
function c9910188.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function c9910188.rmfilter(c)
	return c:IsFaceupEx() and c:GetFlagEffect(9910188)>0 and not c:IsRace(RACE_WARRIOR) and c:IsAbleToRemove()
end
function c9910188.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910188.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	local sg=Duel.GetMatchingGroup(c9910188.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
end
function c9910188.rmop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c9910188.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	if #sg>0 then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
