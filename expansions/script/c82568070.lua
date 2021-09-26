--AK-陷阱师罗宾
function c82568070.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82568070,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,82568070)
	e1:SetTarget(c82568070.target)
	e1:SetOperation(c82568070.activate)
	c:RegisterEffect(e1)
	--AddCounter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82568070,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,82568070)
	e2:SetTarget(c82568070.cttg)
	e2:SetOperation(c82568070.ctop)
	c:RegisterEffect(e2)
end
function c82568070.tkfilter(c)
	return c:IsFaceup()
end

function c82568070.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82568070.tkfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82568070.tkfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x5825,1)
end
function c82568070.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e)
  then  tc:AddCounter(0x5825,1)
	end
end
function c82568070.filter(c)
	return c:GetCounter(0x5825)>0
end
function c82568070.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c82568070.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c82568070.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c82568070.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c82568070.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:GetCounter(0x5825)>0 and tc:IsRelateToEffect(e) then
		 Duel.Destroy(tc,REASON_EFFECT)
	end
end

