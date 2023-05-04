--异态魔女·炉-01
local m=14000501
local cm=_G["c"..m]
--script thanks for Real_Scl and 777
--functions
if not Spositch then
	Spositch=Spositch or {}
	spo=Spositch
	function spo.splimit(c)
		--pendulum summon
		aux.EnablePendulumAttribute(c)
		--revive limit
		aux.EnableReviveLimitPendulumSummonable(c,0xff)
		--splimit
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetRange(LOCATION_PZONE)
		e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetTargetRange(1,0)
		e0:SetTarget(spo.plimit)
		c:RegisterEffect(e0)
		--spsummon condition
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SPSUMMON_CONDITION)
		e1:SetValue(aux.FALSE)
		c:RegisterEffect(e1)
	end
	function spo.SpositchSpellEffect(c,cate,prop,tg,op)
		local code=c:GetOriginalCodeRule()
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(code,0))
		if cate then
			e2:SetCategory(cate)
		end
		e2:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
		prop=prop or 0
		e2:SetProperty(prop,EFFECT_FLAG2_SPOSITCH)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_HAND)
		e2:SetCondition(spo.spellcon)
		e2:SetCost(spo.spellcost)
		if tg then
			e2:SetTarget(tg)
		end
		e2:SetOperation(op)
		c:RegisterEffect(e2)
		local ccode=_G["c"..code]
		ccode.SpositchSpellEffect=e2
	end
	function spo.SpositchPendulumEffect(c,cate,tg,op)
		local code=c:GetOriginalCodeRule()
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(code,2))
		if cate then
			e3:SetCategory(cate)
		end
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e3:SetProperty(EFFECT_FLAG_DELAY)
		e3:SetCode(EVENT_CHAIN_SOLVING)
		e3:SetRange(LOCATION_PZONE)
		e3:SetCountLimit(1,code)
		e3:SetCondition(spo.pencon)
		if tg then
			e3:SetTarget(tg)
		end
		e3:SetOperation(op)
		c:RegisterEffect(e3)
		local ccode=_G["c"..code]
		ccode.SpositchPendulumEffect=e3
	end
end
function spo.named(c)
	local code=c:GetCode()
	local mt=_G["c"..code]
	if not mt then
		_G["c"..code]={}
		if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
			mt=_G["c"..code]
			_G["c"..code]=nil
		else
			_G["c"..code]=nil
			return false
		end
	end
	return mt and mt.named_with_Spositch
end
--function spo.splimit1(e,se,sp,st)
	--if not se then return end
	--local sc=se:GetHandler()
	--return sc and spo.named(sc)
--end
function spo.plimit(e,c,tp,sumtp,sumpos)
	return not c:IsLevel(11) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function spo.spellcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_HAND) and (Duel.GetTurnPlayer()==tp  or c:IsHasEffect(EFFECT_QP_ACT_IN_NTPHAND))
end
function spo.spellcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_QUICKPLAY)
	c:RegisterEffect(e1)
	c:CancelToGrave(false)
end
function spo.pencon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and (re:IsActiveType(TYPE_SPELL) or re:GetHandler():IsType(TYPE_SPELL) or spo.named(re:GetHandler()))
end

if cm then
cm.named_with_Spositch=1
function cm.initial_effect(c)
	--splimit
	spo.splimit(c)
	--spelleffect
	spo.SpositchSpellEffect(c,CATEGORY_DESTROY+CATEGORY_TOEXTRA,EFFECT_FLAG_CARD_TARGET,cm.destg,cm.desop)
	--peneffect
	spo.SpositchPendulumEffect(c,CATEGORY_TOEXTRA+CATEGORY_SEARCH+CATEGORY_TOHAND,cm.thtg,cm.thop)
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER)
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
	return spo.named(c) and (c:IsAbleToHand() or not c:IsForbidden()) and ((c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()) or c:IsLocation(LOCATION_DECK))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsForbidden() end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsType(TYPE_PENDULUM) or not c:IsRelateToEffect(e) then return end
	if Duel.SendtoExtraP(c,nil,REASON_EFFECT)==0 then return end
	if not Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:IsForbidden()
		if b1 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		elseif not b2 then
			if tc:IsType(TYPE_PENDULUM) and Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			else
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				if not tc:IsType(TYPE_SPELL) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					e1:SetValue(TYPE_SPELL)
					tc:RegisterEffect(e1)
				end
			end
		end
	end
end
end