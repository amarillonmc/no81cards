--滑 稽 敲 木 鱼 ，滑 稽 果 +1
local m=13131383
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13131383)
	e1:SetCondition(c13131383.cecon)
	e1:SetTarget(c13131383.cetg)
	e1:SetOperation(c13131383.ceop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1,13141383)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c13131383.stcon)
	e2:SetTarget(c13131383.sttg)
	e2:SetOperation(c13131383.stop)
	c:RegisterEffect(e2)
	
end
function c13131383.cfilter(c)
	return c:IsFaceup() and c:IsCode(13131378)
end
function c13131383.cecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c13131383.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c13131383.cefilter(c)
	return c:IsFaceup() and not c:IsCode(13131370) and c:IsSetCard(0x1112) and c:IsType(TYPE_EFFECT)
end
function c13131383.cetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c13131383.cefilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c13131383.cefilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c13131383.ceop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(13131370)
		tc:RegisterEffect(e1)
		--recover
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(13131383,3))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCondition(c13131383.atkcon)
		e2:SetOperation(c13131383.atkop)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EVENT_SUMMON_SUCCESS)
		tc:RegisterEffect(e3)
	end
end
function c13131383.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(Card.IsCode,1,nil,13131370)
end
function c13131383.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,13131370))
	e1:SetValue(100)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,13131370))
	e2:SetValue(100)
	Duel.RegisterEffect(e2,tp)
end
function c13131383.rccfilter(c)
	return c:IsFaceup() and c:IsCode(13131370)
end
function c13131383.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and Duel.IsExistingMatchingCard(c13131383.rccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c13131383.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c13131383.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end







