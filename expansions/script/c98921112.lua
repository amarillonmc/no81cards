local s,id=GetID()
function s.initial_effect(c)
	--①：作为这张卡发动时的效果的处理（可选）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--②：对方墓地效果无效化
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.negcon)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end

-- 辅助函数：获取卡片在场上的绝对纵列编号 (0~4)
function s.get_column(c)
	local seq = c:GetSequence()
	if seq < 5 then
		return c:IsControler(0) and seq or (4 - seq)
	else
		-- 额外怪兽区域 (EMZ)
		if c:IsControler(0) then
			return seq == 5 and 1 or 3
		else
			return seq == 5 and 3 or 1
		end
	end
end

-- ① 效果过滤条件
function s.colfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xfe) and c:IsType(TYPE_CONTINUOUS) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function s.colfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x10c) and c:IsType(TYPE_MONSTER)
end

function s.tgfilter(c,e,tp)
	if c:IsSetCard(0x10c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) then
		return Duel.IsExistingMatchingCard(s.colfilter1,tp,LOCATION_SZONE,0,1,nil)
	elseif c:IsSetCard(0xfe) and c:IsType(TYPE_CONTINUOUS) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) then
		return Duel.IsExistingMatchingCard(s.colfilter2,tp,LOCATION_MZONE,0,1,nil)
	end
	return false
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tgfilter(chkc,e,tp) end
	-- 永续魔法卡自身的发动在任何时候都是合法的 (chk==0 时始终返回 true)
	if chk == 0 then return true end
	
	-- 询问玩家是否在发动卡片的同时，处理墓地对象的效果
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local sg=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=sg:GetFirst()
		if tc:IsType(TYPE_MONSTER) then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
		else
			e:SetCategory(0)
		end
		e:SetLabel(1) -- 标记为：玩家选择了处理效果
	else
		e:SetCategory(0)
		e:SetLabel(0) -- 标记为：玩家不处理效果，仅单纯发动卡片
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 如果玩家在发动时选择了不处理效果（Label为0），则直接结束处理
	if e:GetLabel() == 0 then return end
	
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	
	if tc:IsType(TYPE_MONSTER) then
		-- 选择自己场上的一张「星遗物」永续魔陷
		local cg=Duel.GetMatchingGroup(s.colfilter1,tp,LOCATION_SZONE,0,nil)
		if #cg==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
		local cc=cg:Select(tp,1,1,nil):GetFirst()
		
		-- 计算对应的对方主要怪兽区域位置
		local col=s.get_column(cc)
		local op_seq= (1-tp == 0) and col or (4 - col)
		
		-- 如果该区域有卡，规则破坏
		local op_card=Duel.GetFieldCard(1-tp,LOCATION_MZONE,op_seq)
		if op_card then
			Duel.Destroy(op_card,REASON_RULE)
		end
		
		-- 特殊召唤到对方场上该区域
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP,1 << op_seq)
	else
		-- 选择自己场上的一张「机界骑士」怪兽
		local cg=Duel.GetMatchingGroup(s.colfilter2,tp,LOCATION_MZONE,0,nil)
		if #cg==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
		local cc=cg:Select(tp,1,1,nil):GetFirst()
		
		-- 计算对应的对方魔法与陷阱区域位置
		local col=s.get_column(cc)
		local op_seq= (1-tp == 0) and col or (4 - col)
		
		-- 如果该区域有卡，规则破坏
		local op_card=Duel.GetFieldCard(1-tp,LOCATION_SZONE,op_seq)
		if op_card then
			Duel.Destroy(op_card,REASON_RULE)
		end
		
		-- 放置到对方场上该区域
		Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true,1 << op_seq)
	end
end

-- ② 效果判断
function s.condfilter(c,tp)
	if not (c:IsFaceup() and c:IsSetCard(0x10c) and c:IsType(TYPE_LINK)) then return false end
	local col=s.get_column(c)
	local op_seq= (1-tp == 0) and col or (4 - col)
	local op_card=Duel.GetFieldCard(1-tp,LOCATION_MZONE,op_seq)
	return not op_card -- 对方相同纵列的主要怪兽区域没有怪兽存在
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	if rp ~= 1-tp then return false end
	if not Duel.IsExistingMatchingCard(s.condfilter,tp,LOCATION_MZONE,0,1,nil,tp) then return false end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_GRAVE) ~= 0
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end