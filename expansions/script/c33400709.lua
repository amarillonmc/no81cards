--镜野七罪 诱惑的魔女
local m=33400709
local cm=_G["c"..m]
function cm.initial_effect(c)
 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.matfilter1,2,true)
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
  --
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.rpcon)
	e2:SetCost(cm.spcost1)
	e2:SetTarget(cm.reptg)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.countcon1)
	e3:SetTarget(cm.counttg)
	e3:SetOperation(cm.countop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetCondition(cm.countcon2)
	c:RegisterEffect(e4)
--recover
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,m+10000)
	e5:SetTarget(cm.rectg)
	e5:SetOperation(cm.recop)
	c:RegisterEffect(e5)
end
function cm.matfilter1(c)
	return  c:IsSetCard(0x3342) or c:GetCode()~=c:GetOriginalCode()
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
	local ss=e:GetLabel()+e:GetHandler():GetFlagEffect(33400707)	
	c:RegisterFlagEffect(33400707,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,4))
	if ss>1 then 
	for i=2,ss do 
	 c:RegisterFlagEffect(33400707,RESET_EVENT+RESETS_STANDARD,0,0,0)
	end
	end
end

function cm.cfilter1(c)
	return c:IsSetCard(0x3342) and c:IsAbleToGraveAsCost() 
end
function cm.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetCode())
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.rpcon(e,tp,eg,ep,ev,re,r,rp)  
	return   e:GetHandler():GetFlagEffect(33400707)>0
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x341,0x340) 
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local cd=e:GetLabel()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	 local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(cd)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1) 
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(cm.efilter)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+Duel.GetCurrentPhase())
		e4:SetOwnerPlayer(tp)
		tc:RegisterEffect(e4)   
	end
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

function cm.countcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function cm.countcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function cm.thfilter(c,tp)
	return c:IsSetCard(0x340,0x341) and c:IsType(TYPE_FIELD+TYPE_CONTINUOUS)
		and  c:GetActivateEffect():IsActivatable(tp)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x3342)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.counttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) or (Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) end
	if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	  local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,LOCATION_DECK+LOCATION_GRAVE)
	end
end
function cm.countop(e,tp,eg,ep,ev,re,r,rp)
 local s1=0
 local s2=0
if  Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
then s1=1 
end
if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
then s2=1
end
if s1==0 and s2==0 then return end
  if s1==1 and (s2==0 or Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))==0) then
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b2=tc:GetActivateEffect():IsActivatable(tp)
		if b2 then   
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
  else
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc2=g2:GetFirst()
	 Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
  end
   
end

function cm.rcfilter(c)
	return c:IsFaceup() 
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.rcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.rcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.rcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local atk=tc:GetBaseAttack() 
	local def=tc:GetBaseDefense() 
	if def>atk then atk=def end 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetBaseAttack() 
	local def=tc:GetBaseDefense() 
	if def>atk then atk=def end 
	if tc:IsRelateToEffect(e) and tc:IsFaceup()  then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(m)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1) 
		if atk>0 then
		Duel.Recover(tp,atk,REASON_EFFECT)
		end
	end
end