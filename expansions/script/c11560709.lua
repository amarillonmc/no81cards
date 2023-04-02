--星海航线 翰宇星皇
function c11560709.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,3) 
	c:EnableReviveLimit()   
	--indes 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,11560709) 
	e1:SetTarget(c11560709.idtg) 
	e1:SetOperation(c11560709.idop) 
	c:RegisterEffect(e1) 
	--Disable 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21560709)
	e2:SetCost(c11560709.bdiscost)
	e2:SetTarget(c11560709.bdistg) 
	e2:SetOperation(c11560709.bdisop) 
	c:RegisterEffect(e2)  
	--
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_COIN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLED)
	e3:SetCountLimit(1,31560709)
	e3:SetCondition(c11560709.xxcon)
	e3:SetTarget(c11560709.xxtg)
	e3:SetOperation(c11560709.xxop)
	c:RegisterEffect(e3)
end
c11560709.toss_coin=true 
c11560709.SetCard_SR_Saier=true 
function c11560709.idtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end 
function c11560709.idtg(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	--indes
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	--e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT) 
	--e1:SetTargetRange(LOCATION_MZONE,0)
	--e1:SetValue(function(e,re,r,rp)
	--if bit.band(r,REASON_EFFECT)~=0 then
	--  return 1
	--else return 0 end 
	--end) 
	--e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN) 
	--Duel.RegisterEffect(e1,tp)  
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetCountLimit(1)
		e1:SetValue(function(e,re,r,rp)
		return bit.band(r,REASON_EFFECT)~=0 end) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
		tc=g:GetNext() 
		end 
	end  
end  
function c11560709.bdiscost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) 
end 
function c11560709.bdistg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc and aux.NegateEffectMonsterFilter(bc) end  
	Duel.SetTargetCard(bc) 
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,bc,1,0,0) 
end 
function c11560709.bdisop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then  
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end 
		if c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1) 
		if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11560709,0)) then   
		Duel.BreakEffect() 
		local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil) 
		Duel.Destroy(dg,REASON_EFFECT) 
		end 
		end 
	end 
end 
function c11560709.xxcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget() 
	return bc and bc:IsStatus(STATUS_OPPO_BATTLE) and bc:IsRelateToBattle()
end
function c11560709.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c11560709.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=Duel.TossCoin(tp,1) 
	if x==1 and c:IsRelateToEffect(e) then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(function(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() end)
	e1:SetValue(function(e,te)
	return te:GetOwner()~=e:GetOwner() end) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1) 
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
	c:RegisterEffect(e2) 
	end
end















