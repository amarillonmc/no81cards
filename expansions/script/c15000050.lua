local m=15000050
local cm=_G["c"..m]
cm.name="色带神·道罗斯"
function cm.initial_effect(c)
	--pendulum summon  
	aux.EnablePendulumAttribute(c)
	--change Pscale
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_CHANGE_LSCALE)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE) 
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c15000050.cpcon)
	e1:SetValue(c15000050.p1val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()  
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	e2:SetValue(c15000050.p2val)
	c:RegisterEffect(e2)
	--when Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_DESTROYED)  
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,15000050)
	e3:SetCondition(c15000050.spcon)
	e3:SetOperation(c15000050.spop)  
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_SPSUMMON_PROC)  
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e4:SetRange(LOCATION_HAND)  
	e4:SetCountLimit(1,15010050)  
	e4:SetCondition(c15000050.sd2con) 
	c:RegisterEffect(e4)
	--destroy  
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)  
	e5:SetType(EFFECT_TYPE_QUICK_O)  
	e5:SetCode(EVENT_FREE_CHAIN)  
	e5:SetRange(LOCATION_MZONE)  
	e5:SetCountLimit(1,15020050) 
	e5:SetHintTiming(0,TIMING_MAIN_END)  
	e5:SetCondition(c15000050.descon)
	e5:SetOperation(c15000050.desop)  
	c:RegisterEffect(e5)
end
function c15000050.cpcon(e)  
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	return g:GetCount()~=0 and (g:GetFirst():GetLeftScale()~=e:GetHandler():GetLeftScale() or g:GetFirst():GetRightScale()~=e:GetHandler():GetRightScale())
end
function c15000050.p1val(e,tp)
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	if g:GetCount()==0 then return 4 end
	local tc=g:GetFirst()
	if not tc:GetType(TYPE_PENDULUM) then return 4 end
	if tc:IsSetCard(0x3f33) then return 4 end
	return tc:GetLeftScale()
end
function c15000050.p2val(e,tp)
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	if g:GetCount()==0 then return 4 end
	local tc=g:GetFirst()
	if not tc:GetType(TYPE_PENDULUM) then return 4 end
	if tc:IsSetCard(0x3f33) then return 4 end
	return tc:GetRightScale()
end
function c15000050.desfilter(c)
	return c:IsSetCard(0xf33) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(15000050)
end
function c15000050.cfilter(c,tp)  
	return c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp  
end
function c15000050.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c15000050.cfilter,1,nil,tp)
end 
function c15000050.spop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ag=Duel.SelectMatchingCard(tp,c15000050.desfilter,tp,LOCATION_DECK,0,1,1,e:GetHandler())
	if ag:GetCount()~=0 then
		Duel.SendtoHand(ag,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,ag)
	end
end
function c15000050.sd2filter(c)
	return c:IsSetCard(0x3f33) and c:IsFaceup()
end
function c15000050.c3filter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end 
function c15000050.sd2con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c15000050.c3filter,e:GetHandlerPlayer(),LOCATION_PZONE,0,nil)
	if g:GetCount()~=2 then return false end
	local cc=g:GetFirst()
	local lsc=cc:GetLeftScale()
	local dc=g:GetNext()
	local l2sc=dc:GetLeftScale()
	return (lsc==l2sc or lsc==l2sc-1 or lsc==l2sc+1) and Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(c15000050.sd2filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c15000050.descon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2  
end  
function c15000050.desop(e,tp,eg,ep,ev,re,r,rp)  
	local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil) 
	if dg:GetCount()~=0 then
		local qc=dg:GetFirst()
		local seq1=qc:GetSequence()
		local cg=qc:GetColumnGroup()
		Duel.Destroy(qc,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Destroy(cg,REASON_EFFECT)
	end
end