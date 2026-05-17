--破碎世界的死神 坦尼尔
local s,id,o=GetID()

local CODE_ALICE = 6100440 -- 卡名记述标记
local FLAG_FLIP  = 6100446 -- 沙漏的专属反转标记

function s.initial_effect(c)
	-- 声明记述卡名
	aux.AddCodeList(c,CODE_ALICE)

	-- 全局监听：本回合是否有怪兽被解放
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_RELEASE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end

	-- ①：特召并触发后续操作
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
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

	-- ②：滤抽 + 降攻与战伤翻倍
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(s.effcon)
	e3:SetTarget(s.efftg)
	e3:SetOperation(s.effop)
	c:RegisterEffect(e3)
end

-- === 全局解放监听 ===
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
end

-- === 效果① ===
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	-- 诱发条件：怪兽由(原生的)回合玩家召唤·特殊召唤的场合
	return eg:IsExists(Card.IsSummonPlayer, 1, nil, Duel.GetTurnPlayer())
end

function s.alicefilter(c,e,tp)
	return c:IsCode(CODE_ALICE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingMatchingCard(s.alicefilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.alicefilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g==0 then return end
	g:AddCard(c)
	
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- 给特召的怪兽打上标记，结束阶段回手
		local fid=c:GetFieldID()
		for tc in aux.Next(g) do
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		end
		g:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)

		-- 【核心机制：获取真实视角的“回合玩家”】
		local turn_p = Duel.GetTurnPlayer()
		if Duel.GetFlagEffect(tp, FLAG_FLIP) ~= 0 then
			turn_p = 1 - turn_p
			Duel.ResetFlagEffect(tp, FLAG_FLIP)
			Duel.ResetFlagEffect(1-tp, FLAG_FLIP)
			Duel.Hint(HINT_CARD, 0, FLAG_FLIP)
		end
		
		-- 那之后，回合玩家可以选包含自身场上怪兽的场上2只怪兽送去墓地。
		local g_self = Duel.GetMatchingGroup(Card.IsType, turn_p, LOCATION_MZONE, 0, nil, TYPE_MONSTER)
		local g_all = Duel.GetMatchingGroup(Card.IsType, turn_p, LOCATION_MZONE, LOCATION_MZONE, nil, TYPE_MONSTER)
		if #g_self > 0 and #g_all >= 2 then
			if Duel.SelectYesNo(turn_p, aux.Stringid(id, 2)) then -- 提示文本：是否将2只怪兽送去墓地？
				Duel.BreakEffect()
				-- 步骤1：必须从自己场上选1张
				Duel.Hint(HINT_SELECTMSG, turn_p, HINTMSG_TOGRAVE)
				local sg1 = g_self:Select(turn_p, 1, 1, nil)
				-- 步骤2：从全场选第2张
				Duel.Hint(HINT_SELECTMSG, turn_p, HINTMSG_TOGRAVE)
				local sg2 = g_all:FilterSelect(turn_p, aux.TRUE, 1, 1, sg1)
				
				sg1:Merge(sg2)
				Duel.HintSelection(sg1)
				Duel.SendtoGrave(sg1, REASON_EFFECT)
			end
		end
	end
end

-- 回手卡辅助函数
function s.retfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(s.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	end
	return true
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(s.retfilter,nil,e:GetLabel())
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end

-- === 效果② ===
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	-- 怪兽被解放过的回合
	return Duel.GetFlagEffect(0,id)>0
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- 自己手卡最多2张丢弃，自己抽出丢弃的数量
	local ct = Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0)
	local deck_ct = Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0)
	local max = math.min(ct, deck_ct, 2)
	
	if max > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
		local g = Duel.SelectMatchingCard(tp, aux.TRUE, tp, LOCATION_HAND, 0, 1, max, nil)
		if #g > 0 and Duel.SendtoGrave(g, REASON_EFFECT+REASON_DISCARD) > 0 then
			local d_ct = Duel.GetOperatedGroup():GetCount()
			Duel.Draw(tp, d_ct, REASON_EFFECT)
			
			-- 效果处理后，执行翻转判定
			local turn_p = Duel.GetTurnPlayer()
			if Duel.GetFlagEffect(tp, FLAG_FLIP) ~= 0 then
				turn_p = 1 - turn_p
				Duel.ResetFlagEffect(tp, FLAG_FLIP)
				Duel.ResetFlagEffect(1-tp, FLAG_FLIP)
				Duel.Hint(HINT_CARD, 0, FLAG_FLIP)
			end
			
			local opp = 1 - turn_p
			
			-- 这个回合，回合玩家场上怪兽的攻击力下降1000
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e1:SetTarget(function(eff,tc) return tc:IsControler(turn_p) end)
			e1:SetValue(-1000)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			
			-- 给与对方(以turn_p来看的对方)的战斗伤害变成2倍
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
			e2:SetCondition(function(eff,tp_d,eg_d,ep_d,ev_d,re_d,r_d,rp_d)
				-- 只有当受到伤害的玩家为opp时适用
				return ep_d == opp
			end)
			e2:SetOperation(function(eff,tp_d,eg_d,ep_d,ev_d,re_d,r_d,rp_d)
				Duel.ChangeBattleDamage(ep_d, ev_d * 2)
			end)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end