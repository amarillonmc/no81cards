--深葬于破碎世界之底的罪人
local s,id,o=GetID()
function s.initial_effect(c)
	--①：补充超量素材
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	--②：伤害计算时加攻
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.atkcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
	
	--手卡发动许可
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(s.handcon)
	c:RegisterEffect(e3)
end

-- === 手卡发动判断 ===
function s.handfilter(c)
	return c:IsSetCard(0x616) and c:IsType(TYPE_TRAP)
end

function s.handcon(e)
	-- 自己的场上·墓地的「破碎世界」陷阱卡的种类是4种以上
	local g=Duel.GetMatchingGroup(s.handfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=4
end

-- === 效果① ===
function s.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x616) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_XYZ)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end

function s.matfilter(c)
	-- 可作为素材的卡：非Token，场上/墓地/除外(需表侧)
	return not c:IsType(TYPE_TOKEN) and (c:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()))
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	
	-- 检查对象怪兽是否有通常怪兽作为素材
	local has_normal = tc:GetOverlayGroup():IsExists(Card.IsType, 1, nil, TYPE_NORMAL)
	
	-- 构建基础选择范围：自己的墓地·除外状态 + 双方场上
	-- 排除目标怪兽自身(tc)
	local g = Duel.GetMatchingGroup(s.matfilter, tp, LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD, LOCATION_ONFIELD, tc)
	
	-- 如果没有通常怪兽素材，只能选自己的卡
	if not has_normal then
		g = g:Filter(Card.IsControler, nil, tp)
	end
	
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local rg=g:Select(tp,1,1,nil)
		Duel.HintSelection(rg)
		local rc=rg:GetFirst()
		if not rc:IsImmuneToEffect(e) then
			local og=rc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			Duel.Overlay(tc,rg)
		end
	end
end

-- === 效果② ===
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if c:IsControler(1-tp) then c,bc=bc,c end
	-- c是自己怪兽，bc是对方怪兽
	e:SetLabelObject(bc)
	return c:IsFaceup() and c:IsSetCard(0x616) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_XYZ)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return end
	if c:IsControler(1-tp) then c,bc=bc,c end
	
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local atk=bc:GetAttack()
		if atk<0 then atk=0 end
		
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end