--死域领主 契丝提亚
local s,id,o=GetID()
function s.initial_effect(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetTarget(s.actlimit)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		--adjust
		local e01=Effect.CreateEffect(c)
		e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e01:SetCode(EVENT_ADJUST)
		e01:SetRange(0xff)
		e01:SetOperation(s.adjustop)
		c:RegisterEffect(e01)
	end
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local _cRegisterEffect=Card.RegisterEffect
	function Card.RegisterEffect(rc,re,bool)
		if not re:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) then
			local con=re:GetCondition()
			if not con then con=aux.TRUE end
			re:SetCondition(s.fcon(con))
		end
		return _cRegisterEffect(rc,re,bool)
	end
	local g=Duel.GetFieldGroup(0,0x7f,0x7f)
	local xg=Duel.GetOverlayGroup(0,0x7f,0x7f)
	g:Merge(xg)
	local ini=s.initial_effect
	for tc in aux.Next(g) do
		if tc.initial_effect then
			s.initial_effect=function() end
			tc:ReplaceEffect(id,0)
			s.initial_effect=ini
			tc.initial_effect(tc)
		end
	end
	e:Reset()
end
function s.fcon(con)
	return function (e,tp,...)
		return e:GetHandler():GetFlagEffect(id)==0 and con(e,tp,...)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function s.cfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g then
		local tc=g:GetFirst()
		Duel.HintSelection(g)
		local ctype=tc:GetType()
		if ctype|TYPE_EFFECT>0 then ctype=ctype-TYPE_EFFECT end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetValue(ctype)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(s.spop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.actlimit(e,c)
	local face=c:GetColumnGroup()
	return face:IsContains(e:GetHandler())
end
function s.spfilter(c,e,tp)
	return c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.costfilter(c,tp)
	return c:IsFaceup() and not c:IsType(TYPE_EFFECT) and c:IsReleasable(REASON_EFFECT) and Duel.GetMZoneCount(tp,c,tp)>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local g2=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if g:GetCount()>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Release(g:Select(tp,1,1,nil),REASON_EFFECT)
		Duel.SpecialSummon(g2:Select(tp,1,1,nil),0,tp,tp,false,false,POS_FACEUP)
	end
end