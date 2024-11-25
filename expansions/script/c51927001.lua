--石刻龙 板岩
function c51927001.initial_effect(c)
	--Carved stone(earth)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,51927001)
	e1:SetCondition(c51927001.spcon)
	e1:SetTarget(c51927001.sptg)
	e1:SetOperation(c51927001.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,51927002)
	e2:SetCondition(c51927001.thcon)
	e2:SetTarget(c51927001.thtg)
	e2:SetOperation(c51927001.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--be material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCondition(c51927001.condition)
	e4:SetOperation(c51927001.operation)
	c:RegisterEffect(e4)
end
function c51927001.cfilter(c)
	return c:IsType(TYPE_EFFECT) and not c:IsSetCard(0x6256) and c:IsFaceup()
end
function c51927001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c51927001.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c51927001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c51927001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c51927001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c51927001.tgfilter(c)
	return c:IsSetCard(0x6256) and c:IsFaceupEx() and c:IsAbleToHand() and c:IsAbleToDeck()
end
function c51927001.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c51927001.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c51927001.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c51927001.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:FilterSelect(1-tp.Card.IsAbleToHand,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	g:Sub(sg)
	if #g>0 then
		Duel.SortDecktop(tp,tp,#g)
		for i=1,#g do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
function c51927001.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return rc:IsSummonType(SUMMON_TYPE_ADVANCE) and rc:IsType(TYPE_NORMAL) and c:IsReason(REASON_RELEASE) and rc:IsFaceup()
end
function c51927001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local rc=c:GetReasonCard()
	rc:RegisterFlagEffect(51927001,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(51927001,0))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetLabel(fid)
	e1:SetLabelObject(rc)
	e1:SetCondition(c51927001.discon)
	e1:SetOperation(c51927001.disop)
	Duel.RegisterEffect(e1,tp)
end
function c51927001.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	local fid=e:GetLabel()
	return rc:GetFlagEffectLabel(51927001)==fid and rc:GetFlagEffectLabel(51927002)~=fid and rp~=tp
end
function c51927001.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	local fid=e:GetLabel()
	--if Duel.GetCurrentChain()~=0 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(51927001,1)) then return end
	local g=eg:Filter(Card.IsSummonPlayer,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,51927001)
	rc:RegisterFlagEffect(51927002,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(51927001,2))
end
