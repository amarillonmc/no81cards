--剧院魅影
function c13131401.initial_effect(c)
	  -- 连接召唤：包含通常怪兽和效果怪兽的怪兽2只
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),2,2,c13131401.matcheck)
	c:EnableReviveLimit()

	-- ①效果：自己·对方的主要阶段支付800基本分才能发动。进行1只二重怪兽的召唤。
	-- 自己主要阶段（起动效果）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13131401,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c13131401.sumcon1)
	e1:SetCost(c13131401.sumcost)
	e1:SetTarget(c13131401.sumtg)
	e1:SetOperation(c13131401.sumop)
	c:RegisterEffect(e1)
	-- 对方主要阶段（诱发即时效果）
	local e1a=e1:Clone()
	e1a:SetType(EFFECT_TYPE_TRIGGER_O)
	e1a:SetCode(EVENT_FREE_CHAIN)
	e1a:SetHintTiming(TIMING_MAIN_END)
	e1a:SetCondition(c13131401.sumcon2)
	c:RegisterEffect(e1a)

	-- ②效果：以自己墓地的1只通常怪兽为对象才能发动。那只怪兽回到手卡。那之后，可以把持有和那只怪兽相同种族·属性·等级的1只效果怪兽从手卡特殊召唤。这个回合，这张卡不能作为连接素材。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13131401,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,13131401)
	e2:SetTarget(c13131401.sptg)
	e2:SetOperation(c13131401.spop)
	c:RegisterEffect(e2)
end

-- 连接素材检查：必须包含1只通常怪兽和1只效果怪兽
function c13131401.matcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsType,1,nil,TYPE_NORMAL)
		and g:IsExists(Card.IsType,1,nil,TYPE_EFFECT)
		and #g==2
end

-- ①效果：自己主要阶段发动条件
function c13131401.sumcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() and Duel.GetTurnPlayer()==tp
end

-- ①效果：对方主要阶段发动条件
function c13131401.sumcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() and Duel.GetTurnPlayer()~=tp
end

-- ①效果：支付800基本分作为COST
function c13131401.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end

-- ①效果：发动目标（手卡有二重怪兽且有怪兽区空位）
function c13131401.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_DUAL)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
end

-- ①效果：从手卡直接召唤1只二重怪兽
function c13131401.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_DUAL)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end

-- ②效果：回收墓地通常怪兽的筛选条件
function c13131401.thfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
end

-- ②效果：特殊召唤效果怪兽的筛选条件
function c13131401.spfilter(c,e,tp,race,attr,lvl)
	return c:IsType(TYPE_EFFECT) and c:IsRace(race) and c:IsAttribute(attr) and c:IsLevel(lvl)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- ②效果：发动目标（选择墓地的1只通常怪兽）
function c13131401.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c13131401.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13131401.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c13131401.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

-- ②效果：回收后特殊召唤同种族·属性·等级的效果怪兽，并附加限制
function c13131401.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		local race=tc:GetRace()
		local attr=tc:GetAttribute()
		local lvl=tc:GetLevel()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c13131401.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,race,attr,lvl)
			and Duel.SelectYesNo(tp,aux.Stringid(13131401,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c13131401.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,race,attr,lvl)
			if #g>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	-- 这个回合，这张卡不能作为连接素材
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

-- 效果文本（Stringid）
function c13131401.stringid(id)
	if id==0 then
		return "①：自己·对方的主要阶段支付800基本分才能发动。进行1只二重怪兽的召唤。"
	elseif id==1 then
		return "②：以自己墓地的1只通常怪兽为对象才能发动。那只怪兽回到手卡。那之后，可以把持有和那只怪兽相同种族·属性·等级的1只效果怪兽从手卡特殊召唤。这个回合，这张卡不能作为连接素材。"
	elseif id==2 then
		return "是否特殊召唤持有相同种族·属性·等级的效果怪兽？"
	end
end
