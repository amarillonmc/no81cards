--方舟骑士·狮心裂拳 因陀罗
function c82567885.initial_effect(c)
	--double tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e1:SetValue(c82567885.dccon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82567885,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,82567885+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c82567885.spcon)
	e2:SetValue(c82567885.spval)
	c:RegisterEffect(e2)
	--multi atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c82567885.cttg)
	e3:SetOperation(c82567885.ctop)
	c:RegisterEffect(e3)
	--add setname
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(0x825)
	c:RegisterEffect(e9)
end
function c82567885.dccon(e,c)
	return c:IsSetCard(0x825)
end
function c82567885.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x825) and c:IsType(TYPE_LINK)
end
function c82567885.checkzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c82567885.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return bit.band(zone,0x1f)
end
function c82567885.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c82567885.checkzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c82567885.spval(e,c)
	local tp=c:GetControler()
	local zone=c82567885.checkzone(tp)
	return 0,zone
end
function c82567885.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK and e:GetHandler():GetReasonCard():IsSetCard(0xc827)
end
function c82567885.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local linc=c:GetReasonCard()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetValue(3)
	linc:RegisterEffect(e4)
end
function c82567885.tkfilter(c)
	return c:IsSetCard(0xc827) and c:IsFaceup()
end
function c82567885.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsSetCard(0xc827) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82567885.tkfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82567885.tkfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,1,nil)
end
function c82567885.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsSetCard(0xc827) 
  then  local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetValue(3)
	tc:RegisterEffect(e4)
	end
	tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(82567885,0))
end