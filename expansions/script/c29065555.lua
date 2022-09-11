--方舟骑士-玛恩纳
function c29065555.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3,c29065555.ovfilter,aux.Stringid(29065555,0),3,c29065555.xyzop)
	c:EnableReviveLimit()  
	--battle  
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,29065555) 
	e1:SetCost(c29065555.btcost) 
	e1:SetTarget(c29065555.bttg) 
	e1:SetOperation(c29065555.btop) 
	c:RegisterEffect(e1)   
	--double 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(EFFECT_SET_BASE_ATTACK) 
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCondition(c29065555.atkcon)
	e2:SetValue(c29065555.atkval)  
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e3:SetCode(EVENT_PHASE+PHASE_END) 
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1) 
	e3:SetCondition(c29065555.ckcon)
	e3:SetOperation(c29065555.ckop) 
	c:RegisterEffect(e3)
end 
function c29065555.ovfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) 
end
function c29065555.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,29065555)==0 and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x10ae,2,REASON_EFFECT) end   
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x10ae,2,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,29065555,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c29065555.btcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end 
function c29065555.bttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c29065555.btop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	--attack all
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
	end 
	--direct 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_DIRECT_ATTACK) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetTarget(c29065555.drttg)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e1,tp) 
end 
function c29065555.drttg(e,c) 
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_BEASTWARRIOR)	 
end 
function c29065555.atkcon(e) 
	return e:GetHandler():GetFlagEffect(29065555)~=0  
end 
function c29065555.atkval(e) 
	return e:GetHandler():GetBaseAttack()*2  
end  
function c29065555.ckcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnPlayer()~=tp  
end 
function c29065555.ckop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:GetAttackAnnouncedCount()==0 then 
	Duel.Hint(HINT_CARD,0,29065555) 
	c:RegisterFlagEffect(29065555,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(29065555,1)) 
	elseif c:GetAttackAnnouncedCount()~=0 and c:GetFlagEffect(29065555) then 
	c:ResetFlagEffect(29065555) 
	end 
end 






