-- 特诺奇的（场地魔法名称）
local s,id=GetID()

function s.initial_effect(c)
	-- 场地魔法发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	-- ①：起动效果，解放手卡本家，卡组·墓地特召
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- ②：结束阶段诱发，为超量怪兽补充素材
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) -- 取对象效果
	e2:SetCountLimit(1,id+10000) -- 这个卡名的②效果1回合只能使用1次
	e2:SetTarget(s.mttg)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
end

-- ==================== ①效果：解放场上与特召 ====================
function s.cfilter(c,e,tp)
	-- Cost需要解放自己场上1只「特诺奇」怪兽
	-- 核心预判：GetMZoneCount 确保把这张卡解放后，你场上有大于0的空位用来特召
	return c:IsSetCard(0x5328) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
		and Duel.GetMZoneCount(tp,c)>0 
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function s.spfilter(c,e,tp)
	-- 卡组/墓地特召的「特诺奇」怪兽
	return c:IsSetCard(0x5328) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 由于 Cost 阶段的 GetMZoneCount 已经确保了必定有空位，这里只需检查卡组/墓地有没有怪即可
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	-- 场地魔法的通则：如果在效果处理时离开了场上，效果不处理
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	-- 加入 NecroValleyFilter 兼容王家谷的判定
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

-- ==================== ②效果：结束阶段补充素材 ====================
function s.xyzfilter(c)
	-- 取对象的条件：自己场上的超量怪兽
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.mtfilter(c)
	-- 素材的要求：「特诺奇」卡（包含魔陷与怪兽）
	return c:IsSetCard(0x5328)
end
function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.mtfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	
	-- 确保作为对象的怪兽还在场上、表侧表示，且没有不受效果影响（如果不受效果影响是无法塞素材进去的）
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		-- 从卡组·墓地“选”（不取对象）1张
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.mtfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.Overlay(tc,g)
		end
	end
end