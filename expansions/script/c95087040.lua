-- 脑电波干扰(测试)
local s, id, o = GetID()
-- 使用 _G 全局表，确保不同脚本间共享（如果多张此类卡，会共用同一个状态）
if not _G.HIJACK then
	_G.HIJACK = {
		active = false,	  -- 是否处于激活状态（即卡片效果是否生效）
		controller = nil,	-- 当前控制者（这张卡的控制者）
		original = {}		-- 保存被重写的原始函数，以便后续恢复
	}
end

-- 卡片的主初始化函数，在卡片创建时调用，用于注册效果
function s.initial_effect(c)
	-- 效果1：发动时的效果（开启选择权转移）
	local e1 = Effect.CreateEffect(c)		   -- 创建一个效果对象
	e1:SetType(EFFECT_TYPE_ACTIVATE)			-- 设置为魔法陷阱卡的发动类型
	e1:SetCode(EVENT_FREE_CHAIN)				 -- 可以在任意自由时点发动
	e1:SetOperation(s.activate)				   -- 指定发动时要执行的操作函数
	c:RegisterEffect(e1)						   -- 将效果注册给卡片c

	-- 效果2：离场时的效果（关闭选择权转移）
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)  -- 单体持续效果，监听事件
	e2:SetCode(EVENT_LEAVE_FIELD)				 -- 监听卡片离开场上的事件
	e2:SetOperation(s.leave)					   -- 指定事件触发时的操作函数
	c:RegisterEffect(e2)						   -- 注册效果
end

-- 发动时的操作函数：开启选择权转移
function s.activate(e, tp, eg, ep, ev, re, r, rp)
	-- 如果已经激活，则直接返回，避免重复开启
	if _G.HIJACK.active then return end
	-- 记录控制者（发动这张卡的玩家）
	_G.HIJACK.controller = tp
	_G.HIJACK.active = true
	-- 重写全局选择函数，将选择权转移给控制者
	s.override_functions()
	-- 发送提示信息：卡图提示（HINT_CARD）和调试窗口消息
end

-- 离场时的操作函数：关闭选择权转移
function s.leave(e, tp, eg, ep, ev, re, r, rp)
	-- 如果未激活，则无需处理
	if not _G.HIJACK.active then return end
	-- 恢复被重写的原始函数
	s.restore_functions()
	-- 清除状态
	_G.HIJACK.active = false
	_G.HIJACK.controller = nil
end

-- 重写所有涉及玩家选择的全局函数
function s.override_functions()
	local H = _G.HIJACK

	-- 保存所有原始函数的引用，以便后续恢复
	H.original = {
		GroupSelect = Group.Select,
		GroupFilterSelect = Group.FilterSelect,
		GroupSelectUnselect = Group.SelectUnselect,
		CardRemoveOverlayCard = Card.RemoveOverlayCard,
		DuelSelectMatchingCard = Duel.SelectMatchingCard,
		DuelSelectReleaseGroup = Duel.SelectReleaseGroup,
		DuelSelectReleaseGroupEx = Duel.SelectReleaseGroupEx,
		DuelSelectTarget = Duel.SelectTarget,
		DuelSelectTribute = Duel.SelectTribute,
		DuelDiscardHand = Duel.DiscardHand,
		DuelRemoveOverlayCard = Duel.RemoveOverlayCard,
		DuelSelectFusionMaterial = Duel.SelectFusionMaterial,
		DuelSpecialSummon = Duel.SpecialSummon,
		DuelSpecialSummonStep = Duel.SpecialSummonStep,
		DuelMoveToField = Duel.MoveToField,
		DuelSSet = Duel.SSet,
		DuelGetControl = Duel.GetControl,
		DuelSelectDisableField = Duel.SelectDisableField,
		DuelSelectField = Duel.SelectField,
		DuelSelectEffectYesNo = Duel.SelectEffectYesNo,
		DuelSelectYesNo = Duel.SelectYesNo,
		DuelSelectOption = Duel.SelectOption,
		DuelSelectPosition = Duel.SelectPosition,
		DuelAnnounceCoin = Duel.AnnounceCoin,
		DuelAnnounceCard = Duel.AnnounceCard,
		DuelAnnounceNumber = Duel.AnnounceNumber,
		DuelHint = Duel.Hint,
	}

	-- 1. 重写 Group 相关函数
	-- Group.Select: 从一组卡片中选择一定数量的卡片
	Group.Select = function(g, sp, min, max, nc)
		-- 让控制者确认对手的里侧卡片（如果有）
		Duel.ConfirmCards(H.controller, g:Filter(s.confirmfilter, nil, H.controller))
		-- 调用原始函数，但将选择玩家从原sp改为控制者
		return H.original.GroupSelect(g, H.controller, min, max, nc)
	end

	-- Group.FilterSelect: 从一组卡片中先过滤再选择
	Group.FilterSelect = function(g, sp, ...)
		Duel.ConfirmCards(H.controller, g:Filter(s.confirmfilter, nil, H.controller))
		return H.original.GroupFilterSelect(g, H.controller, ...)
	end


	-- 3. 重写 Duel 选择类函数
	-- Duel.SelectMatchingCard: 根据条件选择卡片
	Duel.SelectMatchingCard = function(sp, f, p, sl, ol, max, min, ex, ...)
		-- 获取所有符合条件的卡片组
		local sg = Duel.GetMatchingGroup(f, p, sl, ol, ex, ...)
		-- 让控制者确认对手的里侧卡片
		Duel.ConfirmCards(H.controller, sg:Filter(s.confirmfilter, nil, H.controller))
		-- 由控制者进行选择（原sp参数被忽略）
		return H.original.DuelSelectMatchingCard(H.controller, f, p, sl, ol, max, min, ex, ...)
	end
end

-- 恢复所有原始函数
function s.restore_functions()
	local H = _G.HIJACK
	-- 将保存在H.original中的原始函数重新赋值给全局变量，恢复原状
	Group.Select = H.original.GroupSelect
	Group.FilterSelect = H.original.GroupFilterSelect
	Group.SelectUnselect = H.original.GroupSelectUnselect
	Card.RemoveOverlayCard = H.original.CardRemoveOverlayCard
	Duel.SelectMatchingCard = H.original.DuelSelectMatchingCard
	Duel.SelectReleaseGroup = H.original.DuelSelectReleaseGroup
	Duel.SelectReleaseGroupEx = H.original.DuelSelectReleaseGroupEx
	Duel.SelectTarget = H.original.DuelSelectTarget
	Duel.SelectTribute = H.original.DuelSelectTribute
	Duel.DiscardHand = H.original.DuelDiscardHand
	Duel.RemoveOverlayCard = H.original.DuelRemoveOverlayCard
	Duel.SelectFusionMaterial = H.original.DuelSelectFusionMaterial
	Duel.SpecialSummon = H.original.DuelSpecialSummon
	Duel.SpecialSummonStep = H.original.DuelSpecialSummonStep
	Duel.MoveToField = H.original.DuelMoveToField
	Duel.SSet = H.original.DuelSSet
	Duel.GetControl = H.original.DuelGetControl
	Duel.SelectDisableField = H.original.DuelSelectDisableField
	Duel.SelectField = H.original.DuelSelectField
	Duel.SelectEffectYesNo = H.original.DuelSelectEffectYesNo
	Duel.SelectYesNo = H.original.DuelSelectYesNo
	Duel.SelectOption = H.original.DuelSelectOption
	Duel.SelectPosition = H.original.DuelSelectPosition
	Duel.AnnounceCoin = H.original.DuelAnnounceCoin
	Duel.AnnounceCard = H.original.DuelAnnounceCard
	Duel.AnnounceNumber = H.original.DuelAnnounceNumber
	Duel.Hint = H.original.DuelHint
end

-- 过滤对手的里侧卡片，用于确认函数
function s.confirmfilter(c, tp)
	-- 卡片不属于控制者tp，并且是里侧表示
	return not c:IsControler(tp) and c:IsFacedown()
end

-- 返回卡片对象
return s