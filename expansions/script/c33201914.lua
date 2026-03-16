local s,id=GetID()

function s.initial_effect(c)
	-- 永续魔法发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	-- ①：送去1张手卡，从卡组检索1只本家怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	-- ②：怪兽特召成功时，以自己场上1只本家为对象，高2阶的本家超量升阶特召
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) -- 场合型诱发，不取对象（等效于实卡中不卡时点）
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+10000) -- 这个卡名的②效果1回合只能使用1次
	e2:SetTarget(s.xyztg)
	e2:SetOperation(s.xyzop)
	c:RegisterEffect(e2)
end

-- ==================== ①效果：送手卡检索 ====================
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.thfilter(c)
	-- 检索卡组的「特诺奇」怪兽
	return c:IsSetCard(0x5328) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- ==================== ②效果：升阶超量召唤 ====================
function s.exfilter(c,e,tp,mc,rank)
	-- 额外卡组寻找：超量怪兽，本家字段，阶级等于指定的阶级，能用mc作为素材，且符合召唤条件
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x5328) and c:GetRank()==rank
		and mc:IsCanBeXyzMaterial(c,tp)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.tgfilter(c,e,tp)
	-- 取对象的合法性检查
	if not (c:IsFaceup() and c:IsSetCard(0x5328)) then return false end
	
	local rank=0
	-- 判断它是拥有等级还是拥有阶级
	if c:IsLevelAbove(0) then 
		rank=c:GetLevel()+2
	elseif c:IsType(TYPE_XYZ) then 
		rank=c:GetRank()+2
	else 
		return false -- 如果是Link这种既没等级也没阶级的怪兽，直接不合法
	end
	
	-- 必须满足官方超量规则的检查，且存在对应的额外卡组怪兽
	return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rank)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	
	-- 进行效果处理时的二次核验（防止连锁中途怪兽状态发生改变）
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp) and not tc:IsImmuneToEffect(e) then
		
		-- 再次计算目标所需的阶级
		local rank=0
		if tc:IsLevelAbove(0) then rank=tc:GetLevel()+2
		elseif tc:IsType(TYPE_XYZ) then rank=tc:GetRank()+2 end
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,rank)
		local sc=g:GetFirst()
		if sc then
			-- 官方标准升阶魔法结算流程
			local mg=tc:GetOverlayGroup()
			if #mg>0 then
				Duel.Overlay(sc,mg) -- 原有的素材转移给新超量怪兽
			end
			sc:SetMaterial(Group.FromCards(tc)) -- 设置该怪兽被使用的素材
			Duel.Overlay(sc,Group.FromCards(tc)) -- 将作为对象的怪兽重叠进新怪兽底下
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) -- 执行当作超量召唤的特召
			sc:CompleteProcedure() -- 宣告正规召唤完成（能被苏生）
		end
	end
end