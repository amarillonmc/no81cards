-- 奥夜花·释藤
--Duel.LoadScript("c.lua")
-- 奥夜花·释藤
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 添加奥夜花系列的卡名记述，方便其他卡识别
	aux.AddCodeList(c,60012030)
	-- 注册进化指示物的许可
	c:EnableCounterPermit(0x624)
	
	-- ①：自己怪兽被对方效果离开/战斗破坏，特殊召唤自己，1回合1次
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.act1_con)
	e1:SetTarget(cm.act1_target)
	e1:SetOperation(cm.act1_activate)
	c:RegisterEffect(e1)
	local e1_2=e1:Clone()
	e1_2:SetCode(EVENT_BATTLE_DESTROYED)
	c:RegisterEffect(e1_2)
	
	-- ②：对方特殊召唤无等级怪兽，放置进化指示物，攻击力变0
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.act2_con)
	e2:SetOperation(cm.act2_activate)
	c:RegisterEffect(e2)
	
	-- ③的子效果1：1个以上指示物，丢弃手卡的效果，只在这张卡在场期间1次，加NO_TURN_RESET
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCondition(cm.act3_con1)
	e3:SetTarget(cm.act3_target)
	e3:SetOperation(cm.act3_activate)
	c:RegisterEffect(e3)
	
	-- ③的子效果2：3个以上指示物，手卡公开
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PUBLIC)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.act3_con2)
	e4:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e4)
	
	-- ③的子效果3：3个以上指示物，对应等级的怪兽不受对方效果影响
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.act3_con2)
	e5:SetTarget(cm.immune_tg)
	e5:SetValue(cm.immune_val)
	c:RegisterEffect(e5)
end

-- ①的触发条件：自己的怪兽被对方效果离开，或者被战斗破坏
function cm.act1_con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(function(tc)
		return tc:IsPreviousControler(tp) and tc:IsPreviousLocation(LOCATION_MZONE)
			and ((re and rp==1-tp) or (r==REASON_BATTLE))
	end,1,nil)
end

-- ①的目标函数
function cm.act1_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

-- ①的效果执行
function cm.act1_activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	-- 特殊召唤自己
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	-- 回卡组抽卡的效果，适用2次
	for i=1,2 do
		if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) then
			if Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,99,nil)
				if #g>0 then
					local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
					if ct>0 then
						Duel.Draw(tp,ct,REASON_EFFECT)
					end
				end
			else
				break
			end
		else
			break
		end
	end
end

-- ②的触发条件：对方特殊召唤了没有等级的怪兽
function cm.act2_con(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(function(tc)
		return tc:IsControler(1-tp) and tc:IsType(TYPE_MONSTER) and tc:GetLevel()==0
	end,1,nil)
end

-- ②的效果执行
function cm.act2_activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:Filter(function(tc)
		return tc:IsControler(1-tp) and tc:IsType(TYPE_MONSTER) and tc:GetLevel()==0
	end,nil):GetFirst()
	if not tc then return end
	-- 放置1个进化指示物
	if c:IsCanHaveCounter(0x624) then
		c:AddCounter(0x624,1)
		Duel.RegisterFlagEffect(tp,60002148,0,0,1)
	end
	-- 那只怪兽的攻击力变为0
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end

-- 1个以上进化指示物的条件
function cm.act3_con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:GetCounter(0x624)>=1
end

-- ③的目标函数
function cm.act3_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) end
end

-- ③的效果执行
function cm.act3_activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_DISCARD+REASON_EFFECT)
	end
end

-- 3个以上进化指示物的条件
function cm.act3_con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:GetCounter(0x624)>=3
end

-- 免疫效果的目标：手卡中有相同等级的怪兽时，自己场上的该等级怪兽
function cm.immune_tg(e,c)
	local tp=e:GetHandlerPlayer()
	local lv=c:GetLevel()
	return Duel.IsExistingMatchingCard(function(tc)
		return tc:IsType(TYPE_MONSTER) and tc:GetLevel()==lv
	end,tp,LOCATION_HAND,0,nil)
end

-- 免疫效果的判断：不受对方发动的效果影响
function cm.immune_val(e,te)
	return te:GetHandlerPlayer()==1-e:GetHandlerPlayer()
end
