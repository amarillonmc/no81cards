--fate·旅行者
function c9950740.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c9950740.spcon)
	e2:SetOperation(c9950740.spop)
	c:RegisterEffect(e2)
 --equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950740,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c9950740.eqtg)
	e1:SetOperation(c9950740.eqop)
	c:RegisterEffect(e1)
--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9950740,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_RECOVER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c9950740.damcon)
	e4:SetTarget(c9950740.damtg)
	e4:SetOperation(c9950740.damop)
	c:RegisterEffect(e4)
  --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950740.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950740.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950740,0))
end
function c9950740.spfilter(c)
	return c:IsSetCard(0xba5) and c:IsLevelAbove(4) and c:IsAbleToRemoveAsCost()
end
function c9950740.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950740.spfilter,tp,LOCATION_HAND,0,1,nil)
end
function c9950740.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950740.spfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9950740.eqfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER)
end
function c9950740.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5)
end
function c9950740.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c9950740.eqfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(c9950740.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c9950740.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9950740.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g:GetFirst(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g:GetFirst(),1,0,0)
end
function c9950740.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetFirst()
	local tc2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsLocation,nil,LOCATION_MZONE):GetFirst()
	if tc1 and tc2 and tc1:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc1) then
		if not Duel.Equip(tp,tc1,tc2) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c9950740.eqlimit)
		e1:SetLabelObject(tc2)
		tc1:RegisterEffect(e1)
		--atkup
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e2)
	end
end
function c9950740.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c9950740.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c9950740.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end
function c9950740.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ev)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	Duel.Damage(1-tp,ev,REASON_EFFECT)
end
