--暴君律令
local m=60002254
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp)  end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local ag=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,3,3,nil)
	Duel.SetTargetCard(ag)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ag,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rc=tg:GetFirst()
	local cd=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	while rc do
		cd:RemoveCard(rc)
		rc=tg:GetNext()
	end
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,60002252) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local og=nil
		local gm=nil
		local cd2=cd:Clone()
		local num=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)-3
		for i=1,num do
			gm=cd2:GetFirst()
			op=gm:GetOverlayGroup()
			cd:AddCard(op)
			cd2:RemoveCard(gm)
		end
		local mc=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,60002252)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local mr=mc:SelectSubGroup(tp,aux.TRUE,false,1,1,tp)
		Duel.Overlay(mr:GetFirst(),cd)
	else
		Duel.Destroy(cd,REASON_EFFECT)
	end
end