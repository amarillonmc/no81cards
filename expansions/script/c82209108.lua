--清莲仙的休境
local m=82209108
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCondition(cm.actcon)  
	c:RegisterEffect(e1)  
	--atk&def  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc298))  
	e2:SetValue(cm.atkval)  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EFFECT_UPDATE_DEFENSE)  
	c:RegisterEffect(e3)
	--effect 2
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))  
	e4:SetCategory(CATEGORY_RECOVER)  
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e4:SetCode(EVENT_BATTLE_START)  
	e4:SetRange(LOCATION_SZONE)  
	e4:SetCondition(cm.con) 
	e4:SetTarget(cm.tg)  
	e4:SetOperation(cm.op)  
	c:RegisterEffect(e4)   
	--effect 3
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_IGNITION)  
	e5:SetRange(LOCATION_SZONE)  
	e5:SetCountLimit(1,m) 
	e5:SetCost(cm.cost2)
	e5:SetCondition(cm.con2) 
	e5:SetTarget(cm.tg2)  
	e5:SetOperation(cm.op2)  
	c:RegisterEffect(e5) 
end
function cm.actfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.atkval(e,c)
	return Duel.GetTurnCount()*300
end
--effect 2
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetAttacker()  
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end  
	e:SetLabelObject(tc)
	return tc and tc:IsFaceup() and tc:IsSetCard(0xc298) 
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tc=e:GetLabelObject()
	local atk=tc:GetAttack()
	if tc:GetDefense()>atk then atk=tc:GetDefense() end
	if chk==0 then return atk>0 end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(math.ceil(atk/2))  
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,math.ceil(atk/2)) 
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	if not (tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsControler(tp) and tc:IsRelateToBattle()) then return end
	local atk=tc:GetAttack()
	if tc:GetDefense()>atk then atk=tc:GetDefense() end
	if atk>0 then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)  
		Duel.Recover(p,math.ceil(atk/2),REASON_EFFECT)  
	end
end  
--effect 3
function cm.confilter(c)
	return c:IsSetCard(0xc298) and c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_MZONE,0,1,nil)
end 
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.setfilter(c)
	return c:IsSetCard(0xc298) and c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end  
function cm.op2(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD) 
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)  
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end 