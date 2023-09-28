--他人格 ～色欲～
local cm,m=GetID()
--lib
AlterEgo=AlterEgo or {}
ae=AlterEgo
function ae.initial(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk&def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(ae.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e2)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(ae.recon)
	e3:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e3)
	--replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(ae.repcon)
	e4:SetOperation(ae.repop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCountLimit(1,c:GetOriginalCode()+1000)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(ae.sptg)
	e5:SetOperation(ae.spop)
	c:RegisterEffect(e5)
	--ptos
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(ae.ptoscon)
	e6:SetOperation(ae.ptosop)
	c:RegisterEffect(e6)
end
function ae.value(e,c)
	return Duel.GetMatchingGroupCount(ae.filter,c:GetControler(),LOCATION_ONFIELD,0,nil)*1000
end
function ae.filter(c)
	local com=_G["c"..c:GetCode()]
	return com and com.AlterEgo and c:IsFaceup()
end
function ae.cfilter(c)
	local com=_G["c"..c:GetCode()]
	return com and com.AlterEgo
end
function ae.recon(e)
	return e:GetHandler():IsLocation(LOCATION_SZONE) and not e:GetHandler():IsLocation(LOCATION_PZONE)
end
function ae.repcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function ae.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetPreviousControler()
	local num=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then num=num+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then num=num+1 end
	if (num==0 or not Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)) and not (c:IsLocation(LOCATION_DECK) and c:IsControler(c:GetOwner())) then
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
	end
end
function ae.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_EXTRA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function ae.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function ae.ptoscon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetCurrentChain()==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function ae.ptosop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(c:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(130006111,1))
	end
end
--
cm.AlterEgo=true
function cm.initial_effect(c)
	ae.initial(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(function(e) return e:GetHandler():GetFlagEffect(m)>0 end)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end
function cm.mfilter(c)
	return (bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsFaceup()) or (c:IsLocation(LOCATION_MZONE) and c:IsFacedown())
end
function cm.pfilter1(c)
	return bit.band(c:GetOriginalType(),TYPE_PENDULUM)~=0 and c:IsFaceup()
end
function cm.nspfilter(c,tp)
	return c:IsFaceup() and not Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEDOWN_DEFENSE,tp,c)
end
function cm.nsfilter(c,tp)
	return c:IsFaceup() and not c:IsSSetable(true)
end
function cm.fselect(g,tp)
	local g1=g:Filter(cm.mfilter,nil)
	local pg1=g1:Filter(cm.pfilter1,nil)
	local npg1=Group.__sub(g1,pg1)
	local g2=Group.__sub(g,g1)
	local fc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local pfc=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local xfc=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)
	if #g1>0 and (not Duel.IsPlayerCanSpecialSummon(tp) or g1:IsExists(cm.nspfilter,1,nil,tp) or #npg1>fc or #pg1>pfc or #g1>xfc) then return false end
	if #g2>0 and (not Duel.IsPlayerCanSSet(tp) or g2:IsExists(cm.nspfilter,1,nil,tp) or #g2>Duel.GetLocationCount(tp,LOCATION_SZONE)) then return false end
	return true
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local tg=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,0,LOCATION_ONFIELD,nil,e)
	if chk==0 then return tg:CheckSubGroup(cm.fselect,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=tg:SelectSubGroup(tp,cm.fselect,false,2,2,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	if g:IsExists(cm.mfilter,1,nil) then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	else
		e:SetCategory(CATEGORY_DESTROY)
	end
end
function cm.pfilter(c)
	return not ((c:IsLocation(LOCATION_HAND+LOCATION_DECK) or c:IsLocation(LOCATION_REMOVED) and c:IsFacedown())) and aux.NecroValleyFilter()(c)
end
function cm.msfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and (not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.ssfilter(c)
	return (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSSetable()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(tg,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup():Filter(cm.pfilter,nil)
		local mg=og:Filter(cm.msfilter,nil,e,tp)
		local sg=og:Filter(cm.ssfilter,nil)
		if #mg>0 or #sg>0 then Duel.BreakEffect() end
		if #mg>0 then
			Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,mg)
		end
		if #sg>0 then
			Duel.SSet(tp,mg)
		end
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsType,1-tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			local tc=g:GetFirst()
			Duel.ConfirmCards(tp,tc)
			if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,tp) or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
				Duel.SendtoHand(g,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			elseif tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,tp) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end