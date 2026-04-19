-- Megalith Samir（修正正确版）
local s,id,o=GetID()
function s.initial_effect(c)
	-- 仪式召唤限制
	c:EnableReviveLimit()

	-- ① 手卡公开 → 检索 → 自身仪式（新增）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.rttg)
	e1:SetOperation(s.rtop)
	c:RegisterEffect(e1)

	-- ② 仪式成功盖放（原 e3）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)

	-- ③ 快速仪式（原 e4，保留！）
	local e3=aux.AddRitualProcGreater2(c,s.ritfilter,LOCATION_HAND+LOCATION_DECK,nil,nil,true)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.rscon)
	c:RegisterEffect(e3)
end

-- ========= ① =========

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end

function s.thfilter(c)
	return c:IsSetCard(0x138) and c:IsAbleToHand()
end

function s.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
			and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	-- 检索
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end

	if not c:IsRelateToEffect(e) then return end

	-- 素材（排除自身）
	local mg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	mg:RemoveCard(c)

	-- ≥4 仪式
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,4,"Greater")
	local mat=mg:SelectSubGroup(tp,Auxiliary.RitualCheck,true,1,#mg,tp,c,4,"Greater")
	Auxiliary.GCheckAdditional=nil

	if mat and #mat>0 then
		c:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		c:CompleteProcedure()
	end
end

-- ========= ② =========

function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end

function s.setfilter(c)
	return c:IsSetCard(0x138) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()

	if tc and Duel.SSet(tp,tc)~=0 then
		-- ⭐只对速攻魔法生效，且仅自己主要阶段
		if tc:IsType(TYPE_SPELL) and tc:IsType(TYPE_QUICKPLAY)
			and Duel.GetTurnPlayer()==tp
			and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) then
			
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end

-- ========= ③ =========

function s.ritfilter(c)
	return c:IsSetCard(0x138)
end

function s.rscon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end