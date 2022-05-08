local m=25000047
local cm=_G["c"..m]
cm.name="魔皇剑 觉醒之魔剑"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)   
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():GetEquipTarget()end) 
	e3:SetCost(cm.pycost)
	e3:SetOperation(cm.pyop) 
	c:RegisterEffect(e3) 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then Duel.Equip(tp,e:GetHandler(),tc) end
end
function cm.pycost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,Duel.GetLP(tp)/2) end 
	e:SetLabel(Duel.GetLP(tp)/2)
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2) 
end  
function cm.pyop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),e:GetHandler():GetEquipTarget()
	if not tc then return end
	local x=e:GetLabel()
	if x>=2000 then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	if x>=3000 then 
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(x)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)   
	end 
	if x>=4000 then 
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_BATTLE_DAMAGE)
		e3:SetRange(LOCATION_SZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetCondition(cm.damcon1)
		e3:SetOperation(cm.damop)
		c:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EVENT_DAMAGE)
		e4:SetCondition(cm.damcon2)
		c:RegisterEffect(e4)
	end 
end
function cm.damcon1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():GetEquipTarget() then return false end
	return ep~=tp and Duel.GetLP(1-tp)>0 and eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function cm.damcon2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():GetEquipTarget() then return false end
	return ep~=tp and Duel.GetLP(1-tp)>0 and bit.band(r,REASON_BATTLE)==0 and re:GetHandler()==e:GetHandler():GetEquipTarget()
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local d,x=math.floor(ev/300),Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	local g=Duel.GetDecktopGroup(1-tp,math.min(d,x))
	if g:FilterCount(Card.IsAbleToRemove,nil,POS_FACEDOWN)~=#g then return end  
	Duel.Hint(HINT_CARD,0,m)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
