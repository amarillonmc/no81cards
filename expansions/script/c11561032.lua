--指明前路的苍蓝之星·大剑
function c11561032.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)   
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c11561032.atkcon)
	e1:SetCost(c11561032.atkcost)
	e1:SetOperation(c11561032.atkop)
	c:RegisterEffect(e1) 
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING) 
	e2:SetCountLimit(1,11561032)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(c11561032.tktg)
	e2:SetOperation(c11561032.tkop)
	c:RegisterEffect(e2) 
	--attack all
---	local e3=Effect.CreateEffect(c)
--	e3:SetType(EFFECT_TYPE_SINGLE)
--	e3:SetCode(EFFECT_ATTACK_ALL)
--	e3:SetValue(1) 
--	e3:SetCondition(function(e)  
--	local tp=e:GetHandlerPlayer()
--	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(11561033) end,tp,0,LOCATION_MZONE,1,nil) end)
--	c:RegisterEffect(e3)

	--double attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	e3:SetCondition(function(e)  
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(11561033) end,tp,0,LOCATION_MZONE,1,nil) end)
	c:RegisterEffect(e3)
end 
c11561032.SetCard_ZH_Bluestar=true 
function c11561032.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc  
end
function c11561032.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(11561032)==0 and c:CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:SetLabel(c:RemoveOverlayCard(tp,1,99,REASON_EFFECT))  
	c:RegisterFlagEffect(11561032,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)  
end
function c11561032.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=e:GetLabel() 
	if x and x>0 and c:IsRelateToBattle() and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(x*(c:GetAttack()/2))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c11561032.tktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11561033,nil,TYPES_TOKEN_MONSTER,bc:GetAttack()/2,bc:GetDefense()/2,1,RACE_DRAGON,ATTRIBUTE_EARTH,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c11561032.tkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local bc=e:GetHandler():GetBattleTarget()
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,11561033,nil,TYPES_TOKEN_MONSTER,bc:GetAttack()/2,bc:GetDefense()/2,1,RACE_DRAGON,ATTRIBUTE_EARTH,POS_FACEUP,1-tp) then return end
	local token=Duel.CreateToken(tp,11561033)
	Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_SET_ATTACK) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(bc:GetAttack()/2) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	token:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_SET_DEFENSE) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(bc:GetDefense()/2) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	token:RegisterEffect(e1) 
	Duel.SpecialSummonComplete()
end
