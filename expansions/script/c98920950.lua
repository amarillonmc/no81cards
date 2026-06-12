-- 极神圣帝王 奥丁
local s,id=GetID()
function s.initial_effect(c)
	-- 同调召唤条件：「极星」调整 ＋ 调整以外的同调怪兽1只以上
	aux.AddSynchroProcedure(c, aux.FilterBoolFunction(Card.IsSetCard, 0x42), aux.NonTuner(Card.IsSynchroType, TYPE_SYNCHRO), 1)
	c:EnableReviveLimit()

	-- 同调召唤成功时，检测并记录素材中是否存在「极神」怪兽
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(s.regcon)
	e0:SetOperation(s.regop)
	c:RegisterEffect(e0)

	-- ①：只要以「极神」为素材同调召唤的这张卡在场，自己场上的「极神」怪兽属性变神，且不受神属性以外的怪兽效果影响
	-- 属性变神
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(s.effcon)
	e1:SetTarget(s.attrtg)
	e1:SetValue(ATTRIBUTE_DIVINE)
	c:RegisterEffect(e1)
	
	-- 不受神属性以外的怪兽效果影响
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.effcon)
	e2:SetTarget(s.immtg)
	e2:SetValue(s.immval)
	c:RegisterEffect(e2)

	-- ②：1回合1次，回收墓地·除外最多3张「极星」回卡组，检索同等数量的「极星」怪兽（同种族最多1只）
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)

	-- ③：被破坏的场合，从额外卡组·墓地把1只10星「极神」怪兽当作同调召唤特殊召唤
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end

-- 同调素材过滤器
function s.tfilter(c,val,scard,sumtype,tp)
	return c:IsSetCard(0x42) and c:IsType(TYPE_TUNER)
end
function s.ntfilter(c,val,scard,sumtype,tp)
	return c:IsType(TYPE_SYNCHRO)
end

-- 素材记录与判定
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if g and g:IsExists(Card.IsSetCard,1,nil,0x4b) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end

-- 效果①条件与实现
function s.effcon(e)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.attrtg(e,c)
	return c:IsSetCard(0x4b) and c:IsType(TYPE_MONSTER)
end
function s.immtg(e,c)
	return c:IsSetCard(0x4b) and c:IsType(TYPE_MONSTER)
end
function s.immval(e,te)
	if not te:IsActiveType(TYPE_MONSTER) then return false end
	local tc=te:GetHandler()
	return tc and not tc:IsAttribute(ATTRIBUTE_DIVINE)
end

-- 效果②相关逻辑
function s.tdfilter(c)
	return c:IsSetCard(0x42) and c:IsAbleToDeck()
end
function s.thfilter(c)
	return c:IsSetCard(0x42) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.tdfilter(chkc) end
	if chk then return Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,#g,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg==0 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==0 then return end
	
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=ct and ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		Duel.SendtoHand(g:SelectSubGroup(tp,s.fselect,false,ct,ct),tp,REASON_EFFECT)
	end
end
function s.fselect(g)
	return g:GetClassCount(Card.GetRace)==g:GetCount()
end

-- 效果③相关逻辑
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function s.spfilter(c,e,tp)
	if not (c:IsSetCard(0x4b) and c:IsLevel(10) and c:IsType(TYPE_MONSTER)) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
			tc:CompleteProcedure() -- 确立正规同调召唤的苏生限制解除
		end
	end
end