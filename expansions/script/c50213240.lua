--Kamipro 北斗星君的鼓舞
function c50213240.initial_effect(c)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c50213240.ctcost)
	e1:SetTarget(c50213240.cttg)
	e1:SetOperation(c50213240.ctop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,50213240)
	e2:SetLabelObject(e0)
	e2:SetCondition(c50213240.matcon)
	e2:SetTarget(c50213240.mattg)
	e2:SetOperation(c50213240.matop)
	c:RegisterEffect(e2)
end
function c50213240.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c50213240.afilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0xcbf,10)
end
function c50213240.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50213240.afilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c50213240.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c50213240.afilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0xcbf,10)
		tc=g:GetNext()
	end
end
function c50213240.spfilter(c,e,tp,se)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsControler(tp) and c:IsSetCard(0xcbf)
		and c:IsCanBeEffectTarget(e) and (se==nil or c:GetReasonEffect()~=se)
end
function c50213240.matcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(c50213240.spfilter,1,nil,e,tp,se)
end
function c50213240.xfilter(c,tp,eg)
	return eg:IsContains(c) and c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xcbf) and c:IsControler(tp)
end
function c50213240.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c50213240.xfilter(chkc,tp,eg) end
	if chk==0 then return Duel.IsExistingTarget(c50213240.xfilter,tp,LOCATION_MZONE,0,1,nil,tp,eg)
		and e:GetHandler():IsCanOverlay() end
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c50213240.xfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,eg)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c50213240.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end