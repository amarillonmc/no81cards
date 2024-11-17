local m=15005731
local cm=_G["c"..m]
cm.name="德尔塔式骸分裂"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(0)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--pos
	local e3=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.postg)
	e3:SetOperation(cm.posop)
	c:RegisterEffect(e3)
end
function cm.cfilter(c,e,tp,chkr)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_REMOVED,0,nil,e,tp)
	return c:IsSetCard(0xcf3f) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and g:CheckSubGroup(cm.costcheck,1,3,c,e,tp,chkr)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xcf3f) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(1)
end
function cm.costcheck(g,sc,e,tp,chkr)
	return g:GetClassCount(Card.GetCode)==#g and g:GetSum(Card.GetLevel)==sc:GetLevel()
		and ((chkr==0 and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==0) or (chkr>=1 and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1))
		and Duel.GetMZoneCount(tp)>=#g
		and ((Duel.IsPlayerAffectedByEffect(tp,59822133) and #g==1) or (not Duel.IsPlayerAffectedByEffect(tp,59822133)))
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local chkr=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_HAND,0,nil,e,tp,chkr)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return #g>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,chkr):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	e:SetLabelObject(tc)
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local chkr=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_REMOVED,0,nil,e,tp)
	if not g:CheckSubGroup(cm.costcheck,1,3,tc,e,tp,chkr) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,cm.costcheck,false,1,3,tc,e,tp,chkr)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_DEFENSE)
	local fg=sg:Filter(Card.IsFacedown,nil)
	if #fg>0 then Duel.ConfirmCards(1-tp,fg) end
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.ChangePosition(g:GetFirst(),POS_FACEUP_DEFENSE)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.ChangePosition(g:GetFirst(),POS_FACEDOWN_DEFENSE)
		end
	end
end