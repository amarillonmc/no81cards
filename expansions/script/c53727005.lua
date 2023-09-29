local m=53727005
local cm=_G["c"..m]
cm.name="信息对冲"
cm.cybern_numc=true
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	aux.AddCodeList(c,53727003)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
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
	local b1=ct>Duel.GetFlagEffect(0,m) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
	local b2=ct>Duel.GetFlagEffect(0,m+33)+2 and Duel.IsExistingMatchingCard(function(c)return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()end,tp,0,LOCATION_ONFIELD,1,nil)
	local b3=ct>Duel.GetFlagEffect(0,m+66)+4 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	SNNM.CyberNSwitch(e:GetHandler())
end
function cm.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsLocation(LOCATION_ONFIELD)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	SNNM.CyberNSwitch(e:GetHandler())
	local ct=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,53727003):GetClassCount(Card.GetOriginalCodeRule)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local b1=ct>Duel.GetFlagEffect(0,m) and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,3))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg1=g:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_GRAVE)
		Duel.Remove(rg1,POS_FACEUP,REASON_EFFECT)
		Duel.RegisterFlagEffect(0,m,0,0,0)
	end
	local b2=ct>Duel.GetFlagEffect(0,m+33)+2 and g:IsExists(cm.rmfilter,1,nil)
	if b2 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,4))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg2=g:FilterSelect(tp,cm.rmfilter,1,1,nil)
		Duel.HintSelection(rg2)
		Duel.Remove(rg2,POS_FACEUP,REASON_EFFECT)
		Duel.RegisterFlagEffect(0,m+33,0,0,0)
	end
	local b3=ct>Duel.GetFlagEffect(0,m+66)+4 and g:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE)
	if b3 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,5))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg3=g:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE)
		Duel.HintSelection(rg3)
		Duel.Remove(rg3,POS_FACEUP,REASON_EFFECT)
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
