--寂海的祝巫 露米娅
local s,id,o=GetID()
Duel.LoadScript("c33201150.lua")
function s.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetLabelObject(e1)
	e2:SetLabel(id)
	e2:SetCondition(Mermaid_VHisc.effcon)
	e2:SetOperation(Mermaid_VHisc.effop)
	c:RegisterEffect(e2)
end
s.VHisc_Mermaid=true

--e1
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and s.smfilter(chkc,e,tp) end
	if chk==0 then return Mermaid_VHisc.fgck(e:GetHandler(),id) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Mermaid_VHisc.flagc(e:GetHandler(),id)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsRelateToEffect(e) then 
		Mermaid_VHisc.sp(e:GetHandler(),tp)
	end
	--atk up
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(function(e,ac) return ac.VHisc_Mermaid end)
		e1:SetValue(800)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
end

