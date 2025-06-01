--唤祐重器 妇好鸮尊
local s,id,o=GetID()
Duel.LoadScript("c33201370.lua")
function s.initial_effect(c)
	VHisc_HYZQ.rlef(c,id,nil)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.VHisc_HYZQ=true
s.VHisc_CNTreasure=true

function s.rfilter(c)
	return c:IsReleasable()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(VHisc_HYZQ.rlft,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(s.rfilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,2,tp,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(VHisc_HYZQ.rlft,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(s.rfilter,tp,0,LOCATION_MZONE,1,e:GetHandler())) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,VHisc_HYZQ.rlft,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,s.rfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SendtoGrave(g1,REASON_RELEASE)
	Duel.Release(g2,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(800)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end

--Release effect
function s.filter(c)
	return c.VHisc_HYZQ and c:IsType(TYPE_SPELL) and not c:IsCode(id)
end
function s.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil) end
end
function s.rlop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local c=e:GetHandler()
		local code=tc:GetCode()
		local cs=_G["c"..code]
		if Duel.SSet(tp,tc,tp,true) then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			tc:RegisterEffect(e1)
		end
		--copy effect
		if tc:IsType(TYPE_QUICKPLAY) then return end
		local e2=Effect.CreateEffect(c)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e2:SetValue(TYPE_QUICKPLAY)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
		local eff=tc:GetActivateEffect()
		local eff2=eff:Clone()
		eff:SetDescription(aux.Stringid(id,0))
		eff2:SetProperty(eff2:GetProperty(),EFFECT_FLAG2_COF)
		eff2:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
		eff2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(eff2)
	end
end
