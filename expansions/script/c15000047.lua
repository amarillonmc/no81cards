local m=15000047
local cm=_G["c"..m]
cm.name="色带的侍从·米戈"
function cm.initial_effect(c)
	--pendulum summon  
	aux.EnablePendulumAttribute(c)
	--when pzone
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE) 
	e1:SetCountLimit(1,15000047)
	e1:SetCondition(c15000047.spcon)
	e1:SetOperation(c15000047.spop)  
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_SPSUMMON_PROC)  
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e2:SetRange(LOCATION_HAND)  
	e2:SetCountLimit(1,15010047)  
	e2:SetCondition(c15000047.sdcon)
	c:RegisterEffect(e2)
	--SendtoGrave and atk up
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_FREE_CHAIN)   
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,15020047)
	e3:SetCost(c15000047.atkcost)
	e3:SetOperation(c15000047.atkop)  
	c:RegisterEffect(e3)
end
function c15000047.spfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c15000047.sp2filter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xf33)
end
function c15000047.spcon(e)  
	local g=Duel.GetMatchingGroup(c15000047.spfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	local ag=Duel.GetMatchingGroup(c15000047.sp2filter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,nil)
	return g:GetCount()~=0 and ag:GetCount()~=0 and (g:GetFirst():GetLeftScale()==e:GetHandler():GetLeftScale() or g:GetFirst():GetLeftScale()==e:GetHandler():GetLeftScale()+1 or g:GetFirst():GetLeftScale()==e:GetHandler():GetLeftScale()-1)
end
function c15000047.spop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	Duel.BreakEffect()
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(15000047,0))
		local g=Duel.SelectMatchingCard(tp,c15000047.sp2filter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()~=0 then
			local tc=g:GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
			e1:SetValue(c15000047.efilter)  
			tc:RegisterEffect(e1)
		end
	end
end
function c15000047.efilter(e,re,rp,c)  
	return re:GetOwner()==c  
end
function c15000047.c3filter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end 
function c15000047.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c15000047.c3filter,e:GetHandlerPlayer(),LOCATION_PZONE,0,nil)
	if g:GetCount()~=2 then return false end
	local cc=g:GetFirst()
	local lsc=cc:GetLeftScale()
	local dc=g:GetNext()
	local l2sc=dc:GetLeftScale()
	return (lsc==l2sc or lsc==l2sc-1 or lsc==l2sc+1) and Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)>0 
end
function c15000047.atkfilter(c,e,tp)
	return ((c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)) or c:IsLocation(LOCATION_DECK)) and c:IsType(TYPE_PENDULUM)
end
function c15000047.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c15000047.atkfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,c15000047.atkfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetBaseAttack())  
	Duel.SendtoGrave(g,REASON_COST)  
end
function c15000047.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=e:GetLabel()
	if c:IsFaceup() and c:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetValue(x)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)  
		c:RegisterEffect(e1)  
	end
end