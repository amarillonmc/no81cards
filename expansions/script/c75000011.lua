--护花使者 阿尔弗雷德
function c75000011.initial_effect(c)
	aux.AddCodeList(c,75000001)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75000011,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,75000011)
	e1:SetTarget(c75000011.tg1)
	e1:SetOperation(c75000011.op1)
	c:RegisterEffect(e1)
	-- 融合素材赋予效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75000011,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c75000011.con2)
	e2:SetOperation(c75000011.op3)
	c:RegisterEffect(e2)
	-- 连接素材赋予效果
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75000011,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c75000011.con3)
	e3:SetOperation(c75000011.op3)
	c:RegisterEffect(e3)
end
-- 1
function c75000011.filter1(c)
	return (c:IsCode(75000001) or aux.IsCodeListed(c,75000001) and c:IsType(TYPE_MONSTER)) and c:IsAbleToHand()
end
function c75000011.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) and chkc:IsControler(tp) and c75000011.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75000011.filter1,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c75000011.filter1,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c75000011.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
-- 2
function c75000011.con2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION)~=0 and e:GetHandler():GetReasonCard():IsSetCard(0x3751)
end
-- 3
function c75000011.con3(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK
end
function c75000011.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	-- 不会被效果破坏~
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(75000011,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	-- 守备力上升
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75000011,3))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c75000011.defval)
	rc:RegisterEffect(e2)
	if not rc:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e3,true)
	end
end
function c75000011.defval(e,c)
	return 1400
end