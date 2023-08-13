--方舟骑士-缪尔赛思
c189129.named_with_Arknight=1
function c189129.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,function(c) return c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight) end,1)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x10ae) 
	--add counter
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(189129,1))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1) 
	e1:SetTarget(c189129.cttg)
	e1:SetOperation(c189129.ctop)
	c:RegisterEffect(e1)
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(189129,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)  
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800) end)
	e2:SetTarget(c189129.xxtg)
	e2:SetOperation(c189129.xxop)
	c:RegisterEffect(e2)
end
function c189129.cttg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local x=Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsType(TYPE_TOKEN) end,tp,LOCATION_MZONE,0,nil)  
	if chk==0 then return x>0 and e:GetHandler():IsCanAddCounter(0x10ae,x) end 
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,x,0,0x10ae)
end
function c189129.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsType(TYPE_TOKEN) end,tp,LOCATION_MZONE,0,nil)  
	if x>0 and c:IsRelateToEffect(e) then
		c:AddCounter(0x10ae,x) 
	end
end
function c189129.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)   
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:IsLevelAbove(1) end,tp,LOCATION_MZONE,0,1,nil) end 
	local tc=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c:IsLevelAbove(1) end,tp,LOCATION_MZONE,0,1,1,nil):GetFirst() 
	if tc:IsAttackPos() then 
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	elseif tc:IsDefensePos() then 
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,PLAYER_ALL,LOCATION_MZONE)
	end 
end
function c189129.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then  
		if tc:IsAttackPos() then 
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,189130,nil,TYPES_TOKEN_MONSTER,0,0,4,RACE_SPELLCASTER,ATTRIBUTE_WATER) then return end
			local token=Duel.CreateToken(tp,189130)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)  
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_SET_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(tc:GetAttack()) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			token:RegisterEffect(e1) 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_SET_DEFENSE) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(tc:GetDefense()) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			token:RegisterEffect(e1) 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_CHANGE_LEVEL) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(tc:GetLevel()) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			token:RegisterEffect(e1) 
		elseif tc:IsDefensePos() then 
			local xc=Duel.SelectMatchingCard(tp,aux.NegateEffectMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
			if xc then
				Duel.NegateRelatedChain(xc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				xc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				xc:RegisterEffect(e2)
			end   
		end 
	end 
end 





