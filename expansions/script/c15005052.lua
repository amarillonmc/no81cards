if not pcall(function() require("expansions/script/c15000000") end) then require("script/c15000000") end
local m=15005052
local cm=_G["c"..m]
cm.name="异闻鸣星-衣原体"
function cm.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,15005052)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,15005053)
	e2:SetCost(cm.cecost)
	e2:SetTarget(cm.cetg)
	e2:SetOperation(cm.ceop)
	c:RegisterEffect(e2)
	if not Satl.hearogenehirp_global_effect then
		Satl.hearogenehirp_global_effect=true
		Satl.AddHearogenehirpAdding(c)
	end
end
c15005052.chfilter=function(c)
	return c:IsType(TYPE_MONSTER)
end
c15005052.chacon=function(e,tp)
	return Duel.GetFlagEffect(tp,15005052)~=0 and Duel.IsExistingMatchingCard(c15005052.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
c15005052.chaop=function(e,tp)
	if Duel.GetFlagEffect(tp,15005052)~=0 and Duel.IsExistingMatchingCard(cm.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		Duel.BreakEffect()
		local dg=Duel.GetMatchingGroup(cm.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=dg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function cm.thfilter(c)
	return c:IsSetCard(0xaf3e) and not c:IsCode(15005052) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.cetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end
end
function cm.ceop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,15005052,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(15005052)
	e1:SetTargetRange(1,0)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
end