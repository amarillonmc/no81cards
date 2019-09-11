--罔骸神骨
local m=14001051
local cm=_G["c"..m]
cm.named_with_Goned=1
xpcall(function() require("expansions/script/c14001041") end,function() require("script/c14001041") end)
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2,nil,nil,99)
	c:EnableReviveLimit()
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(cm.deckcon)
	e1:SetOperation(cm.deckop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_DECK,0)
	e2:SetTarget(cm.dtg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--general
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(m)
	c:RegisterEffect(e3)
	--todeck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.tdcon)
	e4:SetTarget(cm.tdtg)
	e4:SetOperation(cm.tdop)
	c:RegisterEffect(e4)
end
function cm.cfilter(c,e,tp)
	return c:IsFaceup() and c:GetFlagEffect(m)==0 and c:IsHasEffect(m) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,c,e,tp)
end
function cm.spfilter(c,e,tp)
	return go.named(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,c)
end
function cm.tgfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function cm.tgfilter1(c)
	return go.named(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.deckcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) or Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c))
end
function cm.deckop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_CARD,0,m)
	local mg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	if #mg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local tc=mg:Select(tp,1,1,nil):GetFirst()
		tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,c)
		if #g>0 then
			Duel.SendtoGrave(g,nil,REASON_COST)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,c)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	end
end
function cm.dtg(e,c)
	local tp=e:GetHandler():GetControler()
	return go.named(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,c) or Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c))
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
	if #g>0 then
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT) and g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) and Duel.IsExistingMatchingCard(cm.tgfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,cm.tgfilter1,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.SendtoGrave(g,nil,REASON_EFFECT)
			end
		end
	end
end