--七罪-赝造魔女 千变万化镜
local m=33400756
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --copy effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.cptg)
	e1:SetOperation(cm.cpop)
	c:RegisterEffect(e1)
--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.mattg)
	e2:SetOperation(cm.matop)
	c:RegisterEffect(e2)
end
function cm.ckfilter1(c)
	return c:GetCode()~=c:GetOriginalCode()
end
function cm.ckfilter2(c)
	return c:IsCode(33400751)
end
function cm.cpfilter(c)
	return (c:IsSetCard(0x341,0x340) or (Duel.IsExistingMatchingCard(cm.ckfilter1,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(cm.ckfilter2,tp,LOCATION_ONFIELD,0,1,nil))) and c:IsType(TYPE_SPELL+TYPE_TRAP)  and c:CheckActivateEffect(false,true,false)~=nil
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(cm.cpfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.cpfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

function cm.mvfilter(c)
	return c:IsSetCard(0x341,0x340) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden()
end
function cm.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.mvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.mvfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	Duel.SelectTarget(tp,cm.mvfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
 if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	   if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		if not tc:IsCode(33400751) then 
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCondition(cm.descon)
			e1:SetOperation(cm.desop)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			e1:SetCountLimit(1)
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetLabelObject(tc)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(m)~=0
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end









