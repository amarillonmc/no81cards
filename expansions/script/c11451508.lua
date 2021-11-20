--悠久之忆：归尘
local m=11451508
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--release
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
	--addition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetCondition(cm.chcon)
	e4:SetOperation(cm.chop)
	c:RegisterEffect(e4)
end
function cm.setfilter(c)
	return c:GetType()&0x100004==0x100004 and c:IsSSetable()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsHasCategory(CATEGORY_SEARCH) or re:IsHasCategory(CATEGORY_TOHAND) or re:IsHasCategory(CATEGORY_DRAW)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or e:IsHasType(EFFECT_TYPE_QUICK_O)) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabelObject(e)
	e1:SetCondition(cm.rscon)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	re:SetOperation(cm.activate)
	re:SetCategory(CATEGORY_LEAVE_GRAVE)
	re:SetLabel(0)
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) and re:GetHandler():IsSetCard(0x97d) and re:GetHandler():GetType()&0x100004==0x100004 and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetLabel()&0x8~=0 then return end
	local op=re:GetOperation()
	local repop=function(e,tp,eg,ep,ev,re,r,rp)
		op(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			local sg=g:RandomSelect(1-tp,1)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		end
	end
	re:SetOperation(repop)
	if not re:IsHasCategory(CATEGORY_HANDES) then re:SetCategory(re:GetCategory()+CATEGORY_HANDES) end
	re:SetLabel(re:GetLabel()|0x8)
end