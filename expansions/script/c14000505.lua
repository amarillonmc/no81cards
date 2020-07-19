--异态魔女·浸-23
local m=14000505
local cm=_G["c"..m]
cm.named_with_Spositch=1
xpcall(function() require("expansions/script/c14000501") end,function() require("script/c14000501") end)
function cm.initial_effect(c)
	--splimit
	spo.splimit(c)
	--spelleffect
	spo.SpositchSpellEffect(c,CATEGORY_TOHAND+CATEGORY_TOEXTRA,EFFECT_FLAG_CARD_TARGET,cm.stdtg,cm.stdop)
	--peneffect
	spo.SpositchPendulumEffect(c,CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON,cm.tdtg,cm.tdop)
end
function cm.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function cm.stdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and cm.thfilter(chkc) end
	if chk==0 then
		local checknum=0
		local e1_2=Effect.CreateEffect(c)
		e1_2:SetType(EFFECT_TYPE_SINGLE)
		e1_2:SetCode(EFFECT_CHANGE_TYPE)
		e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_2:SetValue(TYPE_SPELL+TYPE_QUICKPLAY)
		e1_2:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1_2,true)
		local ce=c:GetActivateEffect()
		if ce:IsActivatable(tp,false,true) then checknum=1 end
		e1_2:Reset()
		return checknum==1 and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and not c:IsForbidden()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,tp,LOCATION_SZONE)
	c:CancelToGrave(false)
end
function cm.stdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.SendtoExtraP(c,nil,REASON_EFFECT)
		end
	end
end
function cm.spfilter(c,e,tp)
	return spo.named(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsForbidden() end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsType(TYPE_PENDULUM) or not c:IsRelateToEffect(e) then return end
	if Duel.SendtoExtraP(c,nil,REASON_EFFECT)==0 then return end
	if not Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end