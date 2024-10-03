if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53718031
local cm=_G["c"..m]
cm.name="太乙真人"
function cm.initial_effect(c)
	aux.AddCodeList(c,53718001)
	aux.AddCodeList(c,53718002)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		Duel.RegisterFlagEffect(0,m+66,0,0,0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(cm.count)
		Duel.RegisterEffect(ge1,0)
	end
	SNNM.ActivatedAsSpellorTrapCheck(c)
end
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_CODE)
	if code~=53718001 and code~=53718002 then return end
	Duel.RegisterFlagEffect(0,m+(code-53718001)*33,RESET_PHASE+PHASE_END,0,1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and not e:GetHandler():IsPublic()
end
function cm.filter(c,tp,e)
	if not c:IsCode(53718001,53718002) then return false end
	if e and c:IsImmuneToEffect(e) then return false end
	local ae=c:GetActivateEffect()
	if not ae then return false end
	local e1=ae:Clone()
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	local pro1,pro2=ae:GetProperty()
	pro1=pro1|EFFECT_FLAG_DELAY
	pro1=pro1|EFFECT_FLAG_UNCOPYABLE
	e1:SetProperty(pro1,pro2)
	c:RegisterEffect(e1,true)
	local e2=SNNM.AASTregi(c,e1)
	local res=false
	if e1:IsActivatable(tp) then res=true end
	e2:Reset()
	e1:Reset()
	return res
end
function cm.thfilter(c,code)
	return (c:IsCode(m-8) or aux.IsCodeListed(c,code)) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b=Duel.GetFlagEffect(0,m)>0 and Duel.GetFlagEffect(0,m+33)>0
	if chk==0 then return (cm.GetSZoneCount(tp)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,tp,nil)) or (Duel.GetFlagEffect(0,m)>0 and Duel.GetFlagEffect(0,m+33)>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(cm.regop)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	c:RegisterEffect(e2)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(0,m)>0 and Duel.GetFlagEffect(0,m+33)>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode()) and (not (cm.GetSZoneCount(tp)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,tp,e)) or Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,c:GetCode())
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,tp,e):GetFirst()
		if not tc then return end
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		local ct=Duel.GetFlagEffectLabel(0,m+66)
		Duel.SetFlagEffectLabel(0,m+66,ct+1)
		local ae=tc:GetActivateEffect()
		local e1=ae:Clone()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetRange(LOCATION_HAND)
		local pro1,pro2=ae:GetProperty()
		pro1=pro1|EFFECT_FLAG_DELAY
		pro1=pro1|EFFECT_FLAG_UNCOPYABLE
		e1:SetProperty(pro1,pro2)
		e1:SetCode(EVENT_CUSTOM+m)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCountLimit(1)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ct end)
		tc:RegisterEffect(e1)
		local e1_1,e2,e3,e2_1=SNNM.ActivatedAsSpellorTrap(tc,0x10002,LOCATION_HAND,true,e1)
		e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		local hte1=Effect.CreateEffect(c)
		hte1:SetType(EFFECT_TYPE_FIELD)
		hte1:SetCode(53765050)
		hte1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		hte1:SetLabelObject(e3)
		hte1:SetTargetRange(1,1)
		Duel.RegisterEffect(hte1,0)
		Duel.AdjustAll()
		Duel.RaiseEvent(Group.FromCards(tc),EVENT_CUSTOM+m,e,0x40,tp,tp,ct)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject() then
		e:Reset()
		return
	end
	if rp==tp then return end
	local ev0=Duel.GetCurrentChain()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:GetLabelObject(e)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(cm.reset)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	c:ResetEffect(EFFECT_PUBLIC,RESET_CODE)
	if e:GetLabelObject() then e:GetLabelObject():Reset() end
	e:Reset()
end
function cm.cfilter(c)
	return c:IsSetCard(0x353c) and c:IsType(TYPE_MONSTER) and c:IsAbleToExtraAsCost()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function cm.sfilter(c)
	return c:IsStatus(STATUS_LEAVE_CONFIRMED) and c:GetSequence()<5
end
function cm.GetSZoneCount(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	return ft+Duel.GetMatchingGroupCount(cm.sfilter,tp,LOCATION_SZONE,0,nil)
end
