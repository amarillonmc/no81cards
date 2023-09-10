--幻想异闻录#FE “狙击手”长弓
function c75070003.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c75070003.lcheck)
	c:EnableReviveLimit()   
	--lock 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetTarget(c75070003.lktg) 
	e1:SetOperation(c75070003.lkop) 
	c:RegisterEffect(e1)  
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(function(e,c,tp,r)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and r==REASON_EFFECT end)
	c:RegisterEffect(e2) 
	--draw 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DRAW)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return aux.dsercon(e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():GetBattleTarget()==nil  end)
	e3:SetTarget(c75070003.drtg)
	e3:SetOperation(c75070003.drop)
	c:RegisterEffect(e3)  
end
function c75070003.lcheck(g)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_LIGHT) 
end   
function c75070003.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetChainLimit(c75070003.chlimit)
end
function c75070003.chlimit(e,ep,tp)
	return not e:IsActiveType(TYPE_MONSTER) 
end
function c75070003.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()   
	local p=Duel.GetTurnPlayer()
	--check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_PHASE+PHASE_END) 
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetAttackTarget()==nil end)
	e1:SetOperation(c75070003.checkop)
	Duel.RegisterEffect(e1,p)
	--cannot announce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(c75070003.atkcon)
	e2:SetTarget(c75070003.atktg)
	e1:SetLabelObject(e2)
	Duel.RegisterEffect(e2,p)
end 
function c75070003.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,75070003)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	Duel.RegisterFlagEffect(tp,75070003,RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
function c75070003.atkcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),75070003)>0
end
function c75070003.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c75070003.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end 
function c75070003.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM) 
	Duel.Draw(p,d,REASON_EFFECT) 
end 






