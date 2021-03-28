--人理之基 夏洛克·福尔摩斯
function c22020490.initial_effect(c)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020490,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22020490)
	e1:SetCost(c22020490.discost)
	e1:SetTarget(c22020490.thtg)
	e1:SetOperation(c22020490.thop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020490,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,22020491)
	e2:SetCondition(c22020490.condition1)
	e2:SetTarget(c22020490.target1)
	e2:SetOperation(c22020490.operation1)
	c:RegisterEffect(e2)
end
function c22020490.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c22020490.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c22020490.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if not Duel.IsPlayerAffectedByEffect(tp,22020500) and chk==0 then return Duel.IsExistingMatchingCard(c22020490.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	if Duel.IsPlayerAffectedByEffect(tp,22020500) and chk==0 then return Duel.IsExistingMatchingCard(c22020490.thfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
function c22020490.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,22020500) then g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0) end
	if Duel.IsPlayerAffectedByEffect(tp,22020500) then g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,LOCATION_EXTRA) end
	Duel.ConfirmCards(tp,g)
	if not Duel.IsPlayerAffectedByEffect(tp,22020500) then g=Duel.SelectMatchingCard(tp,c22020490.thfilter,tp,LOCATION_EXTRA,0,1,1,nil) end
	if Duel.IsPlayerAffectedByEffect(tp,22020500) then g=Duel.SelectMatchingCard(tp,c22020490.thfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetTarget(c22020490.sumlimit)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_MSET)
		Duel.RegisterEffect(e3,tp)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_ACTIVATE)
		e4:SetValue(c22020490.aclimit)
		Duel.RegisterEffect(e4,tp)
	end
end
function c22020490.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function c22020490.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end
function c22020490.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c22020490.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	c22020490.announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(c22020490.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function c22020490.operation1(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,hg)
	if g:GetCount()>0 then
	   local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetValue(aux.TRUE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else
		 Duel.SkipPhase(tp,Duel.GetCurrentPhase(),RESET_PHASE+PHASE_END,1)
	end
end