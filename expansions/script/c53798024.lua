--User's Custom Card
local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro Summon
	--调整＋调整以外的怪兽1只以上
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()

	--Effect 1
	--①：只在这张卡在场上表侧表示存在才有1次，双方的主要阶段...
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	--关键属性：NO_TURN_RESET表示如果不离场无法重置计数，配合CountLimit(1)实现"只要在场只有1次"
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--双方的主要阶段
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end

function s.filter(c)
	--效果怪兽
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--以这张卡以外的场上2～3只效果怪兽为对象
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,2,3,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--获取发动时作为对象的怪兽数量（参考：GetChainInfo获取的是发动时的目标列表）
	local g_all=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ct=g_all:GetCount()

	--这张卡在通常攻击外加上可以作出最多有这个效果的发动时作为对象的怪兽数量的攻击
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(ct)
		--只要这张卡在自己的怪兽区域存在（随卡片离场而重置）
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end

	--处理对象的无效和攻守减半
	local tg=g_all:Filter(Card.IsRelateToEffect,nil,e)
	for tc in aux.Next(tg) do
		--确保源卡(c)和目标(tc)都在场且表侧
		if tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and c:IsFaceup() then
			--建立关联：使c和tc产生联系，以便condition检查
			c:CreateRelation(tc,RESET_EVENT+RESETS_STANDARD)
			
			--Condition: 只要这张卡（e:GetOwner()）在自己的怪兽区域存在（且保持关联）
			local rcon=function(e)
				return e:GetOwner():IsRelateToCard(e:GetHandler()) and e:GetOwner():IsFaceup()
			end

			--无效效果
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetCondition(rcon)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e3)

			--攻击力减半
			local e4=e2:Clone()
			e4:SetCode(EFFECT_SET_ATTACK_FINAL)
			e4:SetValue(math.ceil(tc:GetAttack()/2))
			tc:RegisterEffect(e4)

			--守备力减半
			local e5=e2:Clone()
			e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e5:SetValue(math.ceil(tc:GetDefense()/2))
			tc:RegisterEffect(e5)
		end
	end
end