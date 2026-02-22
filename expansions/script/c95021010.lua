--源能特工 霓虹
-- 卡片名：未知
local s, id = GetID()

function s.initial_effect(c)
	-- 效果①：自己主要阶段2从手卡特殊召唤（规则效果）
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon1)
	c:RegisterEffect(e1)

	-- 效果②：对方效果发动时，移动位置并无效对方怪兽
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg2)
	e2:SetOperation(s.disop2)
	c:RegisterEffect(e2)
	-- 效果③：自己·对方回合，同纵列对方卡全部破坏（决斗中一次）
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)  -- 决斗中一次
	e3:SetTarget(s.destg3)
	e3:SetOperation(s.desop3)
	c:RegisterEffect(e3)
end

-- 效果①条件：自己主要阶段2，有怪兽区域空位
function s.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

-- 效果②条件：对方发动效果，且此卡在场上
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return false end
	local c=e:GetHandler()
	if not c:IsFaceup() then return false end
	local seq=c:GetSequence()
	if seq>4 then return false end
	-- 检查是否有相邻的空位（左右）
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end

-- 效果②目标（无对象，仅设置操作信息）
function s.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 需要确保对方场上有表侧怪兽可选
		return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	end
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local flag=0
	if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
	if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
	-- 让玩家选择移动到的区域
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)  -- 将区域位转换为序列号
	e:SetLabel(nseq)		  -- 存储目标序列
	Duel.Hint(HINT_ZONE,tp,s) -- 高亮所选区域
end

-- 效果②操作
function s.disop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=e:GetLabel()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsControler(1-tp) or c:GetSequence()>4 then return end
	-- 移动
	if Duel.CheckLocation(tp,LOCATION_MZONE,seq) then
		Duel.MoveSequence(c,seq)
	else
		return
	end

	-- 选择对方场上1只表侧怪兽无效
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end

-- 效果③目标：无特定目标，直接设置操作信息
function s.destg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	-- 无需设置操作信息
end

-- 效果③操作
function s.desop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end

	-- 立即破坏当前同列对方卡
	local col=c:GetColumnGroup()
	local g=col:Filter(Card.IsControler,nil,1-tp)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end

	-- 注册持续效果，在每次 ADJUST 时点检查并破坏同列对方卡
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(s.descon3)
	e1:SetOperation(s.desop3_cont)
	c:RegisterEffect(e1)
end

-- 持续效果条件：此卡表侧表示且在怪兽区
function s.descon3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c and c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end

-- 持续效果操作：破坏同列对方卡
function s.desop3_cont(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c then return end
	local col=c:GetColumnGroup()
	local g=col:Filter(Card.IsControler,nil,1-tp)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end