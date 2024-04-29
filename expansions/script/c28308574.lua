--闪耀的绿宝石 死神的契约
function c28308574.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunFunRep(c,c28308574.mfilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0x283),1,99,true)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28308574,0))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,28308574)
	e1:SetCondition(c28308574.thcon1)
	e1:SetTarget(c28308574.thtg)
	e1:SetOperation(c28308574.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c28308574.thcon2)
	c:RegisterEffect(e2)
	--mat check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c28308574.valcheck)
	c:RegisterEffect(e3)
	--fusion success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c28308574.regcon)
	e4:SetOperation(c28308574.regop)
	c:RegisterEffect(e4)
	e4:SetLabelObject(e3)
end
function c28308574.mfilter(c)
	return c:IsFusionSetCard(0x283) and c:IsFusionType(TYPE_PENDULUM)
end
function c28308574.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c28308574.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c28308574.thfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c28308574.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28308574.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1000)
end
function c28308574.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c28308574.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if tg:GetCount()>0 and Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tg)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	end
end
function c28308574.valcheck(e,c)
	local g=c:GetMaterial()
	local att=0
	local tc=g:GetFirst()
	while tc do
		att=bit.bor(att,tc:GetOriginalAttribute())
		tc=g:GetNext()
	end
	e:SetLabel(att)
end
function c28308574.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabelObject():GetLabel()~=0
end
function c28308574.regop(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	if bit.band(att,ATTRIBUTE_WATER)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c28308574.indtg)
		e1:SetValue(c28308574.indct)
		c:RegisterEffect(e1)
		Duel.AdjustInstantly(c)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28308574,1))
	end
	if bit.band(att,ATTRIBUTE_LIGHT)~=0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x283))
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e3)
		Duel.AdjustInstantly(c)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28308574,2))
	end
	if bit.band(att,ATTRIBUTE_DARK)~=0 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_QUICK_O)
		e4:SetCode(EVENT_FREE_CHAIN)
		e4:SetRange(LOCATION_MZONE)
		e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e4:SetCountLimit(1)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetTarget(c28308574.atktg)
		e4:SetOperation(c28308574.atkop)
		c:RegisterEffect(e4)
		Duel.AdjustInstantly(c)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28308574,3))
	end
end
function c28308574.indtg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x283)
end
function c28308574.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c28308574.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c28308574.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ct=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)*100
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and ct>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-ct)
		tc:RegisterEffect(e1)
	end
end
