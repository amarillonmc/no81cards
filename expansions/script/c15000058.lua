local m=15000058
local cm=_G["c"..m]
cm.name="色带神·哈斯塔"
function cm.initial_effect(c)
	--xyz summon  
	c:EnableReviveLimit()  
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,3,5)
	--pendulum summon  
	aux.EnablePendulumAttribute(c,false)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e2)
	--change Pscale
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetCode(EFFECT_CHANGE_LSCALE)  
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE) 
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(cm.cpcon)
	e3:SetValue(cm.p1val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()  
	e4:SetCode(EFFECT_CHANGE_RSCALE)
	e4:SetValue(cm.p2val)
	c:RegisterEffect(e4)
	--when Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)  
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e5:SetCode(EVENT_DESTROYED)  
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e5:SetRange(LOCATION_PZONE)  
	e5:SetCountLimit(1,15010058)
	e5:SetCondition(cm.srcon)
	e5:SetOperation(cm.srop)  
	c:RegisterEffect(e5)
	--cannot target  
	local e6=Effect.CreateEffect(c)  
	e6:SetType(EFFECT_TYPE_SINGLE)  
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e6:SetRange(LOCATION_MZONE)  
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e6:SetValue(aux.tgoval)  
	c:RegisterEffect(e6)  
	--indes  
	local e7=Effect.CreateEffect(c)  
	e7:SetType(EFFECT_TYPE_SINGLE)  
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e7:SetRange(LOCATION_MZONE)  
	e7:SetValue(aux.indoval)  
	c:RegisterEffect(e7)
	--negate  
	local e8=Effect.CreateEffect(c)   
	e8:SetCategory(CATEGORY_NEGATE)  
	e8:SetType(EFFECT_TYPE_QUICK_O)  
	e8:SetCode(EVENT_CHAINING)  
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e8:SetRange(LOCATION_MZONE)  
	e8:SetCountLimit(1,m)  
	e8:SetCondition(cm.discon)  
	e8:SetCost(cm.discost)
	e8:SetTarget(cm.distg)  
	e8:SetOperation(cm.disop)  
	c:RegisterEffect(e8)
end
function cm.mfilter(c,xyzc)  
	return c:IsXyzType(TYPE_PENDULUM) 
end  
function cm.xyzcheck(g)  
	return g:GetClassCount(Card.GetLeftScale)==1  
end
function cm.atkfilter(c,xyzc)  
	return c:IsType(TYPE_XYZ) 
end  
function cm.atkval(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetOverlayCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)*700
end
function cm.cpcon(e)  
	return Duel.IsExistingMatchingCard(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
end
function cm.p1val(e,tp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,e:GetHandler())
	if g:GetCount()==0 then return 4 end
	local tc=g:GetFirst()
	if not tc:GetType(TYPE_PENDULUM) then return 4 end
	if tc:IsSetCard(0x1f33) then return 4 end
	return tc:GetLeftScale()
end
function cm.p2val(e,tp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,e:GetHandler())
	if g:GetCount()==0 then return 4 end
	local tc=g:GetFirst()
	if not tc:GetType(TYPE_PENDULUM) then return 4 end
	if tc:IsSetCard(0x1f33) then return 4 end
	return tc:GetRightScale()
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp) 
	local tp=e:GetHandlerPlayer() 
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)  
end  
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler(),TYPE_PENDULUM) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,e:GetHandler(),TYPE_PENDULUM)  
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end
function cm.c3filter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tp=e:GetHandlerPlayer()
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	local g=Duel.GetMatchingGroup(cm.c3filter,e:GetHandlerPlayer(),LOCATION_PZONE,0,nil)
	if g:GetCount()==2 then
		local cc=g:GetFirst()
		local lsc=cc:GetLeftScale()
		local dc=g:GetNext()
		local l2sc=dc:GetLeftScale()
		if (lsc==l2sc or lsc==l2sc-1 or lsc==l2sc+1) then
			Duel.SetChainLimit(aux.FALSE)
		end
	end
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()  
	if Duel.NegateActivation(ev) then
		local tc=re:GetHandler()
		tc:CancelToGrave()
		local ovg=tc:GetOverlayGroup()
		if ovg:GetCount()~=0 then
		   Duel.Overlay(c,ovg)
		end
		Duel.Overlay(c,tc)
	end  
end  
function cm.desfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceup() and c:IsSetCard(0xf33)
end
function cm.cfilter(c,tp)  
	return c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp  
end
function cm.srcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(cm.cfilter,1,nil,tp)
end 
function cm.srop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ag=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if ag:GetCount()~=0 then
		Duel.SendtoHand(ag,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,ag)
	end
end