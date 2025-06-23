--毁灭创造物β
Duel.LoadScript("c60001511.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	byd.GArtifact(c)
	--to hand
	local ce1=Effect.CreateEffect(c)
	ce1:SetCategory(CATEGORY_DAMAGE)
	ce1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	ce1:SetProperty(EFFECT_FLAG_DELAY)
	ce1:SetCode(EVENT_SPSUMMON_SUCCESS)
	--ce1:SetTarget(cm.tg)
	ce1:SetOperation(cm.op)
	c:RegisterEffect(ce1)
	local ce2=ce1:Clone()
	ce2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ce2:SetCode(EVENT_PHASE+PHASE_END)
	ce2:SetRange(LOCATION_MZONE)
	ce2:SetCountLimit(1)
	c:RegisterEffect(ce2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,800,REASON_EFFECT)
end