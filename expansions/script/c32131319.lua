--旭光的少年 科斯魔
function c32131319.initial_effect(c)
	aux.AddCodeList(c,32131318)
	aux.AddMaterialCodeList(c,32131318)
	--code
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_ADD_CODE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE) 
	e0:SetRange(0xff) 
	e0:SetValue(32131318) 
	c:RegisterEffect(e0)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c32131319.lcheck)
	c:EnableReviveLimit() 
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE) 
	e1:SetCountLimit(1)  
	e1:SetCondition(c32131319.atkcon)
	e1:SetCost(c32131319.atkcost)
	e1:SetOperation(c32131319.atkop)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetCondition(c32131319.atcon)
	e2:SetValue(c32131319.atlimit)
	c:RegisterEffect(e2) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetCondition(c32131319.atcon) 
	c:RegisterEffect(e2) 
end
c32131319.SetCard_HR_flame13=true 
c32131319.HR_Flame_CodeList=32131318 
function c32131319.lcheck(g)
	return g:IsExists(Card.IsLinkCode,1,nil,32131318) 
end 
function c32131319.ckfil(c) 
	return c:IsFaceup() and c.SetCard_HR_flame13   
end 
function c32131319.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:GetAttack()>0 and Duel.IsExistingMatchingCard(c32131319.ckfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
end
function c32131319.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(32131319)==0 end
	c:RegisterFlagEffect(32131319,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c32131319.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(bc:GetAttack())
		c:RegisterEffect(e1)
	end
end
function c32131319.atcon(e) 
	return e:GetHandler():GetMutualLinkedGroupCount()>0 
end
function c32131319.atlimit(e,c)
	return c~=e:GetHandler()
end 






