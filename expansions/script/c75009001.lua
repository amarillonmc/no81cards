--向破晓起誓的双忍 萨琪娜&米卡娅
function c75009001.initial_effect(c) 
	--damage 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c75009001.damcon)
	e1:SetOperation(c75009001.damop)
	c:RegisterEffect(e1) 
	--chain attack 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(75009001,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_BATTLE_DESTROYING) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,75009001)
	e2:SetCondition(c75009001.chacon)
	e2:SetTarget(c75009001.chatg)
	e2:SetOperation(c75009001.chaop)
	c:RegisterEffect(e2) 
	--eff 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75009001,1)) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCountLimit(1,15009001)
	e3:SetTarget(c75009001.efftg)
	e3:SetOperation(c75009001.effop)
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75009001,1)) 
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_CHAINING) 
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,15009001)
	e4:SetCondition(c75009001.effcon)
	e4:SetTarget(c75009001.efftg)
	e4:SetOperation(c75009001.effop)
	c:RegisterEffect(e4)
end
function c75009001.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c==Duel.GetAttacker() 
end
function c75009001.damop(e,tp,eg,ep,ev,re,r,rp) 
	local x=0 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) 
	local tc=g:GetFirst() 
	while tc do 
	if tc:GetAttack()<tc:GetBaseAttack() then x=x+(tc:GetBaseAttack()-tc:GetAttack()) end 
	if tc:GetDefense()<tc:GetBaseDefense() then x=x+(tc:GetBaseDefense()-tc:GetDefense()) end 
	tc=g:GetNext() 
	end 
	Duel.ChangeBattleDamage(ep,ev+x) 
end
function c75009001.chacon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) 
end
function c75009001.chatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c75009001.chaop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end 
function c75009001.effcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c75009001.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c75009001.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK)  
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(-700)  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT) 
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(function(e,c)
	return e:GetOwner():GetAttack()>c:GetDefense() end)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_END,2) 
	Duel.RegisterEffect(e2,tp)
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_DEFENSE)  
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(-700)  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT) 
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(function(e,c)
	return e:GetOwner():GetAttack()>c:GetDefense() end)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_END,2) 
	Duel.RegisterEffect(e2,tp)
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_CANNOT_ATTACK)  
	e1:SetRange(LOCATION_MZONE) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT) 
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(function(e,c)
	return e:GetOwner():GetAttack()>c:GetDefense() end)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_END,2) 
	Duel.RegisterEffect(e2,tp)
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)  
	e1:SetTarget(c75009001.edamtg) 
	e1:SetOperation(c75009001.edamop) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT) 
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(function(e,c)
	return e:GetOwner():GetAttack()>c:GetDefense() end)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_END,2) 
	Duel.RegisterEffect(e2,tp)
end
function c75009001.edamtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(700) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,700) 
end 
function c75009001.edamop(e,tp,eg,ep,ev,re,r,rp) 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT) 
end 





