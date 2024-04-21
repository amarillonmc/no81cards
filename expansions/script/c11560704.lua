--星海航线 至序圣华
function c11560704.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,2) 
	c:EnableReviveLimit()  
	--sb 
	local e1=Effect.CreateEffect(c)   
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_LEAVE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,11560704+EFFECT_COUNT_CODE_DUEL)   
	e1:SetLabel(0) 
	e1:SetCondition(function(e) 
	return e:GetLabel()~=0 end)
	e1:SetTarget(c11560704.sbtg) 
	e1:SetOperation(c11560704.sbop) 
	c:RegisterEffect(e1) 
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e4:SetCode(EVENT_LEAVE_FIELD_P)  
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetLabelObject(e1) 
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
	--disable 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21560704) 
	e2:SetOperation(c11560704.disop)
	c:RegisterEffect(e2) 
	--Damage and atk 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DAMAGE) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_PHASE+PHASE_END) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,31560704) 
	e3:SetTarget(c11560704.datg) 
	e3:SetOperation(c11560704.daop) 
	c:RegisterEffect(e3) 
end 
c11560704.SetCard_SR_Saier=true 
function c11560704.sbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()~=0 end 
end 
function c11560704.sbop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	-- 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_BATTLE_CONFIRM) 
	e1:SetCondition(c11560704.dacon) 
	e1:SetOperation(c11560704.daop)  
	e1:SetReset(RESET_PHASE+PHASE_END,3) 
	Duel.RegisterEffect(e1,tp)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(c11560704.actcon) 
	e2:SetReset(RESET_PHASE+PHASE_END,3) 
	Duel.RegisterEffect(e2,tp)
	--sp 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e3:SetCode(EVENT_PHASE+PHASE_END) 
	e3:SetCountLimit(1) 
	e3:SetLabel(0) 
	e3:SetOperation(c11560704.xspop)  
	Duel.RegisterEffect(e3,tp) 
end 
function c11560704.dacon(e,tp,eg,ep,ev,re,r,rp)  
	local bc=Duel.GetAttacker()
	return bc and bc:IsControler(tp)  
end 
function c11560704.daop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	Duel.Damage(1-tp,1600,REASON_EFFECT) 
end 
function c11560704.actcon(e) 
	local ac=Duel.GetAttacker() 
	local bc=Duel.GetAttackTarget() 
	return (ac and ac:IsControler(tp)) or (bc and bc:IsControler(tp)) 
end 
function c11560704.xspop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetOwner() 
	local x=e:GetLabel() 
	local x=x+1 
	e:SetLabel(x) 
	c:SetTurnCounter(x) 
	if x==3 then 
		e:Reset()
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then  
		--immune
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(function(e,te)
		return te:GetOwner()~=e:GetOwner() end) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		c:RegisterEffect(e1)
		end 
	end 
end 
function c11560704.disop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(c11560704.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(c:GetFieldID())
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetTarget(c11560704.disable)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabel(c:GetFieldID())
	Duel.RegisterEffect(e2,tp)
	c:RegisterFlagEffect(11560704,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1,c:GetFieldID())
end 
function c11560704.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsControler(1-tp) and rc:IsOnField() and rc:GetFlagEffectLabel(11560704)~=e:GetLabel()
end
function c11560704.disable(e,c)
	return c:GetFlagEffectLabel(11560704)~=e:GetLabel() and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end
function c11560704.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end  
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,g:GetCount()*500)
end 
function c11560704.daop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
	Duel.Damage(1-tp,g:GetCount()*500,REASON_EFFECT) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(g:GetCount()*500) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1) 
	end 
end 












