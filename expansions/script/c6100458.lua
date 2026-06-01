--古堡的淑女 库菈
local s,id,o=GetID()
function s.initial_effect(c)
	--全局监听：抽卡与特殊召唤追踪
	if not s.global_check then
		s.global_check=true
		-- 记录抽卡数量
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DRAW)
		ge1:SetOperation(s.drcheck)
		Duel.RegisterEffect(ge1,0)
		
		-- 记录“因自己特殊召唤”的印记
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetOperation(s.spcheck)
		Duel.RegisterEffect(ge2,0)
	end

	-- ①：丢弃检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	-- ②：墓地除外作定制化仪式召唤
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+SUMMON_TYPE_RITUAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(s.ritcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.rittg)
	e2:SetOperation(s.ritop)
	c:RegisterEffect(e2)
end

s.CATEGORY_RITUAL_SUMMON=true 
-- === 全局监听模块 ===
function s.drcheck(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnCount() == 0 or Duel.GetCurrentPhase() == 0 then return end
	
	for i=1,ev do
		Duel.RegisterFlagEffect(ep, id, RESET_PHASE+PHASE_END, 0, 1)
	end
end

function s.spcheck(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		local p = tc:GetSummonPlayer()
		-- 若存在导致特召的效果(re)，追溯至效果发动者(rp)，即使特召到了对方场上
		if re then
			p = rp
		end

		tc:RegisterFlagEffect(id+1+p, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 0, 1)
	end
end

-- === 效果①：检索并让对方抽卡 ===
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(), REASON_COST+REASON_DISCARD)
end

function s.thfilter(c)
	if not (c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()) then return false end
	local atk=c:GetAttack()
	local def=c:GetDefense()

	return atk>=0 and atk<=1800 and def>=900
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsPlayerCanDraw(1-tp, 1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end

-- === 效果②：非常规的定制化仪式召唤 ===
function s.ritcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp, id) >= 3
end

-- 完美吸纳官方禁断的秘术的过滤器写法
function s.matfilter(c,e,tp)
	local b1 = c:IsLocation(LOCATION_HAND) and c:IsControler(tp)
	local b2 = c:IsLocation(LOCATION_MZONE) and c:GetFlagEffect(id+1+tp)>0

	return (b1 or b2) and c:IsType(TYPE_MONSTER) and c:GetLevel()>0 and not c:IsImmuneToEffect(e) and c:IsReleasable()
end

function s.ritfilter(c)
	return c:IsRace(RACE_FIEND)
end

function s.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)

		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,s.ritfilter,e,tp,mg,nil,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end

function s.ritop(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,s.ritfilter,e,tp,mg,nil,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	
	if tc then
		local m=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			m=m:Filter(tc.mat_filter,tc,tp)
		else
			m:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=m:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end