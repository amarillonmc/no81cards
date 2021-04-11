--皇家骑士 芬里尔
function c60152602.initial_effect(c)
	--yd
    local e01=Effect.CreateEffect(c)
    e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e01:SetCode(EVENT_CHAINING)
    e01:SetRange(LOCATION_MZONE)
    e01:SetCondition(c60152602.e01con)
    e01:SetOperation(c60152602.e01op)
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
	--atk
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60152602,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c60152602.e1tar)
    e1:SetOperation(c60152602.e1op)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(60152602,2))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(c60152602.e2con)
    c:RegisterEffect(e2)
end
function c60152602.e01con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
    local c=e:GetHandler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
end
function c60152602.e01op(e,tp,eg,ep,ev,re,r,rp)
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
function c60152602.e1tar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.nzatk(chkc) end
    if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():GetFlagEffect(60152602)==0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
    e:GetHandler():RegisterFlagEffect(60152602,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c60152602.e1op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(math.ceil(atk/2))
		tc:RegisterEffect(e1)
		if c:GetColumnGroupCount()==0 and c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(60152602,1)) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(math.ceil(atk/2))
			c:RegisterEffect(e2)
		end
    end
end
function c60152602.e2confilter(c)
    return c:IsFaceup() and c:IsSetCard(0x6b27) and c:IsType(TYPE_XYZ)
end
function c60152602.e2con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c60152602.e2confilter,tp,LOCATION_MZONE,0,1,nil)
end