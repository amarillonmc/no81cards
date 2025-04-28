local m=40020026
local cm=_G["c"..m]
cm.named_with_Maelstrom=1
function cm.Maelstrom(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Maelstrom
end
--苍岚霸龙 荣光灾璇
function cm.initial_effect(c)

	--【灵摆效果】第7次以上攻击后，可解放灾璇怪兽特召自身（可追加效果）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.pcon)
	e1:SetCost(cm.pcost)
	e1:SetTarget(cm.ptg)
	e1:SetOperation(cm.pop)
	c:RegisterEffect(e1)

	--【怪兽效果①】从卡组发动1张「灾璇」永续魔/陷，然后本卡移入P区域
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m+100)
	e2:SetTarget(cm.mztg)
	e2:SetOperation(cm.mzop)
	c:RegisterEffect(e2)

	--【怪兽效果②】第4次以上攻击后，抽1并可破坏对方1卡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+200)
	e3:SetCondition(cm.drawcon)
	e3:SetTarget(cm.drawtg)
	e3:SetOperation(cm.drawop)
	c:RegisterEffect(e3)
end

-- 判断场上攻击次数 ≥7（灵摆效果触发）
function cm.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker() and Duel.GetBattledCount(tp)>=7
end

-- 解放1只「灾璇」怪兽作为代价
function cm.pcfilter(c)
	return cm.Maelstrom(c) and c:IsReleasable()
end
function cm.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.pcfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,cm.pcfilter,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.Release(g,REASON_COST)
end

-- 特召自身目标
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

-- 特召并根据是否解放的是「苍岚龙 灾璇」追加效果
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local rc=e:GetLabelObject()
		if rc and rc:IsCode(40010960) then
			-- 对方伤害减半
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			e1:SetValue(HALF_DAMAGE)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			-- 再次战斗阶段
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_EXTRA_BATTLE_PHASE)
			e2:SetTargetRange(1,0)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end

-- 怪兽效果①：从卡组发动「灾璇」永续魔/陷
function cm.mzfilter(c,tp)
	return cm.Maelstrom(c) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
		and c:IsType(TYPE_CONTINUOUS) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.mztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.mzfilter,tp,LOCATION_DECK,0,1,nil,tp)
			and Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	end
end
function cm.mzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.mzfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	local te=tc:GetActivateEffect()
	if te then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		te:UseCountLimit(tp,1,true)
		local tpe=tc:GetType()
		local co=te:GetCost()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
		if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
	end
	-- 把自身移到P区
	if c:IsRelateToEffect(e) and Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end

-- 怪兽效果②：第4次以上攻击后发动
function cm.drawcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattledCount(tp)>=4
end
function cm.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,1-tp,LOCATION_ONFIELD)
end
function cm.drawop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,1,nil)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
