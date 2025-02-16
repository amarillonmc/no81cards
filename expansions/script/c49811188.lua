--湮闇帝 迪尔格
function c49811188.initial_effect(c)
	-- 上级召唤规则：可以将1只上级召唤的怪兽解放作上级召唤
		--summon with 1 tribute
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49811188,0))
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetCondition(c49811188.otcon)
	e4:SetOperation(c49811188.otop)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e5)
	-- 效果①：召唤·特殊召唤时除外墓地最多3张卡，并送墓
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49811188,1))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c49811188.rmtg)
	e1:SetOperation(c49811188.rmop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	-- 效果②：因对方从场上离开时，特殊召唤「暗帝」
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49811188,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c49811188.spcon)
	e3:SetTarget(c49811188.sptg)
	e3:SetOperation(c49811188.spop)
	c:RegisterEffect(e3)
end

function c49811188.otfilter(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c49811188.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c49811188.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c49811188.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c49811188.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end

function c49811188.darkfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER)
end
function c49811188.rmfilter(c)
	return c:IsAbleToRemove()
end
-- 效果①：目标设置
function c49811188.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,LOCATION_GRAVE)
	if Duel.IsExistingMatchingCard(c49811188.darkfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c49811188.rmfilter,tp,0,LOCATION_GRAVE,1,g) then
		e:SetLabel(1)
	end
end

-- 效果①：操作处理
function c49811188.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	sg=Duel.GetOperatedGroup()
	local d1=0
	local d2=0
	local tc=sg:GetFirst()
	while tc do
		if tc then
			if tc:IsPreviousControler(0) then d1=d1+1
			else d2=d2+1 end
		end
		tc=sg:GetNext()
	end
	if d1>0 then Duel.DiscardDeck(0,d1,REASON_EFFECT) end
	if d2>0 then Duel.DiscardDeck(1,d2,REASON_EFFECT) end
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(c49811188.rmfilter,tp,0,LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(49811188,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rtc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,3,nil)
		Duel.Remove(rtc,POS_FACEUP,REASON_EFFECT)
	end
end

-- 效果②：特殊召唤的条件
function c49811188.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end

-- 效果②：特殊召唤的目标设置
function c49811188.spfilter(c,e,tp)
	return c:IsCode(85718645) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c49811188.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c49811188.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end

-- 效果②：特殊召唤的操作
function c49811188.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811188.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
