--渊洋海兽 锤头鲨
local m = 11636040
local cm = _G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	--to hand or summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--synchro material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTarget(cm.reptg)
	c:RegisterEffect(e3)
	--debuff
	if not cm.globalcheck then
		cm.globalcheck=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CUSTOM+m)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(cm.decon)
	e4:SetOperation(cm.deop)
	c:RegisterEffect(e4)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.tgcon)
	e5:SetOperation(cm.tgop)
	c:RegisterEffect(e5)
end

function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(rp,m)~=0 then
		local n=Duel.GetFlagEffectLabel(rp,m)+1
		Duel.SetFlagEffectLabel(rp,m,n)
		if n%5==0 then
			Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,0,rp,0,0)
		end
	else
		Duel.RegisterFlagEffect(rp,m,RESET_PHASE+PHASE_END,0,1,1)
	end
end
--
function cm.filter(c,e,tp)
	return c:IsSetCard(0x9223) and not c:IsCode(m) and c:IsType(TYPE_MONSTER) and c:IsAbleToExtra()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and ft>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,1-tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,1-tp,REASON_EFFECT)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
--
function cm.repfilter(c)
	return  c:GetLeaveFieldDest()==0 and bit.band(c:GetReason(),REASON_MATERIAL+REASON_SYNCHRO)==REASON_MATERIAL+REASON_SYNCHRO  and  c:GetReasonCard():IsSetCard(0x223)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return cm.repfilter(c)
	end
	if cm.repfilter(c) then
		Duel.SendtoExtraP(c,1-c:GetControler(),REASON_EFFECT+REASON_REDIRECT)
		return true
	end
	return false
end
--
function cm.decon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOwner()~=tp and rp==tp
end

function cm.oprep(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT) then
			Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+11636070,e,0,0,0,0)
		end
	end
end

function cm.deop(e,tp,eg,ep,ev,re,r,rp)
	cm.oprep(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,11636065) then
		cm.oprep(e,tp,eg,ep,ev,re,r,rp)
	end
end
--
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetOwner()
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp and p~=e:GetHandler():GetControler()
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end