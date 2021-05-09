--镜野七罪 愤怒的魔女
local m=33400708
local cm=_G["c"..m]
function cm.initial_effect(c)
 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.matfilter1,3,true)
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
 --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.descon)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
  --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,m+10000)
	e3:SetTarget(cm.destg1)
	e3:SetOperation(cm.desop1)
	c:RegisterEffect(e3)
 --
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.destg2)
	e4:SetOperation(cm.desop2)
	c:RegisterEffect(e4)
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
	e:SetLabel(val)
end

function cm.indcon(e,tp,eg,ep,ev,re,r,rp)
   return  e:GetLabel()>0
end
function cm.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ss=e:GetLabel()+e:GetHandler():GetFlagEffect(33400707)	
	c:RegisterFlagEffect(33400707,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,3))
	if ss>1 then 
	for i=2,ss do 
	 c:RegisterFlagEffect(33400707,RESET_EVENT+RESETS_STANDARD,0,0,0)
	end
	end
end
function cm.descon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsSetCard(0x3342) and  Duel.GetAttacker():GetControler()==tp 
end
function cm.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local atk=0
		local def=0
		if tc:GetCode()~=tc:GetOriginalCode() then 
		atk=tc:GetBaseAttack() 
		def=tc:GetBaseDefense() 
		end 
		if def and def>atk then atk=def end 
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
		if atk>0 then 
		Duel.Damage(1-tp,atk,REASON_EFFECT)
		end 
	end
end

function cm.descon(e,tp,eg,ep,ev,re,r,rp)  
	return   e:GetHandler():GetFlagEffect(33400707)>0
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
 local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	local atk
	local def
		if tc:GetCode()~=tc:GetOriginalCode() then 
		atk=tc:GetBaseAttack() 
		def=tc:GetBaseDefense() 
		end   
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if def and def>atk then atk=def end 
		local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_PHASE+PHASE_END,2)
			e2:SetValue(atk)
			c:RegisterEffect(e2)
		end
	end   
		
end

function cm.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	local atk=tc:GetBaseAttack() 
	local def=tc:GetBaseDefense() 
	if def>atk then atk=def end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if tc:GetCode()~=tc:GetOriginalCode() then 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,atk)
	end
end
function cm.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and  Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:GetCode()~=tc:GetOriginalCode() then
	local atk=tc:GetBaseAttack() 
	local def=tc:GetBaseDefense() 
	if def>atk then atk=def end 
	Duel.Damage(1-tp,atk,REASON_EFFECT) 
	end
end

function cm.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField()  end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	local tc=g:GetFirst()
	if tc:GetCode()~=tc:GetOriginalCode()then 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
	end
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and tc:GetCode()~=tc:GetOriginalCode() and tc:IsAbleToRemove()  and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	else
		Duel.Destroy(tc,REASON_EFFECT)
	end
end


