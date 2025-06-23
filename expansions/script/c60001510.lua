--毁灭创造物γ
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
	ce1:SetTarget(cm.tg)
	ce1:SetOperation(cm.op)
	c:RegisterEffect(ce1)
	local ce2=ce1:Clone()
	ce2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ce2:SetCode(EVENT_PHASE+PHASE_END)
	ce2:SetRange(LOCATION_MZONE)
	ce2:SetCountLimit(1)
	c:RegisterEffect(ce2)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end