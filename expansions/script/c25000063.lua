--苍天之剑
function c25000063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c25000063.target)
	e1:SetOperation(c25000063.activate)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,25000063)
	e3:SetTarget(c25000063.eqtg)
	e3:SetOperation(c25000063.eqop)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,35000063)
	e4:SetCondition(c25000063.lpcon)
	e4:SetTarget(c25000063.lptg)
	e4:SetOperation(c25000063.lpop)
	c:RegisterEffect(e4)
	if not c25000063.global_check then
		c25000063.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c25000063.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	Duel.AddCustomActivityCounter(25000063,ACTIVITY_CHAIN,c25000063.chainfilter)
end
function c25000063.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsReason(REASON_DISCARD) then
			tc:RegisterFlagEffect(25000063,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c25000063.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_MONSTER)
end
function c25000063.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c25000063.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c25000063.eqfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetFlagEffect(25000063)>0 and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden()
end
function c25000063.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c25000063.eqfilter(chkc,tp) end
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ct>0 and Duel.IsExistingTarget(c25000063.eqfilter,tp,0,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c25000063.eqfilter,tp,0,LOCATION_GRAVE,1,ct,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,#g,0,LOCATION_GRAVE)
end
function c25000063.eqop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	local ec=e:GetHandler():GetEquipTarget()
	for tc in aux.Next(g) do
		if Duel.Equip(tp,tc,ec) then
			--equip limit
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(ec)
			e1:SetValue(c25000063.eqlimit)
			tc:RegisterEffect(e1)
			--atk up
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(3000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e3)
		end
	end
end
function c25000063.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c25000063.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(25000063,1-tp,ACTIVITY_CHAIN)>0
end
function c25000063.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c25000063.lpop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local dam=ec:GetAttack()
	if ec:GetAttack()<ec:GetDefense() then dam=ec:GetDefense() end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		local lp=Duel.GetLP(1-tp)
		Duel.SetLP(1-tp,lp-dam)
	end
end
