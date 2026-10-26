--疯狂犯罪者·干扰
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetValue(id)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.condition)
	e2:SetCost(s.cost)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.rttg)
	e3:SetOperation(s.rtop)
	c:RegisterEffect(e3)
end
function s.ctfiler(c,e,tp,res)
	local b1=c:IsLocation(LOCATION_MZONE) and ((res and res:GetOwner()==e:GetHandler() and res:GetValue()==id) or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	local b2=c:IsLocation(LOCATION_SZONE) and not c:IsLocation(LOCATION_FZONE) 
		and (Duel.GetLocationCount(tp,LOCATION_SZONE-LOCATION_FZONE)>1 and e:GetHandler():IsLocation(LOCATION_SZONE)
		or Duel.GetLocationCount(tp,LOCATION_SZONE-LOCATION_FZONE)>0)
	local b3=c:IsLocation(LOCATION_FZONE)
	return c:IsAbleToChangeControler() and (b1 or b2)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetHandler():IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN,tp)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ctfiler,tp,0,LOCATION_ONFIELD,1,nil,e,tp,res) end
	local g=Duel.GetMatchingGroup(s.ctfiler,tp,0,LOCATION_ONFIELD,nil,e,tp,res)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=Duel.SelectMatchingCard(tp,s.ctfiler,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		if tc:IsLocation(LOCATION_MZONE) then
			Duel.GetControl(tc,tp)
		elseif tc:IsLocation(LOCATION_FZONE) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			local pos=tc:GetPosition()
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,pos,true)
		else
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				local pos=tc:GetPosition()
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,pos,true)
			else
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		end
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(id+o,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(s.descon)
		e1:SetOperation(s.desop)
		Duel.RegisterEffect(e1,tp)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id+o)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function s.cfilter(c,e,tp)
	return c:IsSetCard(0x6A73) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function s.condition(e)
	return e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if Duel.Remove(tc,0,REASON_COST+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsReason(REASON_TEMPORARY) and e:GetLabelObject():IsLocation(LOCATION_REMOVED)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function s.rtfilter(c,tp)
	if not c:IsLocation(LOCATION_REMOVED) then return false end
	if not (c:IsReason(REASON_TEMPORARY) and c:IsPreviousLocation(LOCATION_MZONE)) then return false end
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function s.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rtfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,tp) end	
end
function s.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local sg=Duel.SelectMatchingCard(tp,s.rtfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,tp)
	if #sg>0 then
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		tc:RegisterFlagEffect(id+o,RESET_EVENT+RESETS_WITHOUT_TEMP_REMOVE-RESET_TOFIELD,0,1,c:GetFieldID())
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_SET_CONTROL)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e3:SetLabel(c:GetFieldID())
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(function(se,sc) return sc:GetFlagEffect(id+o)>0 and se:GetLabel()==sc:GetFlagEffectLabel(id+o) end)
		e3:SetValue(tp)
		Duel.RegisterEffect(e3,tp)
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
	end
end