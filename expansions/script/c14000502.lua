--异态魔女·路-02
local m=14000502
local cm=_G["c"..m]
cm.named_with_Spositch=1
xpcall(function() require("expansions/script/c14000501") end,function() require("script/c14000501") end)
function cm.initial_effect(c)
	--splimit
	spo.splimit(c)
	--spelleffect
	spo.SpositchSpellEffect(c,CATEGORY_DESTROY+CATEGORY_TOEXTRA,EFFECT_FLAG_CARD_TARGET,cm.destg,cm.desop)
	--peneffect
	spo.SpositchPendulumEffect(c,CATEGORY_TOEXTRA+CATEGORY_TOHAND,cm.thtg,cm.thop)
	--[[spsummon condition
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	--e1:SetValue(cm.splimit)
	--c:RegisterEffect(e1)]]--
end
function cm.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc and spo.named(sc)
end
function cm.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and cm.filter(chkc) and chkc~=e:GetHandler() end
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
		return checknum==1 and Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and not c:IsForbidden()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,tp,LOCATION_SZONE)
	c:CancelToGrave(false)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		if c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.SendtoExtraP(c,nil,REASON_EFFECT)
		end
	end
end
function cm.thfilter(c)
	return c:IsType(TYPE_QUICKPLAY) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsForbidden() end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsType(TYPE_PENDULUM) or not c:IsRelateToEffect(e) then return end
	if Duel.SendtoExtraP(c,nil,REASON_EFFECT)==0 then return end
	if not Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end