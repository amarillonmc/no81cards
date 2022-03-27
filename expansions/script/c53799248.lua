local m=53799248
local cm=_G["c"..m]
cm.name="上梁不正"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.tgcon)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and c:IsType(TYPE_MONSTER) and c:IsPreviousControler(tp) and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.filter(c,rac,lv)
	return c:IsRace(rac) and c:GetLevel()<lv and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,eg:GetFirst():GetRace(),eg:GetFirst():GetLevel()) end
	e:SetLabel(eg:GetFirst():GetRace(),eg:GetFirst():GetLevel())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
