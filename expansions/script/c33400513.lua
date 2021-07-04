--四糸乃 冰雪佳人
local m=33400513
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,cm.sfilter,cm.sfilter,1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)  
--destroy replace
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_DESTROY_REPLACE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetTarget(cm.reptg)
	e0:SetValue(cm.repval)
	e0:SetOperation(cm.repop)
	c:RegisterEffect(e0)
	 --counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
	 --negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,m)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.cost2)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCost(cm.cost)
	e6:SetCondition(cm.pencon)
	e6:SetTarget(cm.pentg)
	e6:SetOperation(cm.penop)
	c:RegisterEffect(e6)
end
function cm.sfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) or c:IsSetCard(0x341)
end

function cm.filter1(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) 
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)) and not c:IsReason(REASON_REPLACE) and c:IsAttribute(ATTRIBUTE_WATER) or c:IsSetCard(0x341)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.filter1,1,c,tp)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.repval(e,c)
	return cm.filter1(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE) 
end

function cm.ckfilter(c)
	return c:IsSetCard(0x3344) and c:IsFaceup()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) or Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	if not Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil)then Duel.PayLPCost(tp,1000)
	end
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
  local d=Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1015)
  Duel.Recover(tp,d*400,REASON_EFFECT)
end

function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1015,3,REASON_COST) and Duel.CheckLPCost(tp,1000) or Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	if not Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil)then Duel.PayLPCost(tp,1000)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,1,0x1015,3,REASON_COST)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.IsExistingMatchingCard(cm.ckfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	  local tg=Duel.SelectMatchingCard(tp,cm.ckfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	   Duel.Destroy(tg,REASON_EFFECT)
	end 
end
function cm.ckfilter1(c)
	return c:GetCounter(0x1015)~=0 
end


function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup() 
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) or (Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x1015,1))end
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) and not (Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x1015,1)) then return end
	local c=e:GetHandler()
	local b1=0
	local b2=0
	local op
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then b1=1 end
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x1015,1) then b2=1 end 
	if b1==1 and b2==1 then  
			op=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))				 
	elseif b1==1 then
		op=0	 
	else
		op=1	  
	end
	if c:IsRelateToEffect(e) and op==0 then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
	if op==1 then 
	 local g1=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,0x1015,1)
	   for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		tc:AddCounter(0x1015,1)
	   end  
	end
end

