--纯白的一等星 爱之誓言
function c28366501.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,28366501+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c28366501.target)
	e1:SetOperation(c28366501.activate)
	c:RegisterEffect(e1)
	--illumination maho
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c28366501.reptg)
	e2:SetValue(c28366501.repval)
	c:RegisterEffect(e2)
	--illumination SetCode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetValue(0x283)
	c:RegisterEffect(e3)
end
function c28366501.thfilter(c)
	return c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28366501.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28366501.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1800)
end
function c28366501.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28366501.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.Recover(tp,1800,REASON_EFFECT)
		--limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetOperation(c28366501.checkop)
		e1:SetLabel(tc:GetOriginalCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c28366501.cfilter0(c,tp,code)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_EXTRA) and c:GetMaterial():IsExists(Card.IsOriginalCodeRule,1,nil,code)
end
function c28366501.cfilter1(c,tp,code)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_EXTRA) and not c:GetMaterial():IsExists(Card.IsOriginalCodeRule,1,nil,code)
end
function c28366501.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c28366501.cfilter0,1,nil,tp,e:GetLabel()) then
		e:Reset()
	elseif eg:IsExists(c28366501.cfilter1,1,nil,tp,e:GetLabel()) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c28366501.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c28366501.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end
function c28366501.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x284) and eg:IsContains(c) and (c:IsAbleToHand() or (re:GetHandler():IsFaceupEx() and (re:GetHandler():IsLevelAbove(1) or re:GetHandler():IsRankAbove(1)))) end
	if c:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(28366501,0)) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_DECK_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_HAND)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		--c:RegisterFlagEffect(28366501,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_TO_HAND)
		e2:SetCountLimit(1)
		e2:SetOperation(c28366501.chkop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOHAND+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		return true
	else
		local rc=re:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		rc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RANK)
		rc:RegisterEffect(e2)
	return false end
end
function c28366501.repval(e,c)
	return false
end
function c28366501.chkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.ShuffleHand(tp)
end
