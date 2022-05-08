--银流秘术H·贝鲁意志结界
local m=33701608
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Removed Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
end
cm.toss_coin=true
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	local sg=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local sg=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,0,nil)
	local lp=Duel.GetLP(1-tp)
	local num=0
	if g:GetCount()>0 and sg:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		num=num+og:GetCount()
		Duel.Release(sg,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		num=num+og:GetCount()
	end
	local coin1=Duel.TossCoin(tp,num)
	local coin2=num-coin1
	Duel.Recover(tp,coin1*2000,REASON_EFFECT)
	local num=Duel.Recover(1-tp,coin2*2000,REASON_EFFECT) 
	if coin2*2000>lp then
		Duel.Damage(tp,10000,REASON_EFFECT)
	end
end
--Removed Summon
function cm.filter(c,e,tp)
	return c:IsFaceup() and c:IsCode(33701601) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	 end
end