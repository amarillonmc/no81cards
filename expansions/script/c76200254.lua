--白之纯血 堤丰·尼奥斯
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,s.mafilter,s.xyzcheck,2,2)
	c:EnableReviveLimit()
	--change name
	aux.EnableChangeCode(c,76200200,LOCATION_MZONE+LOCATION_REMOVED)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.mafilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and c:IsRace(RACE_DRAGON)
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.sfilter(c,e)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x725a) and (not e or c:IsCanBeEffectTarget(e))
end
function s.mfilter(c,e)
	return c:IsRace(RACE_DRAGON) and (not e or c:IsCanBeEffectTarget(e))
end
function s.fselect(g)
	return g:FilterCount(s.sfilter,nil)==g:FilterCount(s.mfilter,nil)
end
function s.SelectSub(g1,g2,tp)
	local max=math.min(#g1,#g2)
	local sg1=Group.CreateGroup()
	local sg2=Group.CreateGroup()
	local sg=sg1+sg2
	local fg=g1+g2
	local finish=false
	while true do
		finish=#sg1==#sg2 and #sg>0
		local sc=fg:SelectUnselect(sg,tp,finish,finish,2,max*2)
		if not sc then break end
		if sg:IsContains(sc) then
			if g1:IsContains(sc) then
				sg1:RemoveCard(sc)
			else
				sg2:RemoveCard(sc)
			end
		else
			if g1:IsContains(sc) then
				sg1:AddCard(sc)
			else
				sg2:AddCard(sc)
			end
		end
		sg=sg1+sg2
		fg=g1+g2-sg
		if #sg1>=max then
			fg=fg-g1
		end
		if #sg2>=max then
			fg=fg-g2
		end
	end
	return sg
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_REMOVED,0,nil,e)
	local g2=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_REMOVED,0,nil,e)
	if chkc then return false end
	if chk==0 then return g1:GetCount()>0 and g2:GetCount()>0 end
	local tg=s.SelectSub(g1,g2,tp)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetTargetsRelateToChain()
	if #sg==0 then return end
	if sg:GetCount()>0 and Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		local g=Duel.GetOperatedGroup()
		local ct=math.floor(g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)/2)
		local dg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if ct>0 and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local dc=dg:Select(tp,1,ct,nil)
			if dc and dc:GetCount()>0 then
				Duel.BreakEffect()
				Duel.HintSelection(dc)
				Duel.SendtoHand(dc,nil,REASON_EFFECT)
			end
		end
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x725a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
