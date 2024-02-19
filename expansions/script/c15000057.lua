local m=15000057
local cm=_G["c"..m]
cm.name="色带神·伟大之克苏鲁"
function cm.initial_effect(c)
	--limit SSummon  
	c:SetSPSummonOnce(15000057) 
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep(c,c15000057.ffilter,3,false)
	local e0=aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE+LOCATION_PZONE,0,Duel.Release,REASON_COST)
	e0:SetCondition(c15000057.spcon)
	--pendulum summon  
	aux.EnablePendulumAttribute(c,false)
	--spsummon condition  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e1:SetValue(aux.fuslimit)  
	c:RegisterEffect(e1)
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
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c15000057.discon)
	e2:SetOperation(c15000057.disop)
	c:RegisterEffect(e2)
	--activity check
	Duel.AddCustomActivityCounter(15000057,ACTIVITY_CHAIN,c15000057.chainfilter)
end
function c15000057.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsCode(15000060))
end
function c15000057.ffilter(c,fc,sub,mg,sg)  
	return c:IsType(TYPE_PENDULUM) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or (sg:IsExists(c15000057.f2filter,1,c,c:GetLeftScale()) and not sg:IsExists(c15000057.f3filter,1,c,c:GetLeftScale())))
end
function c15000057.f2filter(c,les)
	return c:IsFusionType(TYPE_PENDULUM) and (c:GetLeftScale()==les or c:GetLeftScale()==les+1 or c:GetLeftScale()==les-1)
end
function c15000057.f3filter(c,les)
	return c:IsFusionType(TYPE_PENDULUM) and (c:GetLeftScale()<=les-2 or c:GetLeftScale()>=les+2)
end
function c15000057.spcon(e,c)  
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(aux.ContactFusionMaterialFilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,c,c,Card.IsReleasable)
	return Duel.GetCustomActivityCount(15000057,tp,ACTIVITY_CHAIN)>0 and c:CheckFusionMaterial(mg,nil,tp|0x200) 
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
	if tc:IsSetCard(0x3f33) then return 4 end
	return tc:GetLeftScale()
end
function c15000057.p2val(e,tp)
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	if g:GetCount()==0 then return 4 end
	local tc=g:GetFirst()
	if not tc:GetType(TYPE_PENDULUM) then return 4 end
	if tc:IsSetCard(0x3f33) then return 4 end
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
function c15000057.c3filter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end 
function c15000057.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c15000043.c3filter,e:GetHandlerPlayer(),LOCATION_PZONE,0,nil)
	if g:GetCount()~=2 then return false end
	local cc=g:GetFirst()
	local lsc=cc:GetLeftScale()
	local dc=g:GetNext()
	local l2sc=dc:GetLeftScale()
	return (lsc==l2sc or lsc==l2sc-1 or lsc==l2sc+1) and Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)>0 
end
function c15000057.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return c15000057.sdcon(e,tp,eg,ep,ev,re,r,rp)
		and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
end
function c15000057.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end