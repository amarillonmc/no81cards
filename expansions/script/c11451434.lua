--波动武士·X光军刺
local cm,m=GetID()
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local num=g:GetSum(Card.GetLevel)
	return Duel.GetMZoneCount(tp)>0 and (num%7)==0 and num~=0 and Duel.GetDecktopGroup(tp,4):FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==4
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetDecktopGroup(tp,4)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.filter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_MONSTER)
end
function cm.filter2(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_REMOVED,0,4,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,4,tp,LOCATION_REMOVED)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_REMOVED,0,4,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_REMOVED,0,4,4,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		g=Duel.GetOperatedGroup()
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
		local num=g:Filter(cm.filter,nil):GetClassCount(Card.GetLevel)//2
		if num>0 then Duel.Draw(tp,num,REASON_EFFECT) end
	end
end