--最后的解救
function c9910893.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910893)
	e1:SetTarget(c9910893.target)
	e1:SetOperation(c9910893.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910893)
	e2:SetTarget(c9910893.reptg)
	e2:SetValue(c9910893.repval)
	e2:SetOperation(c9910893.repop)
	c:RegisterEffect(e2)
end
c9910893.toss_coin=true
function c9910893.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c9910893.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsType(TYPE_MONSTER) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
	local opt=Duel.AnnounceCoin(tp)
	local coin=Duel.TossCoin(tp,1)
	local reset=RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END 
	if opt~=coin then
		tc:RegisterFlagEffect(9910892,reset,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910893,2))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(reset)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(c9910893.fuslimit)
		tc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e6)
	else
		tc:RegisterFlagEffect(9910893,reset,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910893,3))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCondition(c9910893.chcon)
		e1:SetOperation(c9910893.chop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910893.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c9910893.chcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler()==tc and tc:GetFlagEffect(9910893)~=0 and tc:GetFlagEffectLabel(9910893)<2
end
function c9910893.chop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910893)
	local tc=e:GetLabelObject()
	if tc then tc:SetFlagEffectLabel(9910893,tc:GetFlagEffectLabel(9910893)+1) end
	Duel.ChangeChainOperation(ev,c9910893.thop)
end
function c9910893.thfilter(c)
	return c:IsCode(9910871) and c:IsAbleToHand()
end
function c9910893.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910893.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectOption(tp,1190,aux.Stringid(9910893,0))==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	else
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c9910893.repfilter(c,tp)
	return c:IsFaceup() and aux.IsCodeListed(c,9910871) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c9910893.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c9910893.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c9910893.repval(e,c)
	return c9910893.repfilter(c,e:GetHandlerPlayer())
end
function c9910893.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910893,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
