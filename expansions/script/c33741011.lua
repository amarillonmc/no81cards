--Echoes Kernel #Mδ - Empty City
local s,id,o=GetID()
Duel.LoadScript("c33741000.lua")
function s.initial_effect(c)
	DEchoes.AddKernelFusion(c,RACE_FAIRY)
	DEchoes.AddGrantTrigger(c,id,s.grant)
end
function s.cfilter(c)
	return DEchoes.IsEchoes(c) and c:IsType(TYPE_MONSTER)
end
function s.grant(e,tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.reccon)
	e1:SetTarget(s.rectg)
	e1:SetOperation(s.recop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local val=eg:Filter(s.cfilter,nil):GetSum(Card.GetPreviousDefenseOnField)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local val=eg:Filter(s.cfilter,nil):GetSum(Card.GetPreviousDefenseOnField)
	if val>0 then Duel.Recover(tp,val,REASON_EFFECT) end
end
