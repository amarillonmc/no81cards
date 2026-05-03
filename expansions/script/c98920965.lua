--文具电子人准备
-- 此卡名替换为实际注册的中文名称
local m=98920965
local cm=_G["c"..m]
function cm.initial_effect(c)
	-- 发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end

-- 过滤出「文具电子人」怪兽（0xab），且满足可以特召 或 可以放置在灵摆区域
function cm.filter(c,e,tp,ft,ft_p)
	if not (c:IsSetCard(0xab) and c:IsType(TYPE_MONSTER)) then return false end
	local b1 = ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2 = c:IsType(TYPE_PENDULUM) and ft_p
	return b1 or b2
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft_p=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,ft,ft_p)
		-- 至少包含1只灵摆怪兽，且总数至少为2只
		return g:FilterCount(Card.IsType,nil,TYPE_PENDULUM)>=1 and g:GetCount()>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft_p=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,ft,ft_p)
	
	local pg=g:Filter(Card.IsType,nil,TYPE_PENDULUM)
	if pg:GetCount()<1 or g:GetCount()<2 then return end
	
	-- 第一步：必须选1张灵摆怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg1=pg:Select(tp,1,1,nil)
	g:RemoveCard(sg1:GetFirst())
	
	-- 第二步：再选1张符合条件的怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg2=g:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	
	-- 给对方观看这2只怪兽
	Duel.ConfirmCards(1-tp,sg1)
	
	-- 对方随机选1只
	local tg=sg1:RandomSelect(1-tp,1)
	local tc=tg:GetFirst()
	
	-- 获取剩下的那只怪兽
	local oc_tc=sg1:GetFirst()
	if oc_tc==tc then oc_tc=sg1:GetNext() end
	
	-- 重新判定该怪兽当前是否能特召或放置到灵摆区（防连锁卡格子）
	local b1 = Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2 = tc:IsType(TYPE_PENDULUM) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	
	if b1 or b2 then
		local op=0
		if b1 and b2 then
			-- 1160: 放置在灵摆区域 / 115: 特殊召唤
			op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
		elseif b1 then
			op=1
		else
			op=0
		end
		
		if op==0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		-- 若因格子被连锁占满等情况导致都不能执行，送去墓地处理
		Duel.SendtoGrave(tc,REASON_RULE)
	end
	
	-- 剩下的怪兽加入手卡
	if oc_tc and oc_tc:IsLocation(LOCATION_DECK+LOCATION_GRAVE) then
		Duel.SendtoHand(oc_tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,oc_tc)
	end
end
