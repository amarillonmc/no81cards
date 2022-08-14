local m=53796061
local cm=_G["c"..m]
cm.name="危机沿触"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c,lsc,rsc)
	if lsc>rsc then lsc,rsc=rsc,lsc end
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and lv>0 and lv>lsc and lv<rsc and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lc,rc=Duel.GetFieldCard(tp,LOCATION_PZONE,0),Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if chk==0 then return lc and rc and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,lc:GetLeftScale(),rc:GetRightScale()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local lc,rc=Duel.GetFieldCard(tp,LOCATION_PZONE,0),Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not lc or not rc then return end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil,lc:GetLeftScale(),rc:GetRightScale())
	if #g==0 then return end
	local ct=g:GetClassCount(Card.GetCode)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	if sg and sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
