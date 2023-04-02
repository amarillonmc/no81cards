--秘藏的永夏 岬镜子
require("expansions/script/c9910950")
function c9910969.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910969+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9910969.spcon)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,9910980)
	e3:SetCondition(c9910969.thcon)
	e3:SetTarget(c9910969.thtg)
	e3:SetOperation(c9910969.thop)
	c:RegisterEffect(e3)
end
function c9910969.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5954)
end
function c9910969.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910969.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c9910969.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c9910969.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c9910969.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local res=false
	if tc:IsRelateToEffect(e) then
		res=Duel.SendtoHand(tc,nil,REASON_EFFECT)>0
		if res and tc:IsLocation(LOCATION_HAND) then
			local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
			Duel.Recover(tp,d,REASON_EFFECT)
		end
	end
	QutryYx.ExtraEffectSelect(e,tp,res)
end
