--我偏要恶魔
local m=12847402
local cm=_G["c"..m]
function cm.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12847402,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12847402)
	e1:SetTarget(cm.rmtg)
	e1:SetCost(cm.rmcost)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
end
function cm.rmfilter(c)
	return c:IsAbleToRemove()
end
function cm.spfilter(c,e,tp)
	return not c:IsType(TYPE_TOKEN) and c:IsFaceup() and c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE,c:GetControler())
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,LOCATION_REMOVED)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup():Filter(cm.spfilter,nil,e,tp)
		if #og<=0 then return end
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
		if ft1<=0 and ft2<=0 then return end
		local spg=Group.CreateGroup()
		if ft1>0 and ft2>0 then
		local p=tp
		for i=1,2 do
			local sg=og:Filter(Card.IsControler,nil,p)
			local ft=Duel.GetLocationCount(p,LOCATION_MZONE,tp)
			if #sg>ft then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				sg=sg:Select(tp,ft,ft,nil)
			end
			spg:Merge(sg)
			p=1-tp
		end
	end
	if #spg>0 then
		Duel.BreakEffect()
		local tc=spg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tc:GetControler(),false,false,POS_FACEUP)
			tc=spg:GetNext()
		end
		Duel.SpecialSummonComplete()
		local cg=spg:Filter(Card.IsFacedown,nil)
		if #cg>0 then
			Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end