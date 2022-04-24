--浩渺之源·努恩
function c82206099.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c82206099.lcheck)
	c:EnableReviveLimit() 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--bp
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_BP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c82206099.bpcon)
	c:RegisterEffect(e2)  
	--get 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82206099,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,82206099)  
	e3:SetTarget(c82206099.gttg)
	e3:SetOperation(c82206099.gtop) 
	c:RegisterEffect(e3)	
end
function c82206099.lcheck(g)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_WATER)
end
function c82206099.bpcon(e) 
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) 
end
function c82206099.xckfil(c,tp) 
	return c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT)
end 
function c82206099.gttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c82206099.xckfil,1,nil,tp) end 
end  
function c82206099.gtop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	--  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82206099,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c82206099.xgtcon)
	e1:SetOperation(c82206099.xgtop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetLabelObject(e1)
	e2:SetCondition(c82206099.xgtcon)
	e2:SetOperation(c82206099.clearop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
function c82206099.xgtcon(e,tp)
	return Duel.GetTurnPlayer()==tp
end  
function c82206099.clearop(e,tp,eg,ep,ev,re,r,rp)   
	local te=e:GetLabelObject()
	te:Reset()
	e:Reset()
end
function c82206099.xgttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end  
function c82206099.xgtop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82206099,1))  
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c82206099.rccon)
	e2:SetOperation(c82206099.rcop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2) 
end 
function c82206099.rccon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp 
end
function c82206099.rcop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()   
	Duel.Hint(HINT_CARD,0,82206099)
	Duel.Recover(tp,ev,REASON_EFFECT)
end

