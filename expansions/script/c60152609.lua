--皇家骑士 特蕾莎
function c60152609.initial_effect(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedureLevelFree(c,c60152609.auxfilter,nil,4,4)
    --spsummon condition
    local e00=Effect.CreateEffect(c)
    e00:SetType(EFFECT_TYPE_SINGLE)
    e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e00:SetCode(EFFECT_SPSUMMON_CONDITION)
    e00:SetValue(aux.xyzlimit)
    c:RegisterEffect(e00)
	--yd
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetCode(EVENT_CHAINING)
	e01:SetRange(LOCATION_MZONE)
	e01:SetCondition(c60152609.e01con)
	e01:SetOperation(c60152609.e01op)
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
	e1:SetDescription(aux.Stringid(60152601,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,60152601)
    e1:SetCondition(c60152609.e1con)
	e1:SetTarget(c60152609.e1tar)
	e1:SetOperation(c60152609.e1op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,6012601)
	e2:SetCondition(c60152609.e2con)
	c:RegisterEffect(e2)
	--atk
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60152602,0))
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c60152609.e3con)
    e3:SetTarget(c60152609.e3tar)
    e3:SetOperation(c60152609.e3op)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetDescription(aux.Stringid(60152602,2))
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetCondition(c60152609.e4con)
    c:RegisterEffect(e4)
	--tohand
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(60152603,0))
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetCountLimit(1)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c60152609.e5con)
    e5:SetTarget(c60152609.e5tar)
    e5:SetOperation(c60152609.e5op)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetDescription(aux.Stringid(60152603,2))
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetCondition(c60152609.e6con)
    c:RegisterEffect(e6)
	--tograve
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(60152604,0))
    e7:SetCategory(CATEGORY_TOGRAVE)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_SUMMON_SUCCESS)
    e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e7:SetCountLimit(1,60152604)
    e7:SetCondition(c60152609.e7con)
    e7:SetTarget(c60152609.e7tar)
    e7:SetOperation(c60152609.e7op)
    c:RegisterEffect(e7)
    local e8=e7:Clone()
    e8:SetCode(EVENT_SPSUMMON_SUCCESS)
    e8:SetCountLimit(1,6012604)
	e8:SetCondition(c60152609.e8con)
    c:RegisterEffect(e8)
    --indes
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e9:SetValue(1)
    e9:SetCondition(c60152609.e9con)
    c:RegisterEffect(e9)
    --indes2
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e10:SetRange(LOCATION_MZONE)
    e10:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e10:SetValue(1)
    e10:SetCondition(c60152609.e10con)
    c:RegisterEffect(e10)
    --atk
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_UPDATE_ATTACK)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetValue(c60152609.e11val)
    e11:SetCondition(c60152609.e11con)
    c:RegisterEffect(e11)
    local e12=e11:Clone()
    e12:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e12)
    --tohand
    local e13=Effect.CreateEffect(c)
    e13:SetDescription(aux.Stringid(60152607,0))
    e13:SetCategory(CATEGORY_DESTROY)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e13:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e13:SetCode(EVENT_ATTACK_ANNOUNCE)
    e13:SetRange(LOCATION_MZONE)
    e13:SetCountLimit(1)
    e13:SetCondition(c60152609.e13con)
    e13:SetTarget(c60152609.e13tar)
    e13:SetOperation(c60152609.e13op)
    c:RegisterEffect(e13)
	--down
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD)
    e14:SetCode(EFFECT_UPDATE_ATTACK)
    e14:SetRange(LOCATION_MZONE)
    e14:SetTargetRange(0,LOCATION_MZONE)
    e14:SetValue(c60152609.e14val)
    e14:SetCondition(c60152609.e14con)
    c:RegisterEffect(e14)
    local e15=e14:Clone()
    e15:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e15)
    --kzq
    local e16=Effect.CreateEffect(c)
    e16:SetDescription(aux.Stringid(60152608,0))
    e16:SetCategory(CATEGORY_CONTROL)
    e16:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e16:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e16:SetCode(EVENT_ATTACK_ANNOUNCE)
    e16:SetRange(LOCATION_MZONE)
    e16:SetCountLimit(1)
    e16:SetCondition(c60152609.e16con)
    e16:SetTarget(c60152609.e16tar)
    e16:SetOperation(c60152609.e16op)
    c:RegisterEffect(e16)
    --immune
    local e17=Effect.CreateEffect(c)
    e17:SetType(EFFECT_TYPE_SINGLE)
    e17:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e17:SetCode(EFFECT_IMMUNE_EFFECT)
    e17:SetRange(LOCATION_MZONE)
    e17:SetValue(c60152609.e17filter)
    c:RegisterEffect(e17)
    --destroy
    local e18=Effect.CreateEffect(c)
    e18:SetCategory(CATEGORY_DESTROY)
    e18:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e18:SetCode(EVENT_BATTLE_START)
    e18:SetCondition(c60152609.e18con)
    e18:SetTarget(c60152609.e18tg)
    e18:SetOperation(c60152609.e18op)
    c:RegisterEffect(e18)
    --token
    local e19=Effect.CreateEffect(c)
    e19:SetDescription(aux.Stringid(60152609,0))
    e19:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
    e19:SetType(EFFECT_TYPE_QUICK_O)
    e19:SetCode(EVENT_FREE_CHAIN)
    e19:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e19:SetRange(LOCATION_MZONE)
    e19:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e19:SetCountLimit(1)
    e19:SetTarget(c60152609.e19tg)
    e19:SetOperation(c60152609.e19op)
    c:RegisterEffect(e19)
end
function c60152609.auxfilter(c,xyzc)
    return c:IsSetCard(0x6b27)
end
function c60152609.e01con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	return (e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152601) 
		or e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152602) 
		or e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152603) 
		or e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152604))
end
function c60152609.e01op(e,tp,eg,ep,ev,re,r,rp)
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
function c60152609.e1con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152601)
end
function c60152609.e1tarfilter(c)
	return c:IsSetCard(0x6b27) and c:IsType(TYPE_MONSTER) and not c:IsCode(60152601) and c:IsAbleToHand()
end
function c60152609.e1tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60152609.e1tarfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60152609.e1opfilter(c,e,tp)
	return c:IsSetCard(0x6b27) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60152609.e1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60152609.e1tarfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if e:GetHandler():GetColumnGroupCount()==0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local g=Duel.GetMatchingGroup(c60152609.e1opfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60152601,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c60152609.e2confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6b27) and c:IsType(TYPE_XYZ)
end
function c60152609.e2con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60152609.e2confilter,tp,LOCATION_MZONE,0,1,nil) 
		and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152601)
end
function c60152609.e3con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152602)
end
function c60152609.e3tar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.nzatk(chkc) end
    if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():GetFlagEffect(60152602)==0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
    e:GetHandler():RegisterFlagEffect(60152602,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c60152609.e3op(e,tp,eg,ep,ev,re,r,rp)
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
function c60152609.e4confilter(c)
    return c:IsFaceup() and c:IsSetCard(0x6b27) and c:IsType(TYPE_XYZ)
end
function c60152609.e4con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c60152609.e4confilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152602)
end
function c60152609.e5con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152603)
end
function c60152609.e5tar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) and e:GetHandler():GetFlagEffect(60152603)==0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
    e:GetHandler():RegisterFlagEffect(60152603,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c60152609.e5op(e,tp,eg,ep,ev,re,r,rp)
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
function c60152609.e6confilter(c)
    return c:IsFaceup() and c:IsSetCard(0x6b27) and c:IsType(TYPE_XYZ)
end
function c60152609.e6con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c60152609.e6confilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152603)
end
function c60152609.e7con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152604)
end
function c60152609.e7tarfilter(c)
    return c:IsSetCard(0x6b27) and not c:IsCode(60152604) and c:IsAbleToGrave()
end
function c60152609.e7tar(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60152609.e7tarfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c60152609.e7opfilter(c,e,tp)
	return c:IsSetCard(0x6b27) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60152609.e7op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60152609.e7tarfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
		if e:GetHandler():GetColumnGroupCount()==0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local g=Duel.GetMatchingGroup(c60152609.e7opfilter,tp,LOCATION_HAND,0,nil,e,tp)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60152604,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
    end
end
function c60152609.e8confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6b27) and c:IsType(TYPE_XYZ)
end
function c60152609.e8con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60152609.e8confilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152604)
end
function c60152609.e9con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152605)
end
function c60152609.e10con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152606)
end
function c60152609.e11val(e,c)
    return c:GetOverlayCount()*300
end
function c60152609.e11con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152607)
end
function c60152609.e13con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152607)
end
function c60152609.e13tar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c60152609.e13op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		if e:GetHandler():GetColumnGroupCount()==0 then
			if Duel.Destroy(tc,REASON_EFFECT)>0 then
				local g=Duel.GetOperatedGroup()
				local tc=g:GetFirst()
				while tc do
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetCode(EFFECT_CANNOT_ACTIVATE)
					e1:SetTargetRange(0,1)
					e1:SetValue(c60152609.e13opaclimit)
					e1:SetLabel(tc:GetCode())
					e1:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1,tp)
					tc=g:GetNext()
				end
			end
		else
			Duel.Destroy(tc,REASON_EFFECT)
		end
    end
end
function c60152609.e13opaclimit(e,re,tp)
    return re:GetHandler():IsCode(e:GetLabel())
end
function c60152609.e14val(e)
    return e:GetHandler():GetOverlayCount()*-300
end
function c60152609.e14con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152608)
end
function c60152609.e16con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152608)
end
function c60152609.e16tar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c60152609.e16op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e)
        and not tc:IsImmuneToEffect(e) then
		if e:GetHandler():GetColumnGroupCount()==0 then
			c:SetCardTarget(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_CONTROL)
			e1:SetValue(tp)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCondition(c60152609.e16opctcon)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_CODE)
			e2:SetValue(60152608)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetCondition(c60152609.e16opctcon)
			tc:RegisterEffect(e2)
		else
			c:SetCardTarget(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_CONTROL)
			e1:SetValue(tp)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCondition(c60152609.e16opctcon)
			tc:RegisterEffect(e1)
		end
    end
end
function c60152609.e16opctcon(e)
    local c=e:GetOwner()
    local h=e:GetHandler()
    return c:IsHasCardTarget(h)
end
function c60152609.e17filter(e,te)
    return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c60152609.e17con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152609)
end
function c60152609.e18con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return bc and bc:IsType(TYPE_TOKEN)
end
function c60152609.e18tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c60152609.e18op(e,tp,eg,ep,ev,re,r,rp)
    local bc=e:GetHandler():GetBattleTarget()
    if bc:IsRelateToBattle() then
        local atk=bc:GetBaseAttack()
        local def=bc:GetBaseDefense()
		if atk<0 then atk=0 end
		if def<0 then def=0 end
        if Duel.Destroy(bc,REASON_EFFECT)~=0 then
            Duel.Damage(1-tp,atk+def,REASON_EFFECT)
        end
    end
end
function c60152609.e19con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60152609)
end
function c60152609.e19tgfilter(c,tp)
    return c:IsFaceup() and Duel.IsPlayerCanSpecialSummonMonster(tp,60152699,nil,0x4011,c:GetAttack(),c:GetDefense(),1,RACE_ZOMBIE,ATTRIBUTE_DARK)
end
function c60152609.e19tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c60152609.e19tgfilter(chkc,tp) end
    if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c60152609.e19tgfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
    Duel.SelectTarget(tp,c60152609.e19tgfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c60152609.e19op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local atk=tc:GetAttack()
        local def=tc:GetDefense()
        if Duel.IsPlayerCanSpecialSummonMonster(tp,60152699,nil,0x4011,atk,def,1,RACE_ZOMBIE,ATTRIBUTE_DARK) then
			if e:GetHandler():GetColumnGroupCount()==0 then
				local token=Duel.CreateToken(tp,60152699)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_BASE_ATTACK)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(atk)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_BASE_DEFENSE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetValue(def)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_UNRELEASABLE_SUM)
				e3:SetValue(1)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e3)
				local e4=e3:Clone()
				e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
				token:RegisterEffect(e4)
				local e5=e3:Clone()
				e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
				token:RegisterEffect(e5)
				local e6=e3:Clone()
				e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				token:RegisterEffect(e6)
				local e7=e3:Clone()
				e7:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
				token:RegisterEffect(e7)
				if Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)>0 and not tc:IsDisabled() then
					Duel.NegateRelatedChain(tc,RESET_TURN_SET)
					local e8=Effect.CreateEffect(c)
					e8:SetType(EFFECT_TYPE_SINGLE)
					e8:SetCode(EFFECT_DISABLE)
					e8:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e8)
					local e9=Effect.CreateEffect(c)
					e9:SetType(EFFECT_TYPE_SINGLE)
					e9:SetCode(EFFECT_DISABLE_EFFECT)
					e9:SetValue(RESET_TURN_SET)
					e9:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e9)
					local e10=Effect.CreateEffect(c)
					e10:SetType(EFFECT_TYPE_SINGLE)
					e10:SetCode(EFFECT_SET_ATTACK_FINAL)
					e10:SetValue(0)
					e10:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e10)
					local e11=Effect.CreateEffect(c)
					e11:SetType(EFFECT_TYPE_SINGLE)
					e11:SetCode(EFFECT_SET_DEFENSE_FINAL)
					e11:SetValue(0)
					e11:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e11)
					local e12=Effect.CreateEffect(c)
					e12:SetType(EFFECT_TYPE_SINGLE)
					e12:SetCode(EFFECT_UNRELEASABLE_SUM)
					e12:SetValue(1)
					e12:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e12)
					local e13=e12:Clone()
					e13:SetCode(EFFECT_UNRELEASABLE_NONSUM)
					tc:RegisterEffect(e13)
					local e14=e12:Clone()
					e14:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
					tc:RegisterEffect(e14)
					local e15=e12:Clone()
					e15:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
					tc:RegisterEffect(e15)
					local e16=e12:Clone()
					e16:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
					tc:RegisterEffect(e16)
				end
			else
				local token=Duel.CreateToken(tp,60152699)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_BASE_ATTACK)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(atk)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_BASE_DEFENSE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetValue(def)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_UNRELEASABLE_SUM)
				e3:SetValue(1)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e3)
				local e4=e3:Clone()
				e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
				token:RegisterEffect(e4)
				local e5=e3:Clone()
				e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
				token:RegisterEffect(e5)
				local e6=e3:Clone()
				e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				token:RegisterEffect(e6)
				local e7=e3:Clone()
				e7:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
				token:RegisterEffect(e7)
				Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
			end
        end
    end
end