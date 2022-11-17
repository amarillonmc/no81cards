--欲王龙 翼角暴徽
function c25000029.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c25000029.ffilter,3,false)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)  
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c25000029.splimit)
	c:RegisterEffect(e1)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,25000029)
	e1:SetTarget(c25000029.dstg)
	e1:SetOperation(c25000029.dsop)  
	c:RegisterEffect(e1)  
	--set 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,15000029)
	e2:SetTarget(c25000029.sttg) 
	e2:SetOperation(c25000029.stop)
	c:RegisterEffect(e2)
	--limit 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(25000029,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,35000029)
	e3:SetCondition(c25000029.lmcon)
	e3:SetTarget(c25000029.lmtg)
	e3:SetOperation(c25000029.lmop)
	c:RegisterEffect(e3)
end
function c25000029.ffilter(c,fc,sub,mg,sg)
	return ( not sg or sg:GetClassCount(Card.GetCode)==sg:GetCount()) and c:IsRace(RACE_DINOSAUR)
end
function c25000029.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c25000029.dstg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
	local x=g:GetCount()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,x,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,x,tp,LOCATION_DECK)
end 
function c25000029.dsop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
	local x=g:GetCount()
	local dg=Duel.GetDecktopGroup(tp,x)
	if Duel.Destroy(dg,REASON_EFFECT)==x and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) then 
		local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst() 
		if not tc:IsDisabled() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Destroy(tc,REASON_EFFECT) 
		end
	end
end
function c25000029.sttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsFaceup() and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and ((Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) or Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,nil)) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c25000029.stop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and ((Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) or Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,nil)) then 
	local dg=Group.CreateGroup() 
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then 
	dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	else 
	dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_PZONE,0,1,1,nil)
	end
	if Duel.Destroy(dg,REASON_EFFECT)==0 then return end 
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)	
	end
end
function c25000029.cfilter(c,tp)
	return c:IsPreviousControler(1-tp)
end
function c25000029.lmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c25000029.cfilter,1,nil,tp)
end
function c25000029.lmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c25000029.lmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--zone limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetTargetRange(0,LOCATION_EXTRA)
	e1:SetValue(c25000029.zonelimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c25000029.zonelimit(e)  
	local tp=e:GetHandlerPlayer()
	local zone=0
	local zone1=aux.SequenceToGlobal(1-tp,LOCATION_MZONE,0)
	local zone2=aux.SequenceToGlobal(1-tp,LOCATION_MZONE,1)
	local zone3=aux.SequenceToGlobal(1-tp,LOCATION_MZONE,2)
	local zone4=aux.SequenceToGlobal(1-tp,LOCATION_MZONE,3)
	local zone5=aux.SequenceToGlobal(1-tp,LOCATION_MZONE,4) 
	zone=bit.bor(zone,zone1)
	zone=bit.bor(zone,zone2)
	zone=bit.bor(zone,zone3)
	zone=bit.bor(zone,zone4)
	zone=bit.bor(zone,zone5)
	return zone
end




