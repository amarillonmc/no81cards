--芳青之梦 幻樱歌
function c21113805.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DISABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e0:SetCondition(c21113805.discon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21113805+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c21113805.con)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21113806)
	e2:SetCost(c21113805.cost2)
	e2:SetTarget(c21113805.tg2)
	e2:SetOperation(c21113805.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)	
end
function c21113805.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()~=2
end
function c21113805.w(c)
	return c:IsFacedown() or not c:IsDisabled()
end
function c21113805.con(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return not Duel.IsExistingMatchingCard(c21113805.w,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c21113805.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTarget(c21113805.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,c:GetControler())
end
function c21113805.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xc914)
end
function c21113805.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c21113805.op0)
	Duel.RegisterEffect(e1,tp)
end
function c21113805.op0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21113805)==0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(21113805,0)) then
	Duel.Draw(tp,1,REASON_RULE)
	end
	Duel.ResetFlagEffect(tp,21113805)
	e:Reset()
end
function c21113805.q(c)
	return c:IsFaceup() and c:IsSetCard(0xc914)
end
function c21113805.e(c)
	return c:IsType(1) and c:IsSetCard(0xc914) and c:IsAbleToHand() and not c:IsCode(21113805)
end
function c21113805.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21113805.q,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,4)>0 and Duel.IsExistingMatchingCard(c21113805.e,tp,1,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(11,tp,fd)
	local seq=math.log(fd,2)
	e:SetLabel(seq)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,1)
end
function c21113805.move(c,seq)
	if not c21113805.q(c) then return end
	if c:IsFacedown() then return end
	if c:GetSequence()~=seq then 
		return true
	else return end
end
function c21113805.seq(c,seq)
	if c:GetSequence()==seq then 
		return true
	else return end
end
function c21113805.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113805,RESET_PHASE+PHASE_END,0,1)
	local seq=e:GetLabel()
	Duel.Hint(3,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c21113805.move,tp,LOCATION_MZONE,0,1,1,nil,seq):GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
	local oc=Duel.GetMatchingGroup(c21113805.seq,tp,LOCATION_MZONE,0,nil,seq):GetFirst()
	if oc then Duel.Destroy(oc,REASON_RULE) end
	Duel.MoveSequence(tc,seq)
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21113805.e,tp,1,0,1,1,nil)
		if #g>0 then 
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
	end	
end