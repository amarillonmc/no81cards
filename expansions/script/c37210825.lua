local s,id=GetID()
function s.initial_effect(c)
	-- 超量召唤规则：4阶以上的水属性超量怪兽×2
	c:EnableReviveLimit()
	-- 采用你指定/熟悉的 LevelFree 接口
	aux.AddXyzProcedureLevelFree(c,s.matfilter,nil,2,2)
	
	-- 【手卡丢弃+墓地除外特召规则】
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,2))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.altxyzcon)
	e0:SetOperation(s.altxyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	
	-- ①：场上1张卡返回手卡，或作为素材（诱发即时效果）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	-- ②：因对方离场时特召并叠放（诱发效果）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

-- ==============================================
-- 基础超量素材检测 (4阶以上水属性超量)
-- ==============================================
function s.matfilter(c,xyzc)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_XYZ) and c:GetRank()>=4
end

-- ==============================================
-- 不依赖 SelectUnselectGroup 的特殊超量处理
-- ==============================================
-- 检测可选素材
function s.altmatfilter(c,sc)	
	if c==sc then return false end
	if not (c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_XYZ) and c:GetRank()>=4 and c:IsCanBeXyzMaterial(sc)) then return false end
	return c:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup())
end

-- 确保两张素材有空位
function s.chk2(c,tp,sc,mc1)
	local g=Group.FromCards(c,mc1)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end

-- 确保第一张选出的必然是墓地或除外区的卡，且能找到第二张凑齐
function s.chk1(c,mg,tp,sc)
	if not c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then return false end
	return mg:IsExists(s.chk2,1,c,tp,sc,c)
end

function s.altxyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	-- 卡名1回合1次检测 (用 id+1 错开 ①效果的限制)
	if Duel.GetFlagEffect(tp,id+1)>0 then return false end
	if not Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) then return false end
	
	local mg=Duel.GetMatchingGroup(s.altmatfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,c,c)
	-- 能否找到满足条件的组合（必然包含至少1只墓地/除外）
	return mg:IsExists(s.chk1,1,nil,mg,tp,c)
end

function s.altxyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(s.altmatfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,c,c)
	
	-- 手动选卡逻辑：先选1只必须在墓地/除外区的
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=mg:FilterSelect(tp,s.chk1,1,1,nil,mg,tp,c)
	local tc1=g1:GetFirst()
	
	-- 再选第2只（只要满足格子条件即可，场上/墓地/除外皆可）
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=mg:FilterSelect(tp,s.chk2,1,1,tc1,tp,c,tc1)
	g1:Merge(g2)
	
	-- 丢弃1张手卡作为代价
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
	
	-- 【修复Bug 2】如果被作为素材的卡片上有超量素材，必须先将它们送入墓地，防止卡入虚空
	for tc in aux.Next(g1) do
		local og=tc:GetOverlayGroup()
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
	end
	
	-- 变为素材并超量召唤
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
	Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
end

-- ==============================================
-- ①：弹回手卡 / 代替变为素材
-- ==============================================
-- ==============================================
-- ①：弹回手卡 / 代替变为素材
-- ==============================================
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc~=c end
	-- 将自身 c 传入豁免参数，防止取自己为对象
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function s.extrawaterfilter(c,sc)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsSummonLocation(LOCATION_EXTRA) and c~=sc
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	
	-- 判断是否符合代替吸收为素材的条件
	local can_attach = c:IsRelateToEffect(e) and c:IsType(TYPE_XYZ) and not tc:IsType(TYPE_TOKEN)
		and Duel.IsExistingMatchingCard(s.extrawaterfilter,tp,LOCATION_MZONE,0,1,nil,c)
		
	-- 询问是否吸素材（如果不能回手，直接吸；如果能回手且符合条件，弹窗询问）
	if can_attach and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(id,3))) then
		-- 【修复Bug 2】同理，这里吸收场上目标作为素材时，如果目标是超量怪兽且带有素材，也需要处理
		local og=tc:GetOverlayGroup()
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,tc)
	elseif tc:IsAbleToHand() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

-- ==============================================
-- ②：离场特召墓地/除外怪兽并叠放
-- ==============================================
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end

function s.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_WATER) and c:GetRank()<=8
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local c=e:GetHandler()
		-- 叠放处理，要求离场后的这张卡当前并未进入额外卡组
		if c:IsRelateToEffect(e) and not c:IsLocation(LOCATION_EXTRA) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			-- 注意：由于 c 是刚刚离场的卡，按规则它之前的素材已经送墓了，所以这里无需再次处理 OverlayGroup
			Duel.Overlay(tc,c)
		end
	end
end