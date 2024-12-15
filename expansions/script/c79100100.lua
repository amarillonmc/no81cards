--绯红编年史的编写者
local m=79100100
local cm=_G["c"..m]
function cm.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.destg)
	--e1:SetCost(cm.decost)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+3)
	e3:SetCost(cm.secost)
	e3:SetTarget(cm.setg)
	e3:SetOperation(cm.seop)
	c:RegisterEffect(e3)
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
--[[function cm.decost(e,tp,eg,ep,ev,re,r,rp,chk)
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
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if not Duel.IsPlayerCanDiscardDeck(tp,3) then g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil) end
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if Duel.IsPlayerCanDiscardDeck(tp,3) then Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3) end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local check=LOCATION_ONFIELD
	if not Duel.IsPlayerCanDiscardDeck(tp,3) then check=0 end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,check,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			local tc=g:GetFirst()
			if tc:IsPreviousControler(tp) and Duel.IsPlayerCanDiscardDeck(tp,3) then
			Duel.BreakEffect()
			Duel.DiscardDeck(tp,3,REASON_EFFECT)
			end
		end
	end
end
function cm.rfilter(c)
	return c:IsSetCard(0xa10) and c:IsAbleToRemoveAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_GRAVE,0,3,e:GetHandler()) --[[and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0]] end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_GRAVE,0,3,3,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	--[[local e1=Effect.CreateEffect(e:GetHandler())
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
	Duel.RegisterEffect(e2,tp)]]
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.costfilter(c)
	return c:IsSetCard(0xa10) and c:IsAbleToRemoveAsCost() and  c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsExistingMatchingCard(cm.thfilter,c:GetControler(),LOCATION_DECK,0,1,c,c:GetCode())
end
function cm.secost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,nil) --[[and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0]] end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetCode())
	--[[local e1=Effect.CreateEffect(e:GetHandler())
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
	Duel.RegisterEffect(e2,tp)]]
end
function cm.thfilter(c,code)
	return c:IsCode(code) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function cm.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.seop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	local tc=g:GetFirst()
	if g:GetCount()<=0 then return end
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end