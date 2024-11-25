--石刻龙 片麻岩
function c51927005.initial_effect(c)
	--Carved stone(earth)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,51927005)
	e1:SetCondition(c51927005.spcon)
	e1:SetTarget(c51927005.sptg)
	e1:SetOperation(c51927005.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,51927006)
	e2:SetCondition(c51927005.thcon)
	e2:SetTarget(c51927005.thtg)
	e2:SetOperation(c51927005.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--be material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCondition(c51927005.condition)
	e4:SetOperation(c51927005.operation)
	c:RegisterEffect(e4)
end
function c51927005.cfilter(c)
	return c:IsType(TYPE_EFFECT) and not c:IsSetCard(0x6256) and c:IsFaceup()
end
function c51927005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c51927005.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c51927005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c51927005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c51927005.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c51927005.thfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function c51927005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c51927005.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c51927005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c51927005.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c51927005.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return rc:IsSummonType(SUMMON_TYPE_ADVANCE) and rc:IsType(TYPE_NORMAL) and c:IsReason(REASON_RELEASE) and rc:IsFaceup()
end
function c51927005.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local rc=c:GetReasonCard()
	rc:RegisterFlagEffect(51927005,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(51927005,0))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetLabel(fid)
	e1:SetLabelObject(rc)
	e1:SetCondition(c51927005.discon)
	e1:SetOperation(c51927005.disop)
	Duel.RegisterEffect(e1,tp)
end
function c51927005.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	local fid=e:GetLabel()
	return rc:GetFlagEffectLabel(51927005)==fid and rc:GetFlagEffectLabel(51927006)~=fid and rp~=tp and re:GetHandler():GetOriginalType()&TYPE_MONSTER>0
end
function c51927005.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	local fid=e:GetLabel()
	if not Duel.SelectYesNo(tp,aux.Stringid(51927005,1)) then return end
	Duel.NegateEffect(ev)
	Duel.Hint(HINT_CARD,0,51927005)
	rc:RegisterFlagEffect(51927006,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(51927005,2))
end
