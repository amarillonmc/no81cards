local m=15000057
local cm=_G["c"..m]
cm.name="色带神·伟大之克苏鲁"
function cm.initial_effect(c)
	--limit SSummon  
	c:SetSPSummonOnce(15000057) 
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep(c,c15000057.ffilter,3,false)
	--pendulum summon  
	aux.EnablePendulumAttribute(c,false)
	--spsummon condition  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e1:SetValue(aux.fuslimit)  
	c:RegisterEffect(e1)
	--special summon rule  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_SPSUMMON_PROC)  
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c15000057.spcon)  
	e2:SetOperation(c15000057.spop)  
	c:RegisterEffect(e2)
	--immune  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetCode(EFFECT_IMMUNE_EFFECT)  
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c15000057.econ)  
	e3:SetValue(c15000057.efilter)  
	c:RegisterEffect(e3)
	--act limit  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e4:SetCode(EVENT_CHAINING)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCondition(c15000057.limcon)  
	e4:SetOperation(c15000057.limop)  
	c:RegisterEffect(e4) 
	--change Pscale
	local e6=Effect.CreateEffect(c) 
	e6:SetType(EFFECT_TYPE_SINGLE)  
	e6:SetCode(EFFECT_CHANGE_LSCALE)  
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE) 
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(c15000057.cpcon)
	e6:SetValue(c15000057.p1val)
	c:RegisterEffect(e6)
	local e7=e6:Clone()  
	e7:SetCode(EFFECT_CHANGE_RSCALE)
	e7:SetValue(c15000057.p2val)
	c:RegisterEffect(e7)
	--back tohand
	local e8=Effect.CreateEffect(c)  
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e8:SetRange(LOCATION_PZONE)  
	e8:SetCountLimit(1)  
	e8:SetCode(EVENT_PHASE+PHASE_STANDBY)  
	e8:SetCondition(c15000057.thcon)  
	e8:SetOperation(c15000057.thop)  
	c:RegisterEffect(e8)

	Duel.AddCustomActivityCounter(15000057,ACTIVITY_CHAIN,c15000057.chainfilter)
end
function c15000057.chainfilter(re,tp,cid)  
	return not re:GetHandler():IsCode(15000060)
end  
function c15000057.ffilter(c,fc,sub,mg,sg)  
	return c:IsType(TYPE_PENDULUM) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:IsExists(c15000057.f2filter,1,c,c:GetLeftScale()))
end
function c15000057.f2filter(c,les)
	return c:IsFusionType(TYPE_PENDULUM) and (c:GetLeftScale()==les or c:GetLeftScale()==les+1 or c:GetLeftScale()==les-1)
end
function c15000057.spfilter(c,fc,tp)  
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xf33) and not c:IsFusionType(TYPE_FUSION) and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,c,fc)>0 and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL)  
end  
function c15000057.spcon(e,c)  
	if c==nil then return true end  
	local tp=e:GetHandlerPlayer() 
	return ((Duel.GetCustomActivityCount(15000057,tp,ACTIVITY_CHAIN)~=0 or Duel.GetCustomActivityCount(15000057,1-tp,ACTIVITY_CHAIN)~=0) or (Duel.GetFlagEffect(tp,15000060)~=0) or Duel.GetFlagEffect(1-tp,15000060)~=0) and Duel.IsExistingMatchingCard(c15000057.spfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,2,nil,e:GetHandler(),tp)
end  
function c15000057.spop(e,tp,eg,ep,ev,re,r,rp,c)  
	local tp=e:GetHandlerPlayer()
	local g=Duel.SelectMatchingCard(tp,c15000057.spfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,2,2,nil,e:GetHandler(),tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)  
end
function c15000057.c3filter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end 
function c15000057.econ(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c15000057.c3filter,e:GetHandlerPlayer(),LOCATION_PZONE,0,nil)
	if g:GetCount()~=2 then return false end
	local cc=g:GetFirst()
	local lsc=cc:GetLeftScale()
	local dc=g:GetNext()
	local l2sc=dc:GetLeftScale()
	return (lsc==l2sc or lsc==l2sc-1 or lsc==l2sc+1)
end
function c15000057.efilter(e,re)  
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()  
end
function c15000057.cpcon(e)  
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	return g:GetCount()~=0 and (g:GetFirst():GetLeftScale()~=e:GetHandler():GetLeftScale() or g:GetFirst():GetRightScale()~=e:GetHandler():GetRightScale())
end
function c15000057.p1val(e,tp)
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	if g:GetCount()==0 then return 4 end
	local tc=g:GetFirst()
	if not tc:GetType(TYPE_PENDULUM) then return 4 end
	if tc:IsSetCard(0x1f33) then return 4 end
	return tc:GetLeftScale()
end
function c15000057.p2val(e,tp)
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	if g:GetCount()==0 then return 4 end
	local tc=g:GetFirst()
	if not tc:GetType(TYPE_PENDULUM) then return 4 end
	if tc:IsSetCard(0x1f33) then return 4 end
	return tc:GetRightScale()
end
function c15000057.thfilter(c)  
	return c:IsAbleToHand() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c15000057.thcon(e)  
	local g=Duel.GetMatchingGroup(Card.IsType,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler(),TYPE_PENDULUM)
	return g:GetCount()~=0 and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c15000057.thop(e)  
	Duel.Hint(HINT_CARD,0,15000057)
	local tp=e:GetHandlerPlayer()
	local g=Duel.SelectMatchingCard(1-tp,c15000057.thfilter,1-tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()~=0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c15000057.limcon(e,tp,eg,ep,ev,re,r,rp)  
	return re:IsHasType(EFFECT_TYPE_SINGLE) and (re:IsHasType(EFFECT_TYPE_TRIGGER_F) or re:IsHasType(EFFECT_TYPE_TRIGGER_O) or re:IsHasType(EFFECT_TYPE_QUICK_F) or re:IsHasType(EFFECT_TYPE_QUICK_O)) and re:IsHasProperty(EFFECT_FLAG_DELAY) and (bit.band(re:GetCode(),EVENT_SUMMON_SUCCESS)~=0 or bit.band(re:GetCode(),EVENT_SPSUMMON_SUCCESS)~=0) and re:GetHandler():IsLocation(LOCATION_MZONE)
end  
function c15000057.limop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.NegateActivation(ev)
end  