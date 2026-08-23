local m=15004492
local cm=_G["c"..m]
cm.name="星归·湮于终世"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_LIMIT_ZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	e1:SetValue(cm.zones)
	c:RegisterEffect(e1)
	if not cm.check then
		cm.check=true
		_tddGGetOriginalType=Card.GetOriginalType
		function Card.GetOriginalType(c)
			if c:IsHasEffect(15004492) then return _tddGGetOriginalType(c)+TYPE_PENDULUM end
			return _tddGGetOriginalType(c)
		end
	end
end
function cm.zones(e,tp,eg,ep,ev,re,r,rp)
	return (not (Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1))) and 0xe or 0xff
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local res=0
	if tc:IsImmuneToEffect(e) then return end
		if not tc:IsType(TYPE_PENDULUM) then
			res=1
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_ADD_TYPE)
			e3:SetValue(TYPE_PENDULUM)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3,true)
		end
		--local zone=0x1000--封 右 0x1000,封 左 0x100
		local zone=0xffff-0x1100
		if tp==1 then
			zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetValue(zone)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.AdjustAll()
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		e1:Reset()
		local x=2-tc:GetLeftScale()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LSCALE)
		e2:SetValue(x)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_UPDATE_RSCALE)
		tc:RegisterEffect(e4,true)
		Duel.AdjustAll()
		if not aux.PendulumChecklist then
			aux.PendulumChecklist=0
			local ge1=Effect.CreateEffect(c)
			ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
			ge1:SetOperation(aux.PendulumReset)
			Duel.RegisterEffect(ge1,0)
		end
		if res==1 then
			local e5=Effect.CreateEffect(c)
			e5:SetDescription(1163)
			e5:SetType(EFFECT_TYPE_FIELD)
			e5:SetCode(EFFECT_SPSUMMON_PROC_G)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e5:SetRange(LOCATION_PZONE)
			e5:SetCondition(aux.PendCondition)
			e5:SetOperation(aux.PendOperation)
			e5:SetValue(SUMMON_TYPE_PENDULUM)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e5)
		end
		--cannot disable spsummon
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
		e6:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
		e6:SetRange(LOCATION_PZONE)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		e6:SetTarget(cm.distg)
		tc:RegisterEffect(e6)
		local e7=Effect.Clone(e6)
		e7:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
		tc:RegisterEffect(e7)
		--self destroy
		local e8=Effect.CreateEffect(c)
		e8:SetCategory(CATEGORY_DESTROY+CATEGORY_TOEXTRA)
		e8:SetType(EFFECT_TYPE_IGNITION)
		e8:SetRange(LOCATION_PZONE)
		e8:SetReset(RESET_EVENT+RESETS_STANDARD)
		e8:SetTarget(cm.rptg)
		e8:SetOperation(cm.rpop)
		tc:RegisterEffect(e8)
		--
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(15004492)
		e0:SetRange(LOCATION_PZONE)
		e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e0)
end
function cm.distg(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsSetCard(0xf40) and c:IsType(TYPE_MONSTER)
end
function cm.rpfilter(c,e,tp)
	return c:IsSetCard(0x3f40) and c:IsType(TYPE_MONSTER) and (not c:IsForbidden()
		or c:IsAbleToExtra())
end
function cm.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function cm.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local g=Duel.SelectMatchingCard(tp,cm.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		local op=0
		if tc:IsAbleToExtra() then
			op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(m,1))
		end
		if op==0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SendtoExtraP(tc,nil,REASON_EFFECT)
		end
	end
end