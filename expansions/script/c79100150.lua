--绯红编年史的存在
local m=79100150
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCost(cm.cost)
	e1:SetTarget(cm.thtg)
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+1)
	--e2:SetCost(cm.cost)
	e2:SetCondition(cm.tgcon)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
	--Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
	--Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.chainfilter(re,tp,cid)
	local race=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_RACE)
	return not (re:IsActiveType(TYPE_MONSTER) and race&(RACE_ALL&~RACE_FIEND)~=0)
end
function cm.counterfilter(c)
	return c:IsRace(RACE_FIEND)
end
--[[function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetTargetRange(1,0)
	e2:SetValue(cm.aclimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end]]
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_FIEND)
end
function cm.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsRace(RACE_FIEND)
end
function cm.thfilter(c)
	if not (c:IsSetCard(0xa10) and c:IsType(TYPE_SPELL+TYPE_TRAP)) then return false end
	return c:IsAbleToGrave() or c:IsSSetable()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToGrave() and (not tc:IsSSetable() or Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
			Duel.SendtoGrave(tc,nil,REASON_EFFECT)
		else
			if Duel.SSet(tp,g:GetFirst()) then
				if g:GetFirst():IsType(TYPE_QUICKPLAY) then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(79100150,2))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				g:GetFirst():RegisterEffect(e1)
				end
			if g:GetFirst():IsType(TYPE_TRAP) then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(79100150,2))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				g:GetFirst():RegisterEffect(e1)
				end
			end
		end
	end
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_HAND)
end
function cm.filter1(c)
	return c:IsSetCard(0xa10) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then Duel.SSet(tp,tc) end
end