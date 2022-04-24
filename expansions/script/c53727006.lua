local m=53727006
local cm=_G["c"..m]
cm.name="漏洞修复"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	aux.AddCodeList(c,53727003)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(cm.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,3,nil,TYPE_MONSTER) then c:RegisterFlagEffect(m,RESET_EVENT+0x4fe0000,0,1) end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,53727003):GetClassCount(Card.GetOriginalCodeRule)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	local b1=ct>Duel.GetFlagEffect(0,m) and g:IsExists(Card.IsAbleToDeck,1,nil)
	local b2=ct>Duel.GetFlagEffect(0,m+33)+2 and g:IsExists(Card.IsAbleToHand,1,nil)
	local b3=ct>Duel.GetFlagEffect(0,m+66)+4 and g:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false)
	if chk==0 then return b1 or b2 or b3 end
	SNNM.CyberNSwitch(e:GetHandler())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	SNNM.CyberNSwitch(e:GetHandler())
	local ct=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,53727003):GetClassCount(Card.GetOriginalCodeRule)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	local b1=ct>Duel.GetFlagEffect(0,m) and g:IsExists(Card.IsAbleToDeck,1,nil)
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,3))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg1=g:FilterSelect(tp,Card.IsAbleToDeck,1,1,nil)
		Duel.SendtoDeck(rg1,nil,2,REASON_EFFECT)
		g:Sub(rg1)
		Duel.RegisterFlagEffect(0,m,0,0,0)
	end
	local b2=ct>Duel.GetFlagEffect(0,m+33)+2 and g:IsExists(Card.IsAbleToHand,1,nil)
	if b2 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,4))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local rg2=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
		Duel.SendtoHand(rg2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,rg2)
		g:Sub(rg2)
		Duel.RegisterFlagEffect(0,m+33,0,0,0)
	end
	local b3=ct>Duel.GetFlagEffect(0,m+66)+4 and g:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false)
	if b3 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,5))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg3=g:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,false,false)
		Duel.SpecialSummon(rg3,0,tp,tp,false,false,POS_FACEUP)
		Duel.RegisterFlagEffect(0,m+66,0,0,0)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and Duel.IsExistingMatchingCard(function(c)return c:GetFlagEffect(m)~=0 and c:IsCode(53727002) and c:GetSummonType()&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION and c:IsFaceup()end,tp,LOCATION_MZONE,0,1,nil) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
