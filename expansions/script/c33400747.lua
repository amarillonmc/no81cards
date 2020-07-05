--D.A.L 镜野七罪
local m=33400747
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion materia
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,cm.fusfilter1,cm.fusfilter1,cm.fusfilter2,cm.fusfilter2,cm.fusfilter2)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(cm.splimit)
	c:RegisterEffect(e2)
  --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.indcon)
	e1:SetOperation(cm.indop)
	c:RegisterEffect(e1)  
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
 --indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(cm.imtg)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
  --disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_ONFIELD)
	e4:SetTarget(cm.disable)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
--disable2
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.discon)
	e5:SetOperation(cm.disop)
	c:RegisterEffect(e5)
 --atk&def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SET_ATTACK_FINAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetValue(0)
	e6:SetTarget(cm.disable)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e7)
--Equip Okatana
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetOperation(cm.Eqop1)
	c:RegisterEffect(e8)
end
function cm.fusfilter1(c)
	return c:IsSetCard(0x3342)
end
function cm.fusfilter2(c)
	return c:IsSetCard(0x341) and  c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_XYZ+TYPE_SYNCHRO)
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end

function cm.matval(c)
	if c:GetCode()~=c:GetOriginalCode() then return 1 end
	return 0
end
function cm.valcheck(e,c)
	local val=c:GetMaterial():GetSum(cm.matval)
	e:GetLabelObject():SetLabel(val)
end

function cm.indcon(e,tp,eg,ep,ev,re,r,rp)
   return  e:GetLabel()>0
end
function cm.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local s=e:GetLabel()
if s>0 then 
  --copy
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(m,0))
	e9:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_MZONE)
	e9:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e9:SetCountLimit(1)
	e9:SetOperation(cm.cpop)
	c:RegisterEffect(e9)
end
if s>1 then 
 --set
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(m,2))
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e10:SetCode(EVENT_CHAINING)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1)
	e10:SetTarget(cm.thtg)
	e10:SetOperation(cm.thop)
	c:RegisterEffect(e10)
end
if s>2 then
 --tograve
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,3))
	e11:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e11:SetCategory(CATEGORY_TOGRAVE)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_CHAINING)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(2)
	e11:SetCondition(cm.condition)
	e11:SetTarget(cm.target)
	e11:SetOperation(cm.operation)
	c:RegisterEffect(e11)
end
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
	local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,5))
	local g2=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	  local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(tc1:GetCode())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e1) 
	if (tc1:IsType(TYPE_FIELD) and tc2:IsType(TYPE_FIELD)) or (tc1:IsType(TYPE_CONTINUOUS+TYPE_SPELL) and tc2:IsType(TYPE_CONTINUOUS+TYPE_SPELL)) or (tc1:IsType(TYPE_CONTINUOUS+TYPE_TRAP) and tc2:IsType(TYPE_CONTINUOUS+TYPE_TRAP))  and Duel.SelectYesNo(tp,aux.Stringid(m,1)) or  (tc1:IsType(TYPE_MONSTER) and tc2:IsType(TYPE_MONSTER))  then 
	tc2:CopyEffect(tc1:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,1)
	end
end

function cm.thfilter(c,mc)
	return c:IsAbleToHand() and c:IsCode(mc:GetCode())
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,re:GetHandler()) end
	 Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,re:GetHandler()) then
	 local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,re:GetHandler())
	 if g:GetCount()>0 then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	 end
	end
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	return tc:GetCode()~=tc:GetOriginalCode() and tc:IsRelateToEffect(re) and (re:IsActiveType(TYPE_MONSTER)
		or (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) ))
end
function cm.tgfilter(c)
	return c:GetCode()~=c:GetOriginalCode() and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)  then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,99,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end

function cm.imtg(e,c)
	return c:GetCode()~=c:GetOriginalCode()
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function cm.disable(e,c)
	return c:GetCode()~=c:GetOriginalCode()
end
function cm.disfilter(c)
	return c:IsFaceup()  and not c:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsDisabled()
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
   local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
   local tc=re:GetHandler()
	return  loc==LOCATION_ONFIELD and tc:GetCode()~=tc:GetOriginalCode() and rp==1-tp
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
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
			 --inm
			local e6=Effect.CreateEffect(ec)
			e6:SetType(EFFECT_TYPE_QUICK_O)
			e6:SetCategory(CATEGORY_TOGRAVE)
			e6:SetRange(LOCATION_SZONE)
			e6:SetCode(EVENT_FREE_CHAIN)
			e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
			e6:SetCountLimit(1)
			e6:SetTarget(cm.atktg)
			e6:SetOperation(cm.atkop)
			token:RegisterEffect(e6,true)
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
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil) 
	local tc=tg:GetFirst()  
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,Duel.GetTurnPlayer()==tp and 2 or 1)
		tc:RegisterEffect(e1)
	if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,1,nil) 
	and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg2=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoGrave(tg2,REASON_EFFECT)
	end
end



