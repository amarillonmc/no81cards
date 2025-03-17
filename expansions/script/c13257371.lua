--上上下下LRLRBA
local m=13257371
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--[[
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.activate1)
	c:RegisterEffect(e2)
	]]
	
end
function cm.canActivate(c,PCe,eg,ep,ev,re,r,rp)
	local tep=c:GetControler()
	local target=PCe:GetTarget()
	return not target or target(PCe,tep,eg,ep,ev,re,r,rp,0)
end
function cm.filter(c,eg,ep,ev,re,r,rp)
	local PCe=tama.getTargetTable(c,"power_capsule")
	return c:IsFaceup() and PCe and cm.canActivate(c,PCe,eg,ep,ev,re,r,rp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc,eg,ep,ev,re,r,rp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,0))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,eg,ep,ev,re,r,rp)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SOUND,0,aux.Stringid(m,7))
		local tep=tc:GetControler()
		local PCe=tama.getTargetTable(tc,"power_capsule")
		if PCe and cm.canActivate(tc,PCe,eg,ep,ev,re,r,rp) then
			local i=0
			while i<4 and (i==0 or Duel.SelectYesNo(tp,aux.Stringid(m,1))) do
				--local cost=PCe:GetCost()
				local target=PCe:GetTarget()
				local operation=PCe:GetOperation()
				Duel.ClearTargetCard()
				e:SetProperty(PCe:GetProperty())
				tc:CreateEffectRelation(PCe)
				--if cost then cost(PCe,tep,eg,ep,ev,re,r,rp,1) end
				if target then target(PCe,tep,eg,ep,ev,re,r,rp,1) end
				if operation then operation(PCe,tep,eg,ep,ev,re,r,rp) end
				tc:ReleaseEffectRelation(PCe)
				i=i+1
			end
			Duel.Hint(11,0,aux.Stringid(m,8))
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.filter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x351)
		and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function cm.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetCode()
		local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,code)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SOUND,0,aux.Stringid(m,7))
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		local sg=Duel.GetOperatedGroup():Filter(cm.spfilter,nil,e,tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		if sg:GetCount()>0 and ft>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=sg:Select(tp,1,ft,nil)
			local sc=sg1:GetFirst()
			while ft>0 and sc do
				Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
				ft=ft-1
				sc=sg1:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
		Duel.Hint(11,0,aux.Stringid(m,8))
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then return 0 end
	return val
end
