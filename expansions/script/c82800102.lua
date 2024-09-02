--永远亭 月之公主蓬莱山辉夜
local s,id,o=GetID()
s.karuya_name_list=true 
function s.race(c)
	--add race
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetValue(RACE_SPELLCASTER)
	c:RegisterEffect(e0)
end
function s.initial_effect(c)
	--c:SetSPSummonOnce(id)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,s.xyzcheck,2,2)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1153)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsXyzLevel(xyzc,7)
end
function s.xyzcheck(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x861)
end
function s.setfilter(c,tp)
	return c:IsFaceupEx() and c:IsType(TYPE_SPELL) and c:IsSSetable(true) and c:IsSetCard(0x861,0x863)
		and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and s.setfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SSet(tp,tc)~=0 then
		if tc:IsType(TYPE_QUICKPLAY) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		else
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_QUICK_O)
			e2:SetCode(EVENT_FREE_CHAIN)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetRange(LOCATION_SZONE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
			e2:SetTarget(s.destg)
			e2:SetOperation(s.desop)
			tc:RegisterEffect(e2)
		end
	end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local te,eg,ep,ev,re,r,rp=c:CheckActivateEffect(true,true,true)
	local cost=nil
	if te and te:GetCost() then cost=te:GetCost() end
	local condition=nil
	if te and te:GetCondition() then condition=te:GetCondition() end
	local tg=nil
	if te and te:GetTarget() then tg=te:GetTarget() end
	local res=c:CheckActivateEffect(true,true,false)~=nil 
		and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0)) and te:CheckCountLimit(tp)==true
		and (not condition or condition(e,tp,eg,ep,ev,re,r,rp)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0))
	if chk==0 then return c:GetFlagEffect(id)==0 and res end
	Duel.ChangePosition(c,POS_FACEUP)
	if cost then cost(e,tp,eg,ep,ev,re,r,rp,1) end
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	te:SetLabelObject(c)
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
	if not c:IsType(TYPE_CONTINUOUS+TYPE_FIELD) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tg=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=tg:GetFirst()
	if tc then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,tg)
	end
end