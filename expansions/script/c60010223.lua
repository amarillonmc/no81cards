--神宝·蓬莱的玉枝-梦色之乡-
local cm,m,o=GetID()
function cm.initial_effect(c)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e3)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.immtg)
	e1:SetOperation(cm.immop)
	c:RegisterEffect(e1)
end
function cm.immtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
end
function cm.immop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.etarget)
	e1:SetValue(cm.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterEffect(e1,tp)
end
function cm.etarget(e,c)
	return ((c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEDOWN)) or (not c:IsLocation(LOCATION_MZONE) and not c:IsType(TYPE_EFFECT))) and c:IsType(TYPE_MONSTER) 
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end