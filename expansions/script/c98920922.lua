--金傲大奖赛-利昂战车号
--金傲大奖赛 超量怪兽 (请将文件名和脚本中的 12345678 替换为实际卡号)
local s,id=GetID()
function s.initial_effect(c)
	--超量召唤条件：属性不同的3星怪兽×2
	aux.AddXyzProcedure(c,nil,3,2,nil,nil,99,nil,false,s.xyzcheck)
	c:EnableReviveLimit()
	
	--①：特殊召唤的场合才能发动。把自己墓地的1张「金傲大奖赛」卡作为超量素材。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.mttg)
	e1:SetOperation(s.mtop)
	c:RegisterEffect(e1)
	
	--②：取除1个超量素材，破坏对方场上攻击力<=LP差的怪兽。LP少的场合可以抽1张。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	
	--③：②的效果发动的回合的结束阶段，回到额外卡组并特殊召唤特定怪兽。
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end

-- 超量素材：属性不同
function s.xyzcheck(g,tp,xyz)
	return g:GetClassCount(Card.GetAttribute)==#g
end

-- ①效果
function s.mtfilter(c)
	return c:IsSetCard(0x192)
end
function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.mtfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,s.mtfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.Overlay(c,g)
	end
end

-- ②效果
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.desfilter(c,diff)
	return c:IsFaceup() and c:GetAttack()<=diff
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local diff=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,nil,diff) end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,diff)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	-- 给卡片注册 Flag，用于③效果的触发判断
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local diff=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,diff)
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		if Duel.GetLP(tp)<Duel.GetLP(1-tp) and Duel.IsPlayerCanDraw(tp,1) 
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then -- 提示是否抽卡（需要在string配置对应提示文本）
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

-- ③效果
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.spfilter(c,e,tp)
	return c:IsCode(23512906,96305350) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end -- 必发效果
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and c:IsLocation(LOCATION_EXTRA) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end