--DEchoes #A5 - Fellowship
local s,id,o=GetID()
Duel.LoadScript("c33741000.lua")
function s.initial_effect(c)
	DEchoes.AddTechCounterPermit(c)
	DEchoes.AddHandKernelProc(c,id,1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(s.ctcon)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_BATTLE) and c:GetReasonCard()
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetHandler():GetReasonCard()
	if chk==0 then return rc and rc:IsControler(1-tp) and rc:IsAbleToChangeControler() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,rc,1,0,0)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	if rc and rc:IsRelateToBattle() and Duel.GetControl(rc,tp,PHASE_END,1)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_CONTROL)
		e1:SetValue(tp)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		rc:RegisterEffect(e1)
	end
end
