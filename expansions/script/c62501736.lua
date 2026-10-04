--蚀痕无命 圣誓衡枢
function c62501736.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xea4),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),1,283,true)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c62501736.splimit)
	c:RegisterEffect(e0)
	--spsummon
	local se0=Effect.CreateEffect(c)
	se0:SetType(EFFECT_TYPE_FIELD)
	se0:SetCode(EFFECT_SPSUMMON_PROC)
	se0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	se0:SetRange(LOCATION_EXTRA)
	--se0:SetValue(SUMMON_TYPE_FUSION)
	se0:SetCondition(c62501736.sprcon)
	se0:SetTarget(c62501736.sprtg)
	se0:SetOperation(c62501736.sprop)
	c:RegisterEffect(se0)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)--TIMING_END_PHASE
	e1:SetDescription(aux.Stringid(62501736,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,62501736)
	e1:SetCost(c62501736.tdcost)
	e1:SetTarget(c62501736.tdtg)
	e1:SetOperation(c62501736.tdop)
	c:RegisterEffect(e1)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,62501736+1)
	e4:SetTarget(c62501736.rmtg)
	e4:SetOperation(c62501736.rmop)
	c:RegisterEffect(e4)
	c62501736.remove_event_effect=e4
end
function c62501736.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c62501736.matfilter(c)
	return c:IsFacedown() and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
end
function c62501736.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetOwner()
	local mg=Duel.GetMatchingGroup(c62501736.matfilter,tp,LOCATION_REMOVED,0,nil)
	return #mg>=6 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c62501736.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(c62501736.matfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=mg:SelectSubGroup(tp,aux.TRUE,true,6,6,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c62501736.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	c:SetMaterial(mg)
	Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL)
	mg:DeleteGroup()
end
function c62501736.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 or e:GetHandler():IsAbleToRemove(tp,POS_FACEDOWN) end
	if #g==3 then
		Duel.DisableShuffleCheck()
	end
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c62501736.gcheck(sg)
	return sg:GetClassCount(Card.GetLocation)==#sg and sg:FilterCount(Card.IsOnField,nil)==1
end
function c62501736.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,1,nil) and (Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)==0 or g:CheckSubGroup(c62501736.gcheck,3,3)) end
end
function c62501736.tdop(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(tp,cg)
		Duel.ShuffleHand(1-tp)
		if Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)==0 then return end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
		local sg=g:SelectSubGroup(1-tp,c62501736.gcheck,false,3,3)
		if #sg>0 then
			Duel.BreakEffect()
			Duel.HintSelection(sg)
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_RULE,1-tp)
		end
	end
end
function c62501736.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==#g end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,tp,0)
end
function c62501736.thfilter(c)
	return c:IsSetCard(0xea4) and not c:IsCode(62501736) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and aux.NecroValleyFilter()(c) and (c:IsFacedown() or not c:IsLocation(LOCATION_REMOVED))
end
function c62501736.rmop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetDecktopGroup(tp,3)
	local c=e:GetHandler()
	if not rg or #rg==0 or Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)==0 then return end
	if Duel.IsExistingMatchingCard(c62501736.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(62501736,2)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c62501736.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,c62501736.gcheck,false,1,3)
		--Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
