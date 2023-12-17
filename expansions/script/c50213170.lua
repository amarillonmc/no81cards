--Kamipro 赖光
function c50213170.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c50213170.xcheck,4,2,c50213170.ovfilter,aux.Stringid(50213170,0),2,c50213170.xyzop)
	c:EnableReviveLimit()
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_ALL-ATTRIBUTE_DIVINE-ATTRIBUTE_WIND)
	e1:SetCondition(c50213170.attcon)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50213170,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,50213170)
	e2:SetCost(c50213170.ctcost)
	e2:SetTarget(c50213170.cttg)
	e2:SetOperation(c50213170.ctop)
	c:RegisterEffect(e2)
	--xyz
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCountLimit(1,50213171)
	e3:SetCondition(c50213170.xmcon)
	e3:SetTarget(c50213170.xmtg)
	e3:SetOperation(c50213170.xmop)
	c:RegisterEffect(e3)
end
function c50213170.xcheck(c)
	return c:IsSetCard(0xcbf)
end
function c50213170.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcbf) and c:GetCounter(0xcbf)>=5
end
function c50213170.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,50213170)==0 end
	Duel.RegisterFlagEffect(tp,50213170,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c50213170.attcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipCount()>0
end
function c50213170.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c50213170.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcbf) and c:IsCanAddCounter(0xcbf,10)
end
function c50213170.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50213170.afilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c50213170.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c50213170.afilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0xcbf,10)
		tc=g:GetNext()
	end
end
function c50213170.xmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not c:IsRelateToBattle() then return false end
	e:SetLabelObject(tc)
	return tc:IsLocation(LOCATION_GRAVE) and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE) and tc:IsCanOverlay()
end
function c50213170.xmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c50213170.xmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Overlay(c,tc)
	end
end