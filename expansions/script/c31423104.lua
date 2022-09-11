local m=31423104
local cm=_G["c"..m]
cm.name="星鱼狂潮『行星潮』"
if not pcall(function() require("expansions/script/c31423000") end) then require("expansions/script/c31423000") end
function cm.initial_effect(c)
	Seine_space_ghoti.spell_ini(c,3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(Seine_space_ghoti.sfcode-1,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsCode(Seine_space_ghoti.sfcode) and (c:IsAbleToHand() or c:IsAbleToGrave() or c:IsAbleToRemove())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	local options={}
	if tc:IsAbleToHand() then table.insert(options,1190) end
	if tc:IsAbleToGrave() then table.insert(options,1191) end
	if tc:IsAbleToRemove() then table.insert(options,1192) end
	local op=options[Duel.SelectOption(tp,table.unpack(options))+1]
	if op==1190 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	if op==1191 then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	if op==1192 then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end