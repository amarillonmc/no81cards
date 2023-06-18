--清莲仙的隐萍
local m=82209105
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
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
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
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
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
	local bc
	if tc:IsControler(1-tp) then
		bc=tc
		tc=Duel.GetAttackTarget() 
	else
		bc=Duel.GetAttackTarget()
	end
	e:SetLabelObject(bc)  
	return tc and tc:IsFaceup() and tc:IsSetCard(0xc298) and bc and bc:IsFaceup()
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local bc=e:GetLabelObject() 
	if bc and bc:IsLocation(LOCATION_MZONE) and bc:IsFaceup() and bc:IsControler(1-tp) and bc:IsRelateToBattle() then
		local atk=bc:GetAttack()
		local def=bc:GetDefense()
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(math.ceil(atk/2))  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		bc:RegisterEffect(e1)  
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(math.ceil(def/2))
		bc:RegisterEffect(e2)  
	end  
end  
--effect 3
function cm.confilter(c)
	return c:IsSetCard(0xc298) and c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end 
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end
end  
function cm.op2(e,tp,eg,ep,ev,re,r,rp)  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)  
	e1:SetTargetRange(LOCATION_ONFIELD,0)  
	e1:SetTarget(cm.indestg)
	e1:SetValue(cm.indct)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp) 
end 
function cm.indestg(e,c)
	return c:IsSetCard(0xc298) and c:IsFaceup()
end
function cm.indct(e,re,r,rp)  
	if bit.band(r,REASON_EFFECT)~=0 then  
		return 1  
	else return 0 end  
end  