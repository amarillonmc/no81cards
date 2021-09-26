--灵兽使 莉兹
--21.08.03
local m=11451609
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xb5) and c:IsAbleToRemove()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,nil)
	local c=e:GetHandler()
	if chk==0 then return #g>0 and c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local c=e:GetHandler()
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end