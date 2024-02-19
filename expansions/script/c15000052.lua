local m=15000052
local cm=_G["c"..m]
cm.name="色带神·修德梅尔"
function cm.initial_effect(c)
	--pendulum summon  
	aux.EnablePendulumAttribute(c)
	--change Pscale
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_CHANGE_LSCALE)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE) 
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c15000052.cpcon)
	e1:SetValue(c15000052.p1val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()  
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	e2:SetValue(c15000052.p2val)
	c:RegisterEffect(e2)
	--destroy  
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,15000052)  
	e3:SetCondition(c15000052.descon)
	e3:SetOperation(c15000052.desop)  
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_SPSUMMON_PROC)  
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e4:SetRange(LOCATION_HAND)  
	e4:SetCountLimit(1,15010052)  
	e4:SetCondition(c15000052.sd2con) 
	c:RegisterEffect(e4)
	--lv change  
	local e5=Effect.CreateEffect(c)  
	e5:SetType(EFFECT_TYPE_IGNITION)  
	e5:SetRange(LOCATION_MZONE)  
	e5:SetCountLimit(1)  
	e5:SetTarget(c15000052.lvtg)  
	e5:SetOperation(c15000052.lvop)  
	c:RegisterEffect(e5)
	--nontuner
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_NONTUNER)
	e6:SetValue(c15000052.tnval)
	c:RegisterEffect(e6)
end
function c15000052.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
function c15000052.cpcon(e)  
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	return g:GetCount()~=0 and (g:GetFirst():GetLeftScale()~=e:GetHandler():GetLeftScale() or g:GetFirst():GetRightScale()~=e:GetHandler():GetRightScale())
end
function c15000052.p1val(e,tp)
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	if g:GetCount()==0 then return 4 end
	local tc=g:GetFirst()
	if not tc:GetType(TYPE_PENDULUM) then return 4 end
	if tc:IsSetCard(0x3f33) then return 4 end
	return tc:GetLeftScale()
end
function c15000052.p2val(e,tp)
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	if g:GetCount()==0 then return 4 end
	local tc=g:GetFirst()
	if not tc:GetType(TYPE_PENDULUM) then return 4 end
	if tc:IsSetCard(0x3f33) then return 4 end
	return tc:GetRightScale()
end
function c15000052.desfilter(c)
	return c:IsSetCard(0xf33) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand()
end
function c15000052.descon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(c15000052.desfilter,tp,LOCATION_DECK,0,1,nil)
end
function c15000052.desop(e,tp,eg,ep,ev,re,r,rp) 
	local tp=e:GetHandlerPlayer()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ag=Duel.SelectMatchingCard(tp,c15000052.desfilter,tp,LOCATION_DECK,0,1,1,nil)
	if ag:GetCount()~=0 then
		Duel.SendtoHand(ag,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,ag)
	end
	Duel.BreakEffect()
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c15000052.sd2filter(c)
	return c:IsSetCard(0x3f33) and c:IsFaceup()
end
function c15000052.c3filter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end 
function c15000052.sd2con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c15000052.c3filter,e:GetHandlerPlayer(),LOCATION_PZONE,0,nil)
	if g:GetCount()~=2 then return false end
	local cc=g:GetFirst()
	local lsc=cc:GetLeftScale()
	local dc=g:GetNext()
	local l2sc=dc:GetLeftScale()
	return (lsc==l2sc or lsc==l2sc-1 or lsc==l2sc+1) and Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(c15000052.sd2filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c15000052.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end  
	if chk==0 then return e:GetHandler():IsLocation(LOCATION_MZONE) end
	local lv=e:GetHandler():GetLevel()  
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)  
	local x=Duel.AnnounceLevel(tp,1,5,lv)
	e:SetLabel(x)
end  
function c15000052.lvop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_CHANGE_LEVEL)  
		e1:SetValue(e:GetLabel())  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		c:RegisterEffect(e1)  
	end  
end