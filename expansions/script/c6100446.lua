--爱丽丝的沙漏
local s,id,o=GetID()

local CODE_ALICE = 6100440
local CODE_TEA_PARTY = 6100444

function s.initial_effect(c)

	aux.AddCodeList(c,CODE_ALICE)
	
	-- 规则：满足条件时，在对方回合也能从手卡发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)
	
	-- ①：主效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- === 手卡发动规则 ===
function s.teafilter(c)
	return c:IsFaceup() and c:IsCode(CODE_TEA_PARTY)
end
function s.handcon(e)
	local tp=e:GetHandlerPlayer()
	-- 条件1：「爱丽丝的茶会物语」在场上存在的场合
	if not Duel.IsExistingMatchingCard(s.teafilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then return false end
	-- 条件2：连锁回合玩家发动的效果
	local chn=Duel.GetCurrentChain()
	if chn==0 then return false end
	local p=Duel.GetChainInfo(chn,CHAININFO_TRIGGERING_PLAYER)
	return p==Duel.GetTurnPlayer()
end

-- === 效果① ===
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 预测结算时的有效回合玩家
	local turn_p = Duel.GetTurnPlayer()
	if Duel.GetFlagEffect(tp, 6100446)~= 0 then
		turn_p = 1 - turn_p
	end
	
	if chk==0 then return Duel.GetFieldGroupCount(turn_p,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-turn_p,LOCATION_MZONE)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- 【核心机制：获取真实视角的“回合玩家”】
	local turn_p = Duel.GetTurnPlayer()
	if Duel.GetFlagEffect(tp, 6100446) ~= 0 then
		turn_p = 1 - turn_p
		Duel.ResetFlagEffect(tp, 6100446)
		Duel.Hint(HINT_CARD,0,6100446)
	end
	
	-- 1. 回合玩家从自身卡组上面把最多6张卡确认，用喜欢的顺序回到卡组上面
	local ct=Duel.GetFieldGroupCount(turn_p,LOCATION_DECK,0)
	if ct>0 then
		local sort_ct = math.min(ct, 6)
		Duel.SortDecktop(turn_p, turn_p, sort_ct)
	end
	
	-- 2. 那之后，以回合玩家来看的对方可以选场上最多2只怪兽直到回合结束时除外
	local opp = 1 - turn_p
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,opp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g>0 and Duel.SelectYesNo(opp,aux.Stringid(id,2)) then -- 提示文本：是否将怪兽除外？
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,opp,HINTMSG_REMOVE)
		local sg=g:Select(opp,1,2,nil)
		Duel.HintSelection(sg)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
			local og=Duel.GetOperatedGroup()
			local fid=c:GetFieldID()
			for tc in aux.Next(og) do
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			end
			og:KeepAlive()
			-- 结束阶段回场
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabel(fid)
			e1:SetLabelObject(og)
			e1:SetCountLimit(1)
			e1:SetCondition(s.retcon)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
	
	-- 3. 注册下一次的翻转Flag (全局生效且不重置，直到被下一次系列卡效果消耗)
	Duel.RegisterFlagEffect(tp, 6100446, 0, 0, 1)
end

-- === 除外回场辅助函数 ===
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
	for tc in aux.Next(sg) do
		Duel.ReturnToField(tc)
	end
end