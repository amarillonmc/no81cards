--我来做你的对手。
---@param c Card
if not c71403001 then dofile("expansions/script/c71403001.lua") end
function c71403017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71403014,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetCost(yume.PPTLimitCost)
	e1:SetValue(yume.PPTActivateZonesLimitForPlacingPend)
	e1:SetTarget(c71403017.tg1)
	e1:SetOperation(c71403017.op1)
	c:RegisterEffect(e1)
	yume.RegPPTSTGraveEffect(c,71403014)
	if not c71403017.global_check then
		c71403017.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetCondition(c71403017.regcon)
		ge1:SetOperation(c71403017.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHANGE_POS)
		ge2:SetOperation(c71403017.regop2)
		Duel.RegisterEffect(ge2,0)
	end
	yume.PPTCounter()
end
function c71403017.lffilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousSetCard(0x715)
		and c:IsPreviousPosition(POS_FACEUP) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function c71403017.lffilter2(c,tp)
	return c:GetOwner()==tp and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c71403017.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71403017.lffilter,1,nil)
end
function c71403017.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c71403017.lffilter,nil)
	if g:IsExists(c71403017.lffilter2,1,nil,0) then
		Duel.RegisterFlagEffect(0,71403017,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
	if g:IsExists(c71403017.lffilter2,1,nil,1) then
		Duel.RegisterFlagEffect(1,71403017,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
end
function c71403017.posfilter(c)
	return c:GetFlagEffect(71503017)==0
end
function c71403017.regop2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c71403017.posfilter,nil)
	Duel.RegisterFlagEffect(0,71503017,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1,g:GetCount())
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(71503017,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
end
function c71403017.xyzfilter(c)
	return c:IsSetCard(0x715) and c:IsXyzSummonable(nil)
end
function c71403017.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local exg=Duel.GetMatchingGroup(c71403017.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then
		local pg=Duel.GetMatchingGroup(yume.PPTPlacePendExceptFromFieldFilter,tp,LOCATION_EXTRA,0,nil)
		return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and yume.QuickDualSelectCheck(pg,exg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,exg,1,0,0)
end
function c71403017.placeop(tc,tp)
	return Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function c71403017.op1(e,tp,eg,ep,ev,re,r,rp)
	local pg=Duel.GetMatchingGroup(yume.PPTPlacePendExceptFromFieldFilter,tp,LOCATION_EXTRA,0,nil)
	local exg=Duel.GetMatchingGroup(c71403017.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	pg,exg=yume.QuickDualSelect(tp,pg,exg,HINTMSG_TOFIELD,HINTMSG_SPSUMMON,c71403017.placeop,tp)
	if exg:GetCount()>0 then
		Duel.BreakEffect()
		local xyzc=exg:GetFirst()
		if Duel.GetFlagEffect(tp,71403017)~=0 then
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_SPSUMMON_SUCCESS)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			e1:SetOperation(c71403017.regop3)
			xyzc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetOperation(c71403017.desop)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
		Duel.XyzSummon(tp,xyzc,nil)
	end
end
function c71403017.regop3(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetOwner())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function c71403017.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,71403017)
	local res=table.pack(Duel.GetFlagEffectLabel(tp,71503017))
	local ct=0
	for i=1,res.n do
		ct=ct+res[i]
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if ct>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71403017,1)) then
		local dg=g:Select(tp,1,ct,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end