--科隆尊
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	aux.AddCodeList(c,5012604)
	c:EnableReviveLimit()
	--material
	aux.AddFusionProcMix(c,false,true,s.matfilter,s.filter,aux.FilterBoolFunction(Card.IsFusionType,TYPE_MONSTER),nil)
	s.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_MZONE,0,aux.tdcfop(c))
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	--e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCost(s.rmcost)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+0x0200)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	return c:IsPreviousLocation(LOCATION_MZONE)
	end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():CheckUniqueOnField(tp)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	if not c:CheckUniqueOnField(tp) then return end
	if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c):GetFirst()
	if not tc then return end
	if tc:IsFacedown() then return end
	if not c:CheckUniqueOnField(tp) then return end
	if Duel.Equip(tp,c,tc,true,true) then
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
			e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabelObject(tc)
		e1:SetValue(s.eqlimit)
			c:RegisterEffect(e1,true)
	--effect indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3,true)
	end
	Duel.EquipComplete()
end
function s.sqlimit(e,c)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
	--return c==e:GetLabelObject()
end
function s.matfilter(c)
	return c.MoJin==true and c:IsLevel(10)
end
function s.filter(c)
	return c.MoJin==true 
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.Destroy(tc,REASON_EFFECT)==0 then
		Duel.BreakEffect()
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		if Duel.Destroy(sg,REASON_EFFECT)~=0 then
			local og=Duel.GetOperatedGroup()
			local rg=og:Filter(Card.IsAbleToRemove,nil)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() end
	Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsFaceup() then return end
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(id,2))
	if Duel.GetFlagEffect(tp,id)==0 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetLabel(fid)
		e2:SetLabelObject(c)
		e2:SetCondition(s.indcon)
		e2:SetTarget(s.indtg)
		e2:SetValue(s.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.indcon(e)
	local c=e:GetLabelObject()
	return c:GetFlagEffectLabel(id)==e:GetLabel()
end
function s.indtg(e,c)
	return c:IsFacedown() and c:GetFlagEffectLabel(id)==e:GetLabel()
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.AddContactFusionProcedure(c,filter,self_location,opponent_location,mat_operation,...)
	self_location=self_location or 0
	opponent_location=opponent_location or 0
	local operation_params={...}
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.ContactFusionCondition(filter,self_location,opponent_location))
	e2:SetOperation(s.ContactFusionOperation(filter,self_location,opponent_location,mat_operation,operation_params))
	c:RegisterEffect(e2)
	return e2
end
function s.ContactFusionMaterialFilter(c,fc,filter)
	return c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL) and c:IsFusionType(TYPE_MONSTER)
		and (not filter or filter(c,fc)) and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function s.ContactFusionCondition(filter,self_location,opponent_location)
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(s.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				return c:CheckFusionMaterial(mg,nil,tp|0x200)
			end
end
function s.ContactFusionOperation(filter,self_location,opponent_location,mat_operation,operation_params)
	return	function(e,tp,eg,ep,ev,re,r,rp,c)
				local mg=Duel.GetMatchingGroup(s.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp|0x200)
				c:SetMaterial(g)
				mat_operation(g,table.unpack(operation_params))
			end
end