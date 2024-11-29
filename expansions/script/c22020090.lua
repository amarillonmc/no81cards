--大魔术师 梅林
function c22020090.initial_effect(c)
	--summon success
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetOperation(c22020090.sumsuc)
	c:RegisterEffect(e0)
	local e4=e0:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e0:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetCondition(c22020090.spcon)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020090,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c22020090.cost)
	e2:SetTarget(c22020090.cttg)
	e2:SetOperation(c22020090.ctop)
	c:RegisterEffect(e2)
end
c22020090.effect_with_avalon=true
function c22020090.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	Duel.SelectOption(tp,aux.Stringid(22020090,1))
	Duel.RegisterEffect(e1,tp)
end
function c22020090.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22020090.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c22020090.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c22020090.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c22020090.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0xfee,3)
end
function c22020090.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c22020090.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22020090.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SelectOption(tp,aux.Stringid(22020090,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c22020090.ctfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0xfee)
end
function c22020090.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0xfee,3)
	end
end