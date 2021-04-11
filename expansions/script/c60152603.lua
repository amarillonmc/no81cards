--皇家骑士 伪神
function c60152603.initial_effect(c)
	--yd
    local e01=Effect.CreateEffect(c)
    e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e01:SetCode(EVENT_CHAINING)
    e01:SetRange(LOCATION_MZONE)
    e01:SetCondition(c60152603.e01con)
    e01:SetOperation(c60152603.e01op)
    c:RegisterEffect(e01)
    local e02=e01:Clone()
    e02:SetCode(EVENT_ATTACK_ANNOUNCE)
    c:RegisterEffect(e02)
    local e03=e01:Clone()
    e03:SetCode(EVENT_SUMMON_SUCCESS)
    c:RegisterEffect(e03)
    local e04=e01:Clone()
    e04:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e04)
    local e05=e01:Clone()
    e05:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e05)
	--tohand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60152603,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c60152603.e1tar)
    e1:SetOperation(c60152603.e1op)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(60152603,2))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(c60152603.e2con)
    c:RegisterEffect(e2)
end
function c60152603.e01con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
    local c=e:GetHandler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
end
function c60152603.e01op(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local g=Duel.GetFieldGroup(tp,0xff,0)
    local seed=g:RandomSelect(tp,1)
	local nseq=seed:GetFirst():GetSequence()
	while nseq>4 do nseq=nseq-5 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1 then
		return false
	else
		if nseq==seq then
			if seq>=2 then 
				if Duel.CheckLocation(e:GetHandlerPlayer(),LOCATION_MZONE,nseq-1) then
					Duel.MoveSequence(c,nseq-1)
				else
					local c2=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_MZONE,nseq-1)
					Duel.SwapSequence(c,c2)
				end
			else
				if Duel.CheckLocation(e:GetHandlerPlayer(),LOCATION_MZONE,nseq+1) then
					Duel.MoveSequence(c,nseq+1)
				else
					local c2=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_MZONE,nseq+1)
					Duel.SwapSequence(c,c2)
				end
			end
		else
			if Duel.CheckLocation(e:GetHandlerPlayer(),LOCATION_MZONE,nseq) then
				Duel.MoveSequence(c,nseq)
			else
				local c2=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_MZONE,nseq)
				Duel.SwapSequence(c,c2)
			end
		end
	end
end
function c60152603.e1tar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) and e:GetHandler():GetFlagEffect(60152603)==0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
    e:GetHandler():RegisterFlagEffect(60152603,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c60152603.e1op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
		if e:GetHandler():GetColumnGroupCount()==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,nil)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60152603,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local sg=g:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			end
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
    end
end
function c60152603.e2confilter(c)
    return c:IsFaceup() and c:IsSetCard(0x6b27) and c:IsType(TYPE_XYZ)
end
function c60152603.e2con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c60152603.e2confilter,tp,LOCATION_MZONE,0,1,nil)
end