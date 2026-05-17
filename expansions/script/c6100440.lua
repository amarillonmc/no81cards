--破碎世界的死神 爱丽丝
local s,id,o=GetID()

local CODE_ALICE = 6100440
local CODE_TEA_PARTY = 6100444 -- 占位符：「爱丽丝的茶会物语」

function s.initial_effect(c)
	-- 声明记述卡名
	aux.AddCodeList(c,CODE_ALICE)
	
	-- 全局监听：本回合是否有永续魔/陷效果发动
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end

	-- ①：发动茶会物语 + 追加堆墓
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.actcon)
	e1:SetCost(s.actcost)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.actop)
	c:RegisterEffect(e1)

	-- ②：回合玩家发动效果时回手，并改写那个效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.modcon)
	e2:SetCost(s.modcost)
	e2:SetTarget(s.modtg)
	e2:SetOperation(s.modop)
	c:RegisterEffect(e2)
end

-- === 全局监听 ===
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc = re:GetHandler()
	-- 判断是否为永续魔法·永续陷阱的效果发动
	if rc:IsType(TYPE_CONTINUOUS) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then
		Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
	end
end

-- === 效果① ===
function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	-- 自己回合，或永续魔法·永续陷阱的效果发动过的对方回合
	if Duel.GetTurnPlayer()==tp then return true end
	return Duel.GetFlagEffect(0,id)>0
end

function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end

-- 判断可否直接在自己场上发动的过滤器
function s.teafilter(c,tp)
	if not c:IsCode(CODE_TEA_PARTY) then return false end
	if c:IsType(TYPE_FIELD) then
		return true 
	else
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.teafilter,tp,LOCATION_DECK+LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	
	-- 【核心修复】：检查是否直接连锁了回合玩家发动的效果
	local chn = Duel.GetCurrentChain()
	local chained_turn_p = 0
	-- chn > 1 意味着此卡至少是 C2（前面一定有 C1 可以被连锁）
	if chn > 1 then
		-- 获取【上一个连锁 (chn - 1)】的玩家信息
		local p = Duel.GetChainInfo(chn - 1, CHAININFO_TRIGGERING_PLAYER)
		if p == Duel.GetTurnPlayer() then
			chained_turn_p = 1
		end
	end
	
	-- 使用 TargetParam 保存私有连锁参数，绝对不会被并发效果污染
	Duel.SetTargetParam(chained_turn_p)
end

function s.gyfilter(c)
	return aux.IsCodeListed(c,CODE_ALICE) and c:IsAbleToGrave()
end

function s.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.teafilter),tp,LOCATION_DECK+LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		-- 发动卡片 
		local te=tc:GetActivateEffect()
		if tc:IsType(TYPE_FIELD) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then Duel.SendtoGrave(fc,REASON_RULE) end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		
		-- 触发对应发动事件
		if te then
			local cost=te:GetCost()
			if cost then cost(te,tp,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
		
		-- 读取我们安全存放在这个连锁里的参数
		local chained_turn_p = Duel.GetChainInfo(0, CHAININFO_TARGET_PARAM)
		
		-- 追加效果 (并且判断1回合1次，限制挂在 id+1 的 FlagEffect 上)
		if chained_turn_p == 1 and Duel.GetFlagEffect(tp, id+1) == 0 
		and Duel.IsExistingMatchingCard(s.gyfilter,tp,LOCATION_DECK,0,1,nil) then
			if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				-- 执行了就打上标记
				Duel.RegisterFlagEffect(tp, id+1, RESET_PHASE+PHASE_END, 0, 1)
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=Duel.SelectMatchingCard(tp,s.gyfilter,tp,LOCATION_DECK,0,1,1,nil)
				if #sg>0 then
					Duel.SendtoGrave(sg,REASON_EFFECT)
				end
			end
		end
	end
end

-- === 效果②：修改连锁核心逻辑 ===
function s.modcon(e,tp,eg,ep,ev,re,r,rp)
	-- 回合玩家把卡的效果发动时
	return ep == Duel.GetTurnPlayer()
end

function s.modcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end

function s.modtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function s.modop(e,tp,eg,ep,ev,re,r,rp)
	local old_op = re:GetOperation()
	
	Duel.ChangeChainOperation(ev, function(e_o, tp_o, eg_o, ep_o, ev_o, re_o, r_o, rp_o)
		local rc = re:GetHandler()
		
		-- 【核心修复：引擎底层漏洞填补】
		-- YGOCore 在被修改 Operation 时，会由于丢失引擎的默认留场判断，将原本应留场的卡送入墓地
		-- 如果这是卡片本身的发动(而非留在场上的效果发动)，强制使其免于送墓
		if re:IsHasType(EFFECT_TYPE_ACTIVATE) then
			if rc:IsType(TYPE_CONTINUOUS+TYPE_FIELD+TYPE_EQUIP+TYPE_PENDULUM) or rc:IsHasEffect(EFFECT_REMAIN_FIELD) then
				rc:CancelToGrave(true)
			end
		end
		
		-- 1. 先执行原本的效果处理
		if old_op then 
			old_op(e_o, tp_o, eg_o, ep_o, ev_o, re_o, r_o, rp_o) 
		end
		
		-- 2. 随后执行加上的效果
		local turn_p = Duel.GetTurnPlayer()
		local opp_p = 1 - turn_p
		
		local ct1 = math.min(Duel.GetFieldGroupCount(turn_p, LOCATION_DECK, 0), 3)
		local ct2 = math.min(Duel.GetFieldGroupCount(opp_p, LOCATION_DECK, 0), 3)
		
		if ct1 > 0 then Duel.ConfirmDecktop(turn_p, ct1) end
		if ct2 > 0 then Duel.ConfirmDecktop(opp_p, ct2) end
		
		local function process_player(p, ct)
			local g = Group.CreateGroup()
			if ct > 0 then
				g:Merge(Duel.GetDecktopGroup(p, ct))
			end
			g:Merge(Duel.GetMatchingGroup(Card.IsAbleToGrave, p, LOCATION_HAND+LOCATION_ONFIELD, 0, nil))
			
			if #g > 0 then
				Duel.Hint(HINT_SELECTMSG, p, HINTMSG_TOGRAVE)
				local sg = g:FilterSelect(p, Card.IsAbleToGrave, 1, 1, nil)
				if #sg > 0 then
					Duel.SendtoGrave(sg, REASON_EFFECT)
				end
			end
		end
		
		-- 按照回合顺序各自处理
		process_player(turn_p, ct1)
		process_player(opp_p, ct2)
		
		-- 处理完后，将未送墓的翻开卡牌洗切卡组
		if ct1 > 0 then Duel.ShuffleDeck(turn_p) end
		if ct2 > 0 then Duel.ShuffleDeck(opp_p) end
	end)
end