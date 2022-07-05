--波动节点·驻波端口
--21.07.14
local m=11451549
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetTarget(cm.sprtg)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	--grave remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.ertg)
	e3:SetOperation(cm.erop)
	c:RegisterEffect(e3)
end
function cm.mzfilter(c)
	return c:IsAbleToDeckOrExtraAsCost() and c:GetLevel()>=1 and c:IsRace(RACE_PSYCHO) and (c:IsLocation(LOCATION_GRAVE) or c:IsFacedown())
end
function cm.fselect(g)
	return g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and g:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.mzfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	return g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and g:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.mzfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,cm.fselect,Duel.IsSummonCancelable(),2,#g)
	if sg and sg:GetSum(Card.GetLevel)%5==0 then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	elseif sg and sg:GetSum(Card.GetLevel)%5~=0 then
		assert(false,"选择的怪兽合计等级不是5的倍数")
	else return false end
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	Card.SetMaterial(c,sg)
	local cg=sg:Filter(Card.IsFacedown,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_COST+REASON_MATERIAL)
	if #cg>0 then Duel.ConfirmCards(1-tp,cg) end
end
function cm.filter3(c,tp)
	return c:IsFacedown() and c:IsPreviousControler(tp) and c:IsLocation(LOCATION_REMOVED) and c:IsAbleToDeck()
end
function cm.ertg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=eg:Filter(cm.filter3,nil,tp)
	local dg=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return #tg>0 and dg and #dg>0 and dg:GetFirst():IsAbleToRemove(tp,POS_FACEDOWN) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.erop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct>0 then
			local rg=Duel.GetDecktopGroup(tp,ct)
			Duel.DisableShuffleCheck()
			Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
		end
	end
end