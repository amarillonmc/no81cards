local m=15005451
local cm=_G["c"..m]
cm.name="织炎封缄"
function cm.initial_effect(c)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.cecondition)
	e1:SetTarget(cm.cetarget)
	e1:SetOperation(cm.ceoperation)
	c:RegisterEffect(e1)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
	local sg=Duel.SelectMatchingCard(1-tp,cm.desfilter,1-tp,LOCATION_ONFIELD,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf31) and c:IsType(TYPE_LINK)
end
function cm.cecondition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.desfilter(c)
	return ((not c:IsCode(15005451)) or c:IsFacedown())
end
function cm.cetarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,rp,0,LOCATION_ONFIELD,1,nil) end
end
function cm.ceoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end