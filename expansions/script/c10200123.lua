--朱枪·不知火
function c10200123.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetTarget(c10200123.target)
	e1:SetOperation(c10200123.operation)
	c:RegisterEffect(e1)
	-- 装备限制
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c10200123.eqlimit)
	c:RegisterEffect(e2)
	-- SA1:奥义·红莲爆碎
	local e3a=Effect.CreateEffect(c)
	e3a:SetDescription(aux.Stringid(10200123,0))
	e3a:SetCategory(CATEGORY_RECOVER)
	e3a:SetType(EFFECT_TYPE_QUICK_O)
	e3a:SetCode(EVENT_CHAINING)
	e3a:SetRange(LOCATION_MZONE)
	e3a:SetCountLimit(1,{10200123,0})
	e3a:SetCondition(c10200123.con1)
	e3a:SetCost(c10200123.cost1)
	e3a:SetTarget(c10200123.tg1)
	e3a:SetOperation(c10200123.op1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c10200123.eqchk)
	e3:SetLabelObject(e3a)
	c:RegisterEffect(e3)
	-- SA2:奥义·朱枪乱舞
	local e4a=Effect.CreateEffect(c)
	e4a:SetDescription(aux.Stringid(10200123,1))
	e4a:SetType(EFFECT_TYPE_QUICK_O)
	e4a:SetCode(EVENT_CHAINING)
	e4a:SetRange(LOCATION_MZONE)
	e4a:SetCountLimit(1,{10200123,1})
	e4a:SetCondition(c10200123.con2)
	e4a:SetCost(c10200123.cost2)
	e4a:SetOperation(c10200123.op2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c10200123.eqchk)
	e4:SetLabelObject(e4a)
	c:RegisterEffect(e4)
	-- SA3:奥义·霸刻 / CA:终焉·红莲劫火
	local e5a=Effect.CreateEffect(c)
	e5a:SetDescription(aux.Stringid(10200123,2))
	e5a:SetCategory(CATEGORY_TOGRAVE)
	e5a:SetType(EFFECT_TYPE_QUICK_O)
	e5a:SetCode(EVENT_FREE_CHAIN)
	e5a:SetRange(LOCATION_MZONE)
	e5a:SetCountLimit(1,{10200123,2})
	e5a:SetCondition(c10200123.con3)
	e5a:SetCost(c10200123.cost3)
	e5a:SetOperation(c10200123.op3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c10200123.eqchk)
	e5:SetLabelObject(e5a)
	c:RegisterEffect(e5)
	-- 斗气恢复
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c10200123.con6)
	e6:SetOperation(c10200123.op6)
	c:RegisterEffect(e6)
end
-- 装备限制
function c10200123.eqlimit(e,c)
	return c:IsCode(10200122)
end
function c10200123.filter(c)
	return c:IsFaceup() and c:IsCode(10200122)
end
function c10200123.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10200123.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10200123.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c10200123.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10200123.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c10200123.eqchk(e,c)
	local ec=e:GetHandler()
	return ec:GetEquipTarget()==c
end
function c10200123.columnfilter(c)
	return c:IsFaceup() and c:IsCode(10200123)
end
function c10200123.checksamecolumn_zhuqiang(c)
	if not c:IsLocation(LOCATION_MZONE) then return false end
	local cg=c:GetColumnGroup()
	return cg:IsExists(c10200123.columnfilter,1,nil)
end
-- SA1
function c10200123.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() then return false end
	if not c10200123.checksamecolumn_zhuqiang(c) then return false end
	return re:IsActiveType(TYPE_MONSTER)
end
function c10200123.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c10200123.mfilter1(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:GetLevel()>0
end
function c10200123.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if not c:IsLocation(LOCATION_MZONE) then return false end
		local cg=c:GetColumnGroup():Clone()
		cg:AddCard(c)
		return cg:IsExists(c10200123.mfilter1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200123.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or not c:IsLocation(LOCATION_MZONE) then return end
	local cg=c:GetColumnGroup():Clone()
	cg:AddCard(c)
	local g=cg:Filter(c10200123.mfilter1,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if tc then
		local lv=tc:GetLevel()
		if lv>0 then
			Duel.Recover(tp,lv*100,REASON_EFFECT)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c10200123.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e2:SetTarget(c10200123.distg)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c10200123.distg(e,c)
	local tc=e:GetLabelObject()
	return tc and c:GetOriginalCode()==tc:GetOriginalCode()
end
-- SA2
function c10200123.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() then return false end
	if c10200123.checksamecolumn_zhuqiang(c) then return false end
	return rp==1-tp
end
function c10200123.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200123.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or not c:IsLocation(LOCATION_MZONE) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
-- SA3
function c10200123.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() then return false end
	return c:IsAllColumn()
end
function c10200123.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,3000) end
	Duel.PayLPCost(tp,3000)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200123.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c10200123.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or not c:IsLocation(LOCATION_MZONE) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c10200123.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	if Duel.GetLP(tp)<=2000 then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
-- 2
function c10200123.con6(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=10000 and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function c10200123.op6(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	Duel.Recover(tp,200,REASON_EFFECT)
end
