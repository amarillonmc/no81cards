--星海航线 光之惩戒 伊卡洛斯
function c11560702.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c11560702.mfilter,10,3)
	c:EnableReviveLimit() 
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)	  
	--double damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE) 
	e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e1) 
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(c11560702.actcon)
	c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_DISABLE) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetTargetRange(0,LOCATION_ONFIELD) 
	e1:SetCondition(c11560702.actcon) 
	c:RegisterEffect(e1) 
	--double 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_DISABLED) 
	e2:SetCost(c11560702.dbcost)
	e2:SetTarget(c11560702.dbtg)
	e2:SetOperation(c11560702.dbop)
	c:RegisterEffect(e2) 
	--SpecialSummon 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e3:SetCode(EVENT_LEAVE_FIELD) 
	e3:SetLabel(0) 
	e3:SetCondition(function(e) 
	local tp=e:GetHandlerPlayer() 
	if e:GetLabel()==0 then return false end 
	if c:IsReason(REASON_EFFECT) then 
	return e:GetHandler():GetReasonPlayer()==1-tp 
	elseif c:IsReason(REASON_BATTLE) then 
	return true 
	else return false end end)
	e3:SetTarget(c11560702.sptg) 
	e3:SetOperation(c11560702.spop) 
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e4:SetCode(EVENT_LEAVE_FIELD_P)  
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetLabelObject(e3) 
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local te=e:GetLabelObject() 
	if te==nil then return end 
	if c:GetOverlayCount()>0 then 
	te:SetLabel(1)
	else
	te:SetLabel(0) 
	end end)  
	c:RegisterEffect(e4) 
end 
c11560702.SetCard_SR_Saier=true 
function c11560702.mfilter(c) 
	return c:IsLevel(10) and c:GetLevel()==c:GetOriginalLevel() 
end 
function c11560702.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c11560702.dbcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tpp,1,1,REASON_COST) 
end 
function c11560702.dbtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsFaceup() end  
end
function c11560702.dbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsFaceup() and c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL) 
		e2:SetValue(e:GetHandler():GetAttack()*2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function c11560702.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetReasonPlayer()==1-tp and e:GetLabel()~=0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c11560702.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then  
		--
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(c:GetBaseAttack()*2)		
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)   
		--
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_IMMUNE_EFFECT) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(function(e,te) 
		return te:GetOwner()~=e:GetOwner() end)   
		if Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then   
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2) 
		else 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN)  
		end  
		c:RegisterEffect(e1)  
		--
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetCountLimit(1)  
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c11560702.descon) 
		e1:SetOperation(c11560702.desop) 
		c:RegisterEffect(e1) 
	end 
end 
function c11560702.descon(e,tp,eg,ep,ev,re,r,rp)   
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetLabel() 
end  
function c11560702.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Destroy(c,REASON_EFFECT)
end 











