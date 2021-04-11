--异态魔女·岚-78
local m=14000512
local cm=_G["c"..m]
cm.named_with_Spositch=1
xpcall(function() require("expansions/script/c14000501") end,function() require("script/c14000501") end)
function cm.initial_effect(c)
	--splimit
	spo.splimit(c)
	--spelleffect
	spo.SpositchSpellEffect(c,CATEGORY_RELEASE+CATEGORY_TOEXTRA,EFFECT_FLAG_CARD_TARGET,cm.tg,cm.op)
	--peneffect
	spo.SpositchPendulumEffect(c,CATEGORY_RELEASE+CATEGORY_TOEXTRA,cm.tdtg,cm.tdop)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsReleasableByEffect() end
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
		return checknum==1 and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and not c:IsForbidden()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,Card.IsReleasableByEffect,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,tp,LOCATION_SZONE)
	c:CancelToGrave(false)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		Duel.Release(tc,REASON_EFFECT)
		if c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.SendtoExtraP(c,nil,REASON_EFFECT)
		end
	end
end
function cm.cfilter(c)
	return c:IsReleasableByEffect() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsForbidden() end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_ONFIELD)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsType(TYPE_PENDULUM) or not c:IsRelateToEffect(e) then return end
	if Duel.SendtoExtraP(c,nil,REASON_EFFECT)==0 then return end
	if not Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Release(tc,REASON_EFFECT)
	end
end