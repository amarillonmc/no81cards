--自律Protoform 帕尼
--Scripted by: XGlitchy30
local id=33720017
local s=_G["c"..tostring(id)]
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--search
	local p1=Effect.CreateEffect(c)
	p1:SetDescription(aux.Stringid(id,0))
	p1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	p1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	p1:SetCode(EVENT_PHASE+PHASE_DRAW)
	p1:SetRange(LOCATION_PZONE)
	p1:SetCountLimit(1)
	p1:SetCondition(s.condition)
	p1:SetTarget(s.target)
	p1:SetOperation(s.operation)
	c:RegisterEffect(p1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.discon)
	e3:SetCost(s.discost)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
	--count pendulum summons
	if not s.global_check then
		s.global_check=true
		if not s.pendulum_summoned_names then
			s.pendulum_summoned_names={{},{}}
		end
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TURN_END)
		ge2:SetCountLimit(1)
		ge2:SetOperation(s.resetlist)
		Duel.RegisterEffect(ge2,0)
	end
end
--count pendulum summons
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local pg=eg:Filter(Card.IsSummonType,nil,SUMMON_TYPE_PENDULUM)
	if #pg~=1 then return end
	local tc=pg:GetFirst()
	if tc then
		local codes={tc:GetCode()}
		for i=1,#codes do
			table.insert(s.pendulum_summoned_names[tc:GetSummonPlayer()+1],codes[i])
		end
	end
end
function s.resetlist()
	s.pendulum_summoned_names={{},{}}
end
--search
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(5) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local codes=g:GetFirst():GetCode()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_PZONE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(codes)
		e1:SetCondition(s.retcon)
		e1:SetTarget(s.rettg)
		e1:SetOperation(s.retop)
		e:GetHandler():RegisterEffect(e1)
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	if #s.pendulum_summoned_names[tp+1]==0 then return true end
	local codes={e:GetLabel()}
	for i=1,#codes do
		for j=1,#s.pendulum_summoned_names[tp+1] do
			if codes[i]==s.pendulum_summoned_names[tp+1][j] then
				return false
			end
		end
	end
	return true
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Damage(tp,2000,REASON_EFFECT)
	else
		Duel.Destroy(c,REASON_EFFECT)
	end
end
--spsummon
function s.sumfilter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsType(TYPE_TUNER)
end
function s.cfilter(c,eg)
	return not eg:IsContains(c)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.sumfilter,1,nil,tp) and Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil,eg)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--negate
function s.sumfilter2(c,tp)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsSummonPlayer(1-tp) and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.sumfilter2,nil,tp)
	return #g==1
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(s.sumfilter2,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
end
function s.disfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(s.disfilter,nil,e)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
end