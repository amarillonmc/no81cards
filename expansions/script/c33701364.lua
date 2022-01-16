--跨世界线勇跃锦标赛
local m=33701364
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<1 or (not c:IsRelateToEffect(e)) then return end
	Duel.ConfirmCards(tp,g)
	if g:GetClassCount(Card.GetCode)<=5 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
		--Effect Draw
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetRange(LOCATION_FZONE)
		e0:SetCode(EFFECT_CHANGE_DAMAGE)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e0:SetTargetRange(0,1)
		e0:SetValue(cm.val)
		c:RegisterEffect(e0)  
	end
	if g:GetClassCount(Card.GetCode)>=30 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_FZONE)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(cm.val1)
		c:RegisterEffect(e1)  
	end
	if g:GetClassCount(Card.GetCode)>=40 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetRange(LOCATION_FZONE)
		e2:SetCode(EFFECT_CHANGE_DAMAGE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetValue(cm.val2)
		c:RegisterEffect(e2)  
		
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetRange(LOCATION_FZONE)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e3:SetValue(1)
		c:RegisterEffect(e3)
	end
	if g:GetClassCount(Card.GetCode)>=52 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetRange(LOCATION_FZONE)
		e4:SetTargetRange(LOCATION_ONFIELD,0)
		e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e4:SetValue(cm.target)
		c:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)  
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e5:SetCode(EVENT_CHAINING) 
		e5:SetRange(LOCATION_FZONE) 
		e5:SetCountLimit(1)
		e5:SetOperation(cm.actop) 
		c:RegisterEffect(e5)
	end
end
function cm.val(e,re,dam,r,rp,rc)
	return dam*3
end
function cm.val1(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then
		return 0
	end
	return val
end
function cm.val2(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 0
	end
	return val
end
function cm.target(e,c)
	return c~=e:GetHandler()
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)  
	local rc=re:GetHandler()  
	if re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and ep==tp then  
		Duel.SetChainLimit(cm.chainlm)  
	end  
end  
function cm.chainlm(e,rp,tp)  
	return tp==rp
end