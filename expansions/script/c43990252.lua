--蕾祸之大狱魔虫
function c43990252.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,99,c43990252.lcheck)
	c:EnableReviveLimit()
	--
	--return & destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	--e1:SetCountLimit(1,id) --若该卡另有"1回合1次"，取消本行注释即可
	e1:SetCondition(c43990252.linkcon)
	e1:SetTarget(c43990252.rttg)
	e1:SetOperation(c43990252.rtop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,43990252)
	e2:SetCondition(c43990252.discon)
	e2:SetTarget(c43990252.distg)
	e2:SetOperation(c43990252.disop)
	c:RegisterEffect(e2)
	
	-- 效果：墓地发动，回场特召
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCountLimit(1,43990252)
	e3:SetTarget(c43990252.target)
	e3:SetOperation(c43990252.operation)
	c:RegisterEffect(e3)
end

--召唤手续
function c43990252.lcheck(g)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_INSECT+RACE_PLANT+RACE_REPTILE)
end

function c43990252.linkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
--可被送去（洗回）卡组的「蕾祸」怪兽；字段 蕾祸=0x1ab
function c43990252.rtfilter(c)
	return c:IsSetCard(0x1ab) and c:IsAbleToDeck()
end
function c43990252.rttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE)
		and aux.NecroValleyFilter(c43990252.rtfilter)(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NecroValleyFilter(c43990252.rtfilter),
		tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(c43990252.rtfilter),tp,LOCATION_GRAVE,0,1,6,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c43990252.rtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g=g:Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if not ct then ct=g:GetCount() end
	if ct<=0 then return end
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
		if #dg>0 then
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end

--无效并破坏
function c43990252.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end

function c43990252.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c43990252.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end


function c43990252.tdfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_INSECT+RACE_PLANT+RACE_REPTILE) and Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToDeck()
end

-- 对象函数：检查场上是否有符合条件的2只怪兽
function c43990252.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c43990252.tdfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c43990252.tdfilter,tp,LOCATION_MZONE,0,2,nil,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c43990252.tdfilter,tp,LOCATION_MZONE,0,2,2,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

-- 操作函数：执行效果
function c43990252.operation(e,tp,eg,ep,ev,re,r,rp)
	 local c = e:GetHandler()
		-- 获取所有目标
		local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
		-- 过滤掉已失去联系的目标
		local fg = g:Filter(Card.IsRelateToEffect, nil, e)
		 -- 必须确保仍有2只对象才处理
		if #fg < 2 then return end
		-- 将所有对象送回卡组最下面
		if Duel.SendtoDeck(fg, nil, SEQ_DECKBOTTOM, REASON_EFFECT) ~= 0
			and fg:FilterCount(Card.IsLocation, nil, LOCATION_DECK+LOCATION_EXTRA) == #fg
			and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 
			and c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
		end
		
		-- 自肃
		local e1 = Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c43990252.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1, tp)
end

function c43990252.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_INSECT+RACE_PLANT+RACE_REPTILE)
end