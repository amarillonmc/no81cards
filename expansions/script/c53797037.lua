local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.acop)
	c:RegisterEffect(e2)
end
function s.filter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsLevelAbove(1)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectTarget(tp,s.filter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local lv=Duel.AnnounceLevel(tp,math.max(1-tc:GetLevel(),-3),3)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetLabel(tc:GetCode())
	e1:SetTarget(s.tg)
	e1:SetValue(lv)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local ag=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0,1,tc)
	local g=Group.__add(tc,ag)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.tg(e,c)
	return c:IsCode(e:GetLabel())
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(Duel.GetTargetsRelateToChain(),REASON_EFFECT)
end
function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.acfilter(c,tp)
	return c:GetType()&0x20002==0x20002 and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.cfilter,nil,tp)
	if #g==0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not Duel.IsExistingMatchingCard(s.acfilter,tp,LOCATION_DECK,0,1,nil,tp) or not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.acfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		--Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+id,re,r,rp,ep,ev)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetLabel(0)
		e1:SetOperation(s.adjust)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		--[[local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SELF_DESTROY)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetLabel(0)
		e1:SetCondition(s.tgcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)]]--
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAINING)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetRange(LOCATION_SZONE)
		e2:SetLabelObject(e1)
		e2:SetOperation(s.check)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(id,3))
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetLabel(tc:GetFieldID())
		e3:SetLabelObject(tc)
		e3:SetCondition(s.trcon)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		Duel.RegisterEffect(e4,1-tp)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_ACTIVATE_COST)
		e5:SetRange(LOCATION_SZONE)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e5:SetTargetRange(1,1)
		e5:SetLabelObject(e1)
		e5:SetCost(s.costchk(e3,e4))
		tc:RegisterEffect(e5,true)
	end
end
function s.adjust(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_LEAVE_FIELD) or e:GetLabel()==1 then return end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function s.tgcon(e)
	return not Duel.CheckEvent(EVENT_LEAVE_FIELD) and e:GetLabel()==0
end
function s.check(e,tp,eg,ep,ev,re,r,rp)
	local c,rc=e:GetHandler(),re:GetHandler()
	if rc~=c or not rc:IsRelateToEffect(re) then return end
	e:GetLabelObject():SetLabel(1)
	local ev0=Duel.GetCurrentChain()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetLabelObject(e:GetLabelObject())
	e1:SetOperation(s.reset)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING then
		e:GetLabelObject():Reset()
	elseif e:GetCode()==EVENT_CHAIN_NEGATED then
		e:GetLabelObject():SetLabel(0)
	end
	re:Reset()
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Group.__band(eg,e:GetLabelObject()):GetCount()>0
end
function s.costchk(e3,e4)
	return  function(e,re,tp)
	if e:GetLabelObject():GetLabel()==1 then e:Reset() elseif not Duel.CheckEvent(EVENT_LEAVE_FIELD) then
		e:Reset()
		e3:Reset()
		e4:Reset()
		Duel.DisableActionCheck(true)
		Duel.AdjustAll()
		Duel.DisableActionCheck(false)
	end
	return re:GetDescription()~=aux.Stringid(id,3)
	end
end
function s.trcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFieldID()~=e:GetLabel() then
		e:Reset()
		return false
	end
	return tc:GetFieldID()==e:GetLabel()
end
