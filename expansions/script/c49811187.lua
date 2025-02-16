--闪光帝 克赖斯
function c49811187.initial_effect(c)
	-- 上级召唤规则：可以将1只上级召唤的怪兽解放作上级召唤
	--summon with 1 tribute
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49811187,0))
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetCondition(c49811187.otcon)
	e4:SetOperation(c49811187.otop)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e5)

	-- 效果①：召唤·特殊召唤时破坏场上最多3张卡，并抽卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49811187,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c49811187.destg)
	e1:SetOperation(c49811187.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	-- 效果②：因对方从场上离开时，特殊召唤「光帝 克赖斯」
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49811187,4))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c49811187.spcon)
	e3:SetTarget(c49811187.sptg)
	e3:SetOperation(c49811187.spop)
	c:RegisterEffect(e3)
end

function c49811187.otfilter(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c49811187.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c49811187.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c49811187.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c49811187.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end

function c49811187.drawfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER)
end
-- 效果①：目标设置
function c49811187.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if Duel.IsExistingMatchingCard(c49811187.drawfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_HANDES)
		e:SetLabel(1)
	end
end

-- 效果①：操作处理
function c49811187.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
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
	if d1>0 and Duel.IsPlayerCanDraw(0,d1) and Duel.SelectYesNo(0,aux.Stringid(49811187,2)) then Duel.Draw(0,d1,REASON_EFFECT) end
	if d2>0 and Duel.IsPlayerCanDraw(1,d2) and Duel.SelectYesNo(1,aux.Stringid(49811187,2)) then Duel.Draw(1,d2,REASON_EFFECT) end
	if e:GetLabel()==1 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(tp,aux.Stringid(49811187,3)) then
		Duel.BreakEffect()
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	end
end

-- 效果②：特殊召唤的条件
function c49811187.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end

-- 效果②：特殊召唤的目标设置
function c49811187.spfilter(c,e,tp)
	return c:IsCode(57666212) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c49811187.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c49811187.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end

-- 效果②：特殊召唤的操作
function c49811187.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811187.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
