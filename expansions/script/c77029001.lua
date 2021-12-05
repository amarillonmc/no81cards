--PNC 克罗琦
function c77029001.initial_effect(c)
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	c:RegisterEffect(e1)
	--atk def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_REPEAT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c77029001.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3) 
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77029001,1))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,77029001)
	e4:SetCondition(c77029001.discon)
	e4:SetCost(c77029001.discost)
	e4:SetTarget(c77029001.distg)
	e4:SetOperation(c77029001.disop)
	c:RegisterEffect(e4)
	--up 
	local e5=Effect.CreateEffect(c)  
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c77029001.upcon)
	e5:SetTarget(c77029001.uptg)
	e5:SetOperation(c77029001.upop) 
	c:RegisterEffect(e5)
end
c77029001.named_with_PNC=true 
function c77029001.atkval(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local flag=Duel.GetFlagEffectLabel(tp,77029000)
	if flag==nil then  
	return 0 
	else 
	return flag*400
	end 
end
function c77029001.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c77029001.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local flag=Duel.GetFlagEffectLabel(tp,77029000) 
	if flag==nil then flag=0 end
	if chk==0 then return flag>=2 end 
	local te=Duel.IsPlayerAffectedByEffect(tp,77029000) 
	if te~=nil then 
	te:Reset() 
	end
	if flag-2>0 then 
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(77029000,flag-2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(77029000)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_REPEAT)  
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	end   
	local flag=Duel.GetFlagEffectLabel(tp,77029001) 
	if flag==nil then 
	Duel.RegisterFlagEffect(tp,77029001,0,0,0,2) 
	local te=Duel.IsPlayerAffectedByEffect(tp,77029001) 
	if te~=nil then 
	te:Reset() 
	end
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(77029001,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(77029001)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_REPEAT)  
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	else
	Duel.SetFlagEffectLabel(tp,77029001,flag+2) 
	local te=Duel.IsPlayerAffectedByEffect(tp,77029001) 
	if te~=nil then 
	te:Reset() 
	end
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(77029001,flag+2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(77029001)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_REPEAT)  
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	end 
end
function c77029001.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c77029001.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
	if g:GetCount()<2 then return end 
	local sg=g:RandomSelect(tp,2)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c77029001.upcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c77029001.uptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c77029001.upop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ev)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	if re:GetHandler().named_with_PNC and ev>=2000 then 
	-- 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	end
	end
end







