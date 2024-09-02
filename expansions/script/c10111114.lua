function c10111114.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c10111114.mfilter,5,3,c10111114.ovfilter,aux.Stringid(10111114,0),3,c10111114.xyzop)
	c:EnableReviveLimit()
	--destroy replace  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_DESTROY_REPLACE)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetTarget(c10111114.reptg)  
	e1:SetValue(c10111114.repval)  
    e1:SetOperation(c10111114.operation)
	c:RegisterEffect(e1)
	--attack up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111114,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_DETACH_MATERIAL)
	e2:SetTarget(c10111114.atktg)
	e2:SetOperation(c10111114.atkop)
	c:RegisterEffect(e2)
    	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10111114,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c10111114.descon)
	e3:SetTarget(c10111114.destg1)
	e3:SetOperation(c10111114.desop1)
	c:RegisterEffect(e3)
end
function c10111114.mfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c10111114.ovfilter(c)
	return c:IsFaceup() and c:IsCode(23232295)
end
function c10111114.repfilter(c,tp)  
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x1084) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)  
end  
function c10111114.reptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return eg:IsExists(c10111114.repfilter,1,nil,tp)  
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end  
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then  
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)  
		return true  
	end  
	return false  
end 
function c10111114.repval(e,c)  
	return c10111114.repfilter(c,e:GetHandlerPlayer())  
end
function c10111114.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,800,REASON_EFFECT,true)
	Duel.Recover(tp,800,REASON_EFFECT,true)
	Duel.RDComplete()
end
function c10111114.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1084)
end
function c10111114.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
end
function c10111114.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c10111114.atkfilter,tp,LOCATION_MZONE,0,nil)
	if tg:GetCount()>0 then
		local sc=tg:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(800)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=tg:GetNext()
		end
	end
end
function c10111114.descon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c10111114.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10111114.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end