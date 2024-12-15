--结局已定 尚未开端
local m=79100170
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcEqual2(c,cm.filter,LOCATION_HAND+LOCATION_GRAVE,nil,nil,true)
	e1:SetCountLimit(1,m)
	--e1:SetCost(cm.cost)
	c:RegisterEffect(e1)
	--search&to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_DECKDES+EVENT_TO_GRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+1)
	--e2:SetCost(cm.cost)
	e2:SetCondition(cm.tgcon)
	e2:SetTarget(cm.setg)
	e2:SetOperation(cm.seop)
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
function cm.filter(c,e,tp)
	return c:IsSetCard(0xa10)
end
function cm.filter1(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
	and c:IsRace(RACE_FIEND)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_HAND)
end
function cm.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil) end
end
function cm.seop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end