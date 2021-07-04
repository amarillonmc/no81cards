--D.A.L 四糸乃·四糸奈
local m=33400524
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
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
 --immune effect
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetRange(LOCATION_PZONE)
	e8:SetTargetRange(LOCATION_ONFIELD,0)
	e8:SetTarget(cm.etarget)
	e8:SetValue(cm.efilter)
	c:RegisterEffect(e8)
--indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e9:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e9:SetRange(LOCATION_PZONE)
	e9:SetTargetRange(LOCATION_ONFIELD,0)
	e9:SetValue(cm.indct)
	c:RegisterEffect(e9)
  --counter
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e10:SetCode(EVENT_CHAINING)
	e10:SetProperty(EFFECT_FLAG_DELAY)
	e10:SetRange(LOCATION_PZONE)
	e10:SetCondition(cm.condition)
	e10:SetOperation(cm.counter)
	c:RegisterEffect(e10)  
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.indtg)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)   
 --Disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_ONFIELD)
	e3:SetTarget(cm.attg)
	c:RegisterEffect(e3)
--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_ONFIELD)
	e4:SetTarget(cm.attg)
	e4:SetValue(0)
	c:RegisterEffect(e4)
--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SET_DEFENSE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_ONFIELD)
	e5:SetTarget(cm.attg)
	e5:SetValue(0)
	c:RegisterEffect(e5)
--material
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,3))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetCountLimit(2,m)
	e7:SetOperation(cm.maop)
	c:RegisterEffect(e7) 
 --Equip Okatana
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetOperation(cm.Eqop1)
	c:RegisterEffect(e6)
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

function cm.etarget(e,c)
	return c:GetCounter(0x1015)~=0
end
function cm.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function cm.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
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

function cm.indtg(e,c)
	return c:GetCounter(0x1015)~=0 
end

function cm.attg(e,c)
	return c:GetCounter(0x1015)~=0 
end
   
function cm.maop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil) then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToHand() and Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5))==0 then
			 if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then 
			 Duel.ConfirmCards(1-tp,tc) 
			 local tg1=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,0x1015,4)
			 local tc1=tg1:GetFirst()
			 tc1:AddCounter(0x1015,4)
			 end
		else
			if  Duel.Destroy(tc,REASON_EFFECT)~=0 then
			 local tg1=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,0x1015,4)
			 local tc1=tg1:GetFirst()
			 tc1:AddCounter(0x1015,4)
			end   
		end
	end
end

function cm.Eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		cm.TojiEquip(c,e,tp,eg,ep,ev,re,r,rp)
	end
end
function cm.TojiEquip(ec,e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,m+1)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	token:CancelToGrave()
	local e1_1=Effect.CreateEffect(token)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CHANGE_TYPE)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
	e1_1:SetReset(RESET_EVENT+0x1fc0000)
	token:RegisterEffect(e1_1,true)
	local e1_2=Effect.CreateEffect(token)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetCode(EFFECT_EQUIP_LIMIT)
	e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_2:SetValue(1)
	token:RegisterEffect(e1_2,true)
	token:CancelToGrave()   
	if Duel.Equip(tp,token,ec,false) then 
			--immune
			local e4=Effect.CreateEffect(ec)
			e4:SetType(EFFECT_TYPE_EQUIP)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(cm.efilter1)
			token:RegisterEffect(e4)
			--indes
			local e5=Effect.CreateEffect(ec)
			e5:SetType(EFFECT_TYPE_EQUIP)
			e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e5:SetValue(cm.valcon)
			e5:SetCountLimit(1)
			token:RegisterEffect(e5)   
			--set p
			local e2=Effect.CreateEffect(ec)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
			e2:SetCategory(CATEGORY_COUNTER)
			e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
			e2:SetCode(EVENT_DESTROYED)
			e2:SetRange(LOCATION_SZONE)
			e2:SetCountLimit(2)
			e2:SetTarget(cm.cttg)
			e2:SetOperation(cm.ctop)
			token:RegisterEffect(e2)
	return true
	else Duel.SendtoGrave(token,REASON_RULE) return false
	end
end
function cm.efilter1(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.valcon(e,re,r,rp)
	return r==REASON_BATTLE
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x1015,1) end
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local gc=g:GetFirst()
	while gc do
		gc:AddCounter(0x1015,1)
		gc=g:GetNext()
	end 
end

function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end