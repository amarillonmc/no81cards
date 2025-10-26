--究极璀璨原钻神
function c11607018.initial_effect(c)
	--fusion procedure
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,11607001,1,1,11607003,11607005,11607007,11607009,11607011,11607013)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(1)
	e1:SetCondition(c11607018.spcon)
	e1:SetOperation(c11607018.spop)
	c:RegisterEffect(e1)
    -- 回收对方
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(11607018,0))
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,11607018)
    e2:SetTarget(c11607018.rttg)
    e2:SetOperation(c11607018.rtop)
    c:RegisterEffect(e2)
    -- 二速炸卡
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(11607018,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,11607019)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e3:SetTarget(c11607018.coldestg)
    e3:SetOperation(c11607018.coldesop)
    c:RegisterEffect(e3)
    -- 遗言炸卡
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(11607018,2))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,11607020)
    e4:SetCondition(c11607018.dkcon)
    e4:SetTarget(c11607018.dkdestg)
    e4:SetOperation(c11607018.dkdesop)
    c:RegisterEffect(e4)
end
--special summon rule functions
function c11607018.spfilter1(c,fc,tp)
	return c:IsCode(11607001) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToDeckOrExtraAsCost()
end
function c11607018.spfilter2(c,fc,tp)
	return c:IsCode(11607003) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToDeckOrExtraAsCost()
end
function c11607018.spfilter3(c,fc,tp)
	return c:IsCode(11607005) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToDeckOrExtraAsCost()
end
function c11607018.spfilter4(c,fc,tp)
	return c:IsCode(11607007) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToDeckOrExtraAsCost()
end
function c11607018.spfilter5(c,fc,tp)
	return c:IsCode(11607009) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToDeckOrExtraAsCost()
end
function c11607018.spfilter6(c,fc,tp)
	return c:IsCode(11607011) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToDeckOrExtraAsCost()
end
function c11607018.spfilter7(c,fc,tp)
	return c:IsCode(11607013) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToDeckOrExtraAsCost()
end
function c11607018.spfilter_all(c,fc,tp)
	return c:IsCode(11607001,11607003,11607005,11607007,11607009,11607011,11607013) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToDeckOrExtraAsCost()
end
function c11607018.fselect(g)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c11607018.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local loc=LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c11607018.spfilter1),tp,loc,0,1,nil,c,tp)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c11607018.spfilter2),tp,loc,0,1,nil,c,tp)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c11607018.spfilter3),tp,loc,0,1,nil,c,tp)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c11607018.spfilter4),tp,loc,0,1,nil,c,tp)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c11607018.spfilter5),tp,loc,0,1,nil,c,tp)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c11607018.spfilter6),tp,loc,0,1,nil,c,tp)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c11607018.spfilter7),tp,loc,0,1,nil,c,tp)
end
function c11607018.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local loc=LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c11607018.spfilter_all),tp,loc,0,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local mg=g:SelectSubGroup(tp,c11607018.fselect,false,7,7)
	if mg and mg:GetCount()==7 then
		c:SetMaterial(mg)
		Duel.SendtoDeck(mg,tp,2,REASON_COST)
	end
end
-- 1
function c11607018.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c11607018.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	local n=g:GetCount()
	if n>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(1-tp)
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(n*300)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end
-- 2
function c11607018.coldestg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c11607018.colfilt,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(c11607018.colfilt,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c11607018.colfilt(c)
	return c:IsSetCard(0x6225)
end
function c11607018.enemyfil(c,tp)
	return c:IsControler(tp)
end
function c11607018.fieldfil(c)
	return c:IsOnField()
end
function c11607018.coldesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c11607018.colfilt,tp,LOCATION_ONFIELD,0,1,99,nil)
	if g:GetCount()==0 then return end
	local d=g:Clone()
	for tc in aux.Next(g) do
		local cg=tc:GetColumnGroup()
		d:Merge(cg:Filter(c11607018.enemyfil,nil,1-tp))
	end
	d=d:Filter(c11607018.fieldfil,nil)
	d:KeepAlive()
	Duel.Destroy(d,REASON_EFFECT)
end
-- 3
function c11607018.dkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsPreviousPosition(POS_FACEUP)
end
function c11607018.dkdestg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,5,tp,LOCATION_DECK)
end
function c11607018.dkdesop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,5)
	Duel.Destroy(g,REASON_EFFECT)
end
