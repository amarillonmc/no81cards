--波动武士·紫外光剑
local cm,m=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetTarget(cm.sprtg)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetHintTiming(0,TIMING_TOGRAVE+TIMING_END_PHASE)
	e4:SetTarget(cm.grtg)
	e4:SetOperation(cm.grop)
	c:RegisterEffect(e4)
end
function cm.mzfilter(c)
	return c:IsAbleToGraveAsCost() and (c:GetLevel()>=1)
end
function cm.fselect(g,lv,c)
	local tp=c:GetControler()
	return g:GetSum(Card.GetLevel)==lv and g:GetCount()>=2 and g:IsExists(Card.IsRace,1,nil,RACE_PSYCHO) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.mzfilter,tp,LOCATION_MZONE,0,nil)
	local lv=4
	while lv<=g:GetSum(Card.GetLevel) do
		local res=g:CheckSubGroup(cm.fselect,2,#g,lv,c)
		if res then return true end
		lv=lv+4
	end
	return false
end
function cm.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.mzfilter,tp,LOCATION_MZONE,0,nil)
	local tp=c:GetControler()
	local list={}
	local lv=4
	while lv<=g:GetSum(Card.GetLevel) do
		if g:CheckSubGroup(cm.fselect,2,#g,lv,c) then table.insert(list,lv) end
		lv=lv+4
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local clv=Duel.AnnounceNumber(tp,table.unpack(list))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,cm.fselect,Duel.IsSummonCancelable(),2,#g,clv,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	Card.SetMaterial(c,sg)
	Duel.SendtoGrave(sg,REASON_COST+REASON_MATERIAL)
end
function cm.filter2(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_HAND)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_REMOVED,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_REMOVED,0,1,2,nil)
	if #g>0 then
		g:ForEach(Card.SetStatus,STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local num=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		if num>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,num,num,nil)
			Duel.SendtoDeck(sg,tp,2,REASON_EFFECT)
		end
	end
end
function cm.grtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove(tp,POS_FACEDOWN) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil,tp,POS_FACEDOWN) and c:IsAbleToRemove(tp,POS_FACEDOWN) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,2,nil,tp,POS_FACEDOWN)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.grop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=g:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=0 and c:IsRelateToEffect(e) then
		g:AddCard(c)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end