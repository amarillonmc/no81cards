--红莲之誓·安卡
function c82206097.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c82206097.lcheck)
	c:EnableReviveLimit() 
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--Destroy
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c82206097.dscon)
	e2:SetOperation(c82206097.dsop)
	c:RegisterEffect(e2)  
	--get 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82206097,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,82206097)  
	e3:SetTarget(c82206097.gttg)
	e3:SetOperation(c82206097.gtop) 
	c:RegisterEffect(e3)
end 
function c82206097.lcheck(g)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_FIRE)
end
function c82206097.ckfil(c)
	return c:GetBaseAttack()~=c:GetAttack() 
end
function c82206097.dscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82206097.ckfil,tp,0,LOCATION_MZONE,1,nil) 
end 
function c82206097.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,82206097)  
	local g=Duel.GetMatchingGroup(c82206097.ckfil,tp,0,LOCATION_MZONE,nil) 
	Duel.Destroy(g,REASON_EFFECT) 
end
function c82206097.xckfil(c,tp) 
	return c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT)
end 
function c82206097.gttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c82206097.xckfil,1,nil,tp) end 
end  
function c82206097.gtop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82206097,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c82206097.xgtcon)
	e1:SetOperation(c82206097.xgtop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetLabelObject(e1)
	e2:SetCondition(c82206097.xgtcon)
	e2:SetOperation(c82206097.clearop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
function c82206097.xgtcon(e,tp)
	return Duel.GetTurnPlayer()==tp
end  
function c82206097.clearop(e,tp,eg,ep,ev,re,r,rp)   
	local te=e:GetLabelObject()
	te:Reset()
	e:Reset()
end

function c82206097.xgtop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82206097,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c82206097.dacon)
	e2:SetOperation(c82206097.daop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end 
function c82206097.dacon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE)
end
function c82206097.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget() 
	local atk=tc:GetBaseAttack()
	Duel.Hint(HINT_CARD,0,82206097) 
	Duel.Damage(1-tp,atk,REASON_EFFECT) 
end




