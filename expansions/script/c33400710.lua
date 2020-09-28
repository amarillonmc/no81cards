--镜野七罪 隐形的魔女
local m=33400710
local cm=_G["c"..m]
function cm.initial_effect(c)
 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3342),2,true)
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
		--can not be effect target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(cm.indcon2)
	e4:SetTarget(cm.etlimit)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
   --Avoid battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(cm.indcon2)
	e2:SetTarget(cm.etlimit)
	e2:SetValue(1)
	c:RegisterEffect(e2)
 --direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetCondition(cm.ckcon)
	c:RegisterEffect(e3)
   --cannot be target
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,0))
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e8:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(cm.ckcon)
	e8:SetValue(aux.imval1)
	e8:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e9:SetValue(1)
	e9:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e9)
   --special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,m)
	e5:SetCondition(cm.setcon)
	e5:SetTarget(cm.settg)
	e5:SetOperation(cm.setop)
	c:RegisterEffect(e5)
--
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetTarget(cm.rectg)
	e7:SetOperation(cm.recop)
	c:RegisterEffect(e7)
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
   c:RegisterFlagEffect(33400707,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,4))
end

function cm.indcon2(e,tp,eg,ep,ev,re,r,rp)  
	return   e:GetHandler():GetFlagEffect(33400707)>0
end
function cm.etlimit(e,c)
	return  c:IsFaceup() and c:IsSetCard(0x3342)
end

function cm.ckfilter(c)
	return c:IsFaceup() and c:GetCode()~=c:GetOriginalCode()
end
function cm.ckcon(e)
	return Duel.IsExistingMatchingCard(cm.ckfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end

function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return  chkc:IsOnField() and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	 local ss=0
		if tc:GetCode()~=tc:GetOriginalCode()then ss=tc:GetBaseAttack() end  
		if  Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and ss>0 then 
		  Duel.Damage(1-tp,ss,REASON_EFFECT)
		end
	end
end

function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return  ep~=tp
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	 Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
   if not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil) then return end 
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SSet(tp,tc)
end

function cm.rcfilter(c)
	return c:IsFaceup() 
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.rcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.rcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.rcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup()  then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(m)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1) 
		  --cannot target
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(m,3))
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e4:SetValue(aux.tgoval)
		tc:RegisterEffect(e4)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e5:SetValue(1)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e5)
		local e2=e5:Clone()
		e2:SetDescription(aux.Stringid(m,2))
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		tc:RegisterEffect(e2)
	end
end




