--清莲仙的净花
local m=82209106
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
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)  
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
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
	e5:SetCategory(CATEGORY_POSITION)  
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
	return tc and tc:IsFaceup() and tc:IsSetCard(0xc298) 
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chkc then return chkc:IsOnField() end  
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,300,REASON_EFFECT)
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
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)  
end  
function cm.op2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)  
	local g=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.HintSelection(g)  
		local tc=g:GetFirst()
		if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 then  
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e1) 
		end
	end 
end 