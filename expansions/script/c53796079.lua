local m=53796079
local cm=_G["c"..m]
cm.name="噩梦编撰人 HZN"
function cm.initial_effect(c)
	cm.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(cm.regcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.lvcon)
	e2:SetTarget(cm.lvtg)
	e2:SetOperation(cm.lvop)
	c:RegisterEffect(e2)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.lvfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.lvfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(cm.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local lv=g:GetFirst():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	e:SetLabel(Duel.AnnounceLevel(tp,1,11,lv))
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(0x20002)
		c:RegisterEffect(e1)
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_LEVEL)
			e2:SetValue(e:GetLabel())
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end
function cm.AddSynchroProcedure(c,f1,f2,minc,maxc)
	if maxc==nil then maxc=99 end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA+LOCATION_SZONE)
	e1:SetCondition(cm.SynCondition(f1,f2,minc,maxc))
	e1:SetTarget(cm.SynTarget(f1,f2,minc,maxc))
	e1:SetOperation(aux.SynOperation(f1,f2,minc,maxc))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end
function cm.SynCondition(f1,f2,minc,maxc)
	return  function(e,c,smat,mg,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
				e1:SetTargetRange(0,LOCATION_MZONE)
				e1:SetRange(LOCATION_SZONE)
				c:RegisterEffect(e1)
				local check=false
				if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
					if Duel.CheckTunerMaterial(c,smat,f1,f2,minc,maxc,mg) then check=true end
					e1:Reset()
					return check
				end
				if Duel.CheckSynchroMaterial(c,f1,f2,minc,maxc,smat,mg) then check=true end
				e1:Reset()
				return check
			end
end
function cm.SynTarget(f1,f2,minc,maxc)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local g=nil
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
				e1:SetTargetRange(0,LOCATION_MZONE)
				e1:SetRange(LOCATION_SZONE)
				c:RegisterEffect(e1)
				if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
					g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,f1,f2,minc,maxc,mg)
				else
					g=Duel.SelectSynchroMaterial(c:GetControler(),c,f1,f2,minc,maxc,smat,mg)
				end
				e1:Reset()
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
