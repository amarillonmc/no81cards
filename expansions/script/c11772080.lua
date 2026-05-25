local s,id=GetID()
function s.initial_effect(c)
	-- 添加卡名记述
	aux.AddCodeList(c,11772070)
	
	-- ①：仪式召唤效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	-- ②：5星以上怪兽离场时回收（一回合一次）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- ==================== ① 效果相关（原生仪式处理） ====================
function s.mfilter(c)
	-- 祭品必须是5星以上的怪兽
	return c:IsLevelAbove(5) and c:IsCanBeRitualMaterial(nil)
end
function s.codefilter(c)
	return c:IsFaceup() and c:IsCode(11772070)
end
function s.ritfilter(c,e,tp,m,ft)
	-- 必须是5星以上的仪式怪兽
	if not ((c:IsType(TYPE_MONSTER)and c:IsType(TYPE_RITUAL)) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)) then return false end
	
	-- 限制条件：自己场上没有「11772070」存在的场合，不能仪式召唤「11772070」以外的怪兽
	if not Duel.IsExistingMatchingCard(s.codefilter,tp,LOCATION_ONFIELD,0,1,nil) and not c:IsCode(11772070) then return false end
	
	-- 复制一份祭品组并移除将要出场的这张卡本身
	local mg=m:Clone()
	mg:RemoveCard(c)
	-- 检查剩余的卡是否能凑够等级
	return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 获取当前可以作为仪式祭品的候选卡组（仅限5星以上）
		local m=Duel.GetRitualMaterial(tp):Filter(s.mfilter,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		-- 如果怪兽区没有空位，则要求可用祭品中必须包含场上的怪兽（用来腾出格子）
		if ft<=0 and not m:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE) then return false end
		return Duel.IsExistingMatchingCard(s.ritfilter,tp,LOCATION_HAND,0,1,nil,e,tp,m,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp):Filter(s.mfilter,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	-- 选取符合条件的仪式怪兽
	local tg=Duel.SelectMatchingCard(tp,s.ritfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,m,ft)
	local tc=tg:GetFirst()
	if tc then
		m:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=nil
		-- 核心逻辑保护：如果在怪兽区域全满 (ft<=0) 的情况下，强迫玩家的祭品组合中必须包含场上的怪兽
		while true do
			mat=m:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
			if ft>0 or mat:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE) then
				break
			end
			-- 如果玩家在场上满格子时只选了手卡的怪兽，会导致死锁，通过循环让他们重新选择
		end
		-- 执行标准的仪式解放与特殊召唤流程
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

-- ==================== ② 效果相关 ====================
function s.thcfilter(c)
	-- 获取离场前在场上的等级，只要离场前有5星或以上就符合条件
	return c:GetPreviousLevelOnField()>=5
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	-- 事件组中有符合条件的卡，且这张卡自己不包含在事件组内
	return eg:IsExists(s.thcfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
