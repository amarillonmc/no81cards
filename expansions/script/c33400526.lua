--D.A.L 四糸乃·冰铠形态
local m=33400526
local cm=_G["c"..m]
function cm.initial_effect(c)
 --fusion materia
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,cm.fusfilter3,cm.fusfilter4,cm.fusfilter5,cm.fusfilter6,cm.fusfilter7)
	 --pendulum summon
	aux.EnablePendulumAttribute(c,false)   
	 --spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(1)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
 --immune effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(cm.etarget)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
--avoid damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetCondition(cm.ndcon)
	e3:SetValue(0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e4)
  --counter
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(cm.condition)
	e5:SetOperation(cm.counter)
	c:RegisterEffect(e5)  
--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetCondition(cm.imcon)
	e6:SetValue(cm.efilter1)
	c:RegisterEffect(e6)
--extra attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_EXTRA_ATTACK)
	e7:SetCondition(cm.imcon)
	e7:SetValue(1)
	c:RegisterEffect(e7)
--pierce
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_PIERCE)
	e8:SetCondition(cm.imcon)
	c:RegisterEffect(e8)
--avoid damage
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CHANGE_DAMAGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetTargetRange(1,0)
	e9:SetCondition(cm.ndcon)
	e9:SetValue(0)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e10)
 --atk/def
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_UPDATE_ATTACK)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(cm.adval)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e12)
--attack up
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(m,3))
	e13:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e13:SetCode(EVENT_ATTACK_ANNOUNCE)
	e13:SetCondition(cm.attcon)
	e13:SetTarget(cm.thtg)
	e13:SetOperation(cm.thop)
	c:RegisterEffect(e13)
  --pendulum
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,2))
	e11:SetCategory(CATEGORY_DESTROY)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_LEAVE_FIELD)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCondition(cm.pencon)
	e11:SetTarget(cm.pentg)
	e11:SetOperation(cm.penop)
	c:RegisterEffect(e11)
end
function cm.fusfilter3(c)
	return c:IsSetCard(0x341) and  c:IsType(TYPE_RITUAL)
end
function cm.fusfilter4(c)
	return c:IsSetCard(0x341) and  c:IsType(TYPE_FUSION)
end
function cm.fusfilter5(c)
	return c:IsSetCard(0x341) and  c:IsType(TYPE_SYNCHRO)
end
function cm.fusfilter6(c)
	return c:IsSetCard(0x341) and  c:IsType(TYPE_XYZ)
end
function cm.fusfilter7(c)
	return c:IsSetCard(0x341) and  c:IsType(TYPE_LINK)
end

function cm.fusfilter8(c)
	return c:IsCode(33400502) and c:IsFaceup()
end
function cm.splimit(e,se,sp,st)
	local c=e:GetHandler()
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and Duel.IsExistingMatchingCard(cm.fusfilter8,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end

function cm.spfilter1(c)
	return c:IsSetCard(0x341) and c:IsType(TYPE_FUSION)  and c:IsAbleToExtraAsCost() 
end
function cm.spfilter2(c)
	return c:IsSetCard(0x341) and c:IsType(TYPE_SYNCHRO)and c:IsAbleToExtraAsCost() 
end
function cm.spfilter3(c)
	return c:IsSetCard(0x341) and c:IsType(TYPE_XYZ)  and c:IsAbleToExtraAsCost() 
end
function cm.spfilter4(c)
	return c:IsSetCard(0x341) and c:IsType(TYPE_LINK)  and c:IsAbleToExtraAsCost() 
end
function cm.spfilter5(c)
	return c:IsSetCard(0x341) and  c:IsType(TYPE_RITUAL)  and c:IsAbleToDeckAsCost() 
end
function cm.spcostfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x341)
		and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function cm.tdfilter1(c)
	return c:IsSetCard(0x3344)   and c:IsAbleToDeckAsCost() 
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(cm.tdfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
   return  (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 or Duel.IsExistingMatchingCard(cm.spcostfilter,tp,LOCATION_MZONE,0,1,nil,c))  
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.spfilter3,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.spfilter4,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.spfilter5,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil)
		and g1:GetClassCount(Card.GetCode)>=5
		and Duel.IsExistingMatchingCard(cm.fusfilter8,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function cm.check(g)
	return g:IsExists(cm.spfilter1,1,nil) 
	and g:IsExists(cm.spfilter2,1,nil) 
	and g:IsExists(cm.spfilter3,1,nil) 
	and g:IsExists(cm.spfilter4,1,nil) 
	and g:IsExists(cm.spfilter5,1,nil)
	and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function cm.check2(g)
	return g:GetClassCount(Card.GetCode)>=5
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
  local g1=Duel.GetMatchingGroup(cm.tdfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
   local g2=Duel.GetMatchingGroup(cm.spcostfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if g1:GetClassCount(Card.GetCode)<5 or g2:GetCount()<5 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g3=g2:SelectSubGroup(tp,cm.check,false,5,5)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g4=g1:SelectSubGroup(tp,cm.check2,false,5,5)
	g3:Merge(g4)
	Duel.SendtoDeck(g3,nil,2,REASON_EFFECT)
	c:SetMaterial(nil)  
end

function cm.etarget(e,c)
	return c:GetCounter(0x1015)~=0
end
function cm.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function cm.ndcon(e)
	return Duel.IsExistingMatchingCard(nil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp   and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x1015,1)
end
function cm.counter(e,tp,eg,ep,ev,re,r,rp)
	 local ct=Duel.GetMatchingGroupCount(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,0x1015,1)
	if ct==0 then return end
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,0x1015,1)
	if g:GetCount()==0 then return end  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		tc:AddCounter(0x1015,1)
end

function cm.imcon(e)
	return Duel.IsExistingMatchingCard(nil,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function cm.efilter1(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

function cm.adval(e,c)
	return Duel.GetCounter(e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,0x1015)*400
end

function cm.attcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end
function cm.tfilter3(c)
	return c:GetCounter(0x1015)~=0 or c:IsFacedown()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return Duel.IsExistingMatchingCard(cm.tfilter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,tp,LOCATION_ONFIELD)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,cm.tfilter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,30,nil)
	if g1:GetCount()>0 then
		local ss=Duel.SendtoHand(g1,nil,REASON_EFFECT)
		   local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(ss*1000)
			c:RegisterEffect(e2)
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		local gc=g:GetFirst()
		while gc do
			gc:AddCounter(0x1015,1)
			gc=g:GetNext()
		end 
	end
end


function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
