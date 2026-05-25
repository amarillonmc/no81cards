--倒悬之树 值得托付的信任
local m=43499005
local cm=_G["c"..m]

function cm.initial_effect(c)
	--超量召唤手续
	aux.AddXyzProcedure(c,nil,10,2)
	c:EnableReviveLimit()
	
	--①：战斗阶段开始时发动，平分攻击力
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	
	--②：作3次攻击，下次抽卡阶段变更为抽满6张
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	--决斗中只能使用1次
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL) 
	e2:SetTarget(cm.multitg)
	e2:SetOperation(cm.multiop)
	c:RegisterEffect(e2)
end

--①效果的发动判断（场上有表侧表示怪兽即可）
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end

--①效果的处理：平分场上所有怪兽的攻击力
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=g:GetCount()
	if ct==0 then return end
	
	--累加全场表侧怪兽的攻击力
	local sum=0
	local tc=g:GetFirst()
	while tc do
		sum=sum+tc:GetAttack()
		tc=g:GetNext()
	end
	
	--计算商（lua中math.floor用于向下取整）
	local avg=math.floor(sum/ct)
	
	--改变全部表侧表示怪兽的攻击力
	tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(avg)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end

--②效果的选择对象
function cm.multitg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end

--②效果的处理
function cm.multiop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		--可以作3次攻击（原本的1次 + 额外的2次）
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	
	--注册代替通常抽卡的隐密效果
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetCondition(cm.drcon)
	e2:SetOperation(cm.drop)
	Duel.RegisterEffect(e2,tp)
end

--代替抽卡触发判断：必须是到了自己的抽卡阶段，且准备执行通常抽卡
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetDrawCount(tp)>0
end

--代替抽卡处理
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	--给玩家施加禁止本次通常抽卡的规则效果
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	e1:SetValue(0)
	Duel.RegisterEffect(e1,tp)
	
	--检测手卡数量并抽到6张
	local hct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if hct<6 then
		Duel.Draw(tp,6-hct,REASON_EFFECT)
	end
	
	--触发应用1次后，自动注销该延迟效果
	e:Reset()
end