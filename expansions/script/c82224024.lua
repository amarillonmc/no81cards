local m=82224024
local cm=_G["c"..m]
cm.name="弑神猎皇"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,nil,3)  
	c:EnableReviveLimit() 
	--effect 
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_BATTLE_CONFIRM)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCountLimit(1)  
	e1:SetCondition(cm.con)  
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1) 
	--cannot target  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e2:SetValue(aux.tgoval)  
	c:RegisterEffect(e2)  
	--indes  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetValue(aux.indoval)  
	c:RegisterEffect(e3)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local bc=c:GetBattleTarget()  
	return c:IsRelateToBattle() and bc and bc:GetControler()~=tp and bc:IsFaceup() and bc:IsRelateToBattle() and not (bc:GetAttack()==0 and bc:GetDefense()==0 and (bc:IsDisabled() or not bc:IsType(TYPE_EFFECT)))
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetChainLimit(cm.chlimit)   
end  
function cm.chlimit(e,ep,tp)  
	return tp==ep  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=e:GetHandler():GetBattleTarget() 
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then 
		Duel.NegateRelatedChain(bc,RESET_TURN_SET) 
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		bc:RegisterEffect(e1)  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_DISABLE_EFFECT)  
		e2:SetValue(RESET_TURN_SET)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		bc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)  
		e3:SetType(EFFECT_TYPE_SINGLE)  
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)  
		e3:SetValue(0)  
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		bc:RegisterEffect(e3) 
		local e4=e3:Clone()  
		e4:SetCode(EFFECT_SET_DEFENSE_FINAL)   
		bc:RegisterEffect(e4)   
	end
end