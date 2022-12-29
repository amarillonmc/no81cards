--散华灵
function c72100051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,72100051+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c72100051.cost)
	e1:SetTarget(c72100051.target)
	e1:SetOperation(c72100051.operation)
	c:RegisterEffect(e1)
end
function c72100051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c72100051.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	Duel.SetTargetParam(Duel.SelectOption(tp,1057,1056,1063,1073,1076))
end
function c72100051.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local ct=nil
	if opt==0 then ct=TYPE_RITUAL end
	if opt==1 then ct=TYPE_FUSION end
	if opt==2 then ct=TYPE_SYNCHRO end
	if opt==3 then ct=TYPE_XYZ end
	if opt==4 then ct=TYPE_LINK end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabel(ct)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c72100051.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c72100051.distg)
	e2:SetLabel(ct)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c72100051.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsType(e:GetLabel())
end
function c72100051.distg(e,c)
	return c:IsType(e:GetLabel())
end

