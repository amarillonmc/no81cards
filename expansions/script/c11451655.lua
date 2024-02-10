--perfectly metamorphosis great moth
--22.01.07
local cm,m=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
local KOISHI_CHECK=false
if Card.SetEntityCode then KOISHI_CHECK=true end
function cm.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.filter(c)
	return c:IsCode(40240595) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,58192742,0,0x11,300,200,1,RACE_INSECT,ATTRIBUTE_EARTH) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e:GetHandler()) and e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,58192742,0,0x11,300,200,1,RACE_INSECT,ATTRIBUTE_EARTH) then
		if KOISHI_CHECK then
			c:SetEntityCode(58192742,true)
			local ini=cm.initial_effect
			cm.initial_effect=function() end
			c:ReplaceEffect(m,0)
			cm.initial_effect=ini
		else
			Duel.SendtoGrave(c,REASON_EFFECT)
			c=Duel.CreateToken(tp,58192742)
		end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,c)
			local tc=g:GetFirst()
			if tc then
				if not Duel.Equip(tp,tc,c) then return end
				--Add Equip limit
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(cm.eqlimit)
				tc:RegisterEffect(e1)
				c:RegisterFlagEffect(0,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
				--activate
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetRange(LOCATION_SZONE)
				e2:SetCode(EVENT_CHAINING)
				e2:SetCondition(cm.eqcon)
				e2:SetOperation(aux.chainreg)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				local e3=e2:Clone()
				e3:SetCode(EVENT_CHAIN_SOLVING)
				e3:SetCondition(cm.accon)
				e3:SetOperation(cm.acop)
				tc:RegisterEffect(e3)
			end
		end
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function cm.accon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget() and e:GetHandler():GetFlagEffect(1)>0
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	local ct=c:GetFlagEffectLabel(m+1)
	if not ct then
		c:RegisterFlagEffect(m+1,0,0,0,1)
	else
		c:SetFlagEffectLabel(m+1,ct+1)
	end
	ct=c:GetFlagEffectLabel(m+1)
	if ct==2 then
		Duel.Hint(HINT_CARD,0,m)
		c:SetEntityCode(87756343,true)
		c:ReplaceEffect(87756343,0)
		--search
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,2))
		e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCost(cm.thcost)
		e1:SetTarget(cm.thtg)
		e1:SetOperation(cm.thop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	if ct==4 then
		Duel.Hint(HINT_CARD,0,m)
		c:SetEntityCode(14141448,true)
		c:ReplaceEffect(14141448,0)
		--search2
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,3))
		e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCost(cm.thcost2)
		e2:SetTarget(cm.thtg2)
		e2:SetOperation(cm.thop2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
	if ct==6 then
		Duel.Hint(HINT_CARD,0,m)
		c:SetEntityCode(48579379,true)
		c:ReplaceEffect(48579379,0)
		--destroy
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(m,4))
		e3:SetCategory(CATEGORY_DESTROY)
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCost(cm.descost)
		e3:SetTarget(cm.destg)
		e3:SetOperation(cm.desop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
	end
end
function cm.cfilter(c,tp)
	local lv=c:GetOriginalLevel()
	return lv>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,lv)
end
function cm.thfilter(c,lv)
	return c:GetOriginalLevel()<lv and c:IsRace(RACE_INSECT) and c:IsAbleToHand()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil,tp)
	local lv=g:GetFirst():GetOriginalLevel()
	e:SetLabel(lv)
	Duel.Release(g,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.thcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.thfilter2(c)
	return c:IsCode(77840540) and c:IsAbleToHand()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.costfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAbleToRemoveAsCost()
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end