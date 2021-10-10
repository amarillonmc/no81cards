--个人行动-兰登战术
function c79029371.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c79029371.target)
	e1:SetOperation(c79029371.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c79029371.eqlimit)
	c:RegisterEffect(e2)	
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1200)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,79029371)
	e4:SetCost(c79029371.cost1)
	e4:SetCondition(c79029371.condition1)
	e4:SetTarget(c79029371.target1)
	e4:SetOperation(c79029371.activate1)
	c:RegisterEffect(e4)
	--material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,09029371)
	e5:SetTarget(c79029371.mttg)
	e5:SetOperation(c79029371.mtop)
	c:RegisterEffect(e5)
end
function c79029371.eqlimit(e,c)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_XYZ)
end
function c79029371.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsType(TYPE_XYZ)
end
function c79029371.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029371.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029371.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79029371.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79029371.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
	Debug.Message("要用哪支箭？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029371,0))
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c79029371.condition1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and rp==1-tp
end
function c79029371.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetEquipTarget()
	if chk==0 then return tc:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	tc:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029371.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c79029371.activate1(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("弦有三种选择，而敌人有三种苦难。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029371,1))
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c79029371.xfilter(c)
	return c:IsCanOverlay()
end
function c79029371.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	local xg=Group.FromCards(c,tc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029371.xfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029371.xfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,xg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,c79029371.xfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,xg)
end
function c79029371.mtop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("我已经找到猎物了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029371,2))
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local tc=Duel.GetFirstTarget()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(ec,Group.FromCards(tc))
end









