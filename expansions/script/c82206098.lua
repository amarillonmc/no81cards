--狂沙之主·萨特
function c82206098.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c82206098.lcheck)
	c:EnableReviveLimit() 
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--zone 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c82206098.zncon) 
	e2:SetOperation(c82206098.znop) 
	c:RegisterEffect(e2) 
	--get 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82206098,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,82206098)  
	e3:SetTarget(c82206098.gttg)
	e3:SetOperation(c82206098.gtop) 
	c:RegisterEffect(e3)
end
function c82206098.lcheck(g)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_EARTH)
end
function c82206098.ckfil(c,tp) 
	return c:IsPreviousControler(1-tp) and c:IsPreviousLocation(LOCATION_SZONE)
end 
function c82206098.zncon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c82206098.ckfil,nil,tp)==1 
end 
function c82206098.znop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,82206098) 
	local tc=eg:Filter(c82206098.ckfil,nil,tp):GetFirst() 
	local seq=tc:GetPreviousSequence() 
	local zone=aux.SequenceToGlobal(1-tp,LOCATION_SZONE,seq) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(zone)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end  
function c82206098.xckfil(c,tp) 
	return c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp 
	and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT)
end 
function c82206098.gttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c82206098.xckfil,1,nil,tp) end 
end  
function c82206098.gtop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	--  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82206098,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c82206098.xgtcon)
	e1:SetOperation(c82206098.xgtop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetLabelObject(e1)
	e2:SetCondition(c82206098.xgtcon)
	e2:SetOperation(c82206098.clearop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
function c82206098.xgtcon(e,tp)
	return Duel.GetTurnPlayer()==tp
end  
function c82206098.clearop(e,tp,eg,ep,ev,re,r,rp)   
	local te=e:GetLabelObject()
	te:Reset()
	e:Reset()
end
function c82206098.xgtop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82206098,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c82206098.drcon)
	e2:SetOperation(c82206098.daop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end 
function c82206098.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and Duel.IsPlayerCanDraw(tp,2)
end
function c82206098.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,82206098)
	Duel.Draw(tp,2,REASON_EFFECT)
end









