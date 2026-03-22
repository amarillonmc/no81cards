--斯图尔特的枭雄-龙骧
local s,id,o=GetID()
function s.initial_effect(c)
	--融合召唤
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,s.matfilter,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),true)
	
	--特殊召唤限制
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	
	--特殊召唤手续
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.sprcon)
	e1:SetTarget(s.sprtg)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)
	
	--①：选墓地·除外返回卡组并检索
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

	--③：对方效果发动时进行规则特召
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+1)
	e4:SetCondition(s.spcon2)
	e4:SetTarget(s.sptg2)
	e4:SetOperation(s.spop2)
	c:RegisterEffect(e4)

end

-- 融合素材
function s.matfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_DRAGON)
end

-- === 特殊召唤手续 (改写) ===
-- 先选出必须包含的通常龙族怪兽
function s.cfilter1(c,tp,fc)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_NORMAL) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,c,tp,c,fc)
end
-- 再验证另一只龙族怪兽，且两者至少有其一在场上
function s.cfilter2(c,tp,mc,fc)
	if not (c:IsRace(RACE_DRAGON) and c:IsAbleToRemoveAsCost()) then return false end
	-- 包含自己场上的卡
	if not (c:IsLocation(LOCATION_ONFIELD) or mc:IsLocation(LOCATION_ONFIELD)) then return false end
	local g=Group.FromCards(c,mc)
	return Duel.GetLocationCountFromEx(tp,tp,g,fc)>0
end

function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,tp,c)
end

function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,tp,c)
	if #g1==0 then return false end
	local mc=g1:GetFirst()
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,s.cfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,mc,tp,mc,c)
	g1:Merge(g2)
	g1:KeepAlive()
	e:SetLabelObject(g1)
	return true
end

function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	if sg then
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
		sg:DeleteGroup()
	end
end

-- === 效果① (改写) ===
function s.tdfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToDeck() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end

function s.thfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsDefense(0) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil):Filter(Card.IsCanBeEffectTarget,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,aux.dncheck,false,1,g:GetCount())
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,tg:GetCount(),0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if #tg==0 then return end
	if Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		-- 如果确实有卡回到了卡组/额外卡组
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
			local thg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
			if #thg>0 then 
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=thg:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				if Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
				Duel.BreakEffect()
				Duel.ShuffleHand(tp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
					local sg=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
					if sg:GetCount()>0 then
					Duel.Summon(tp,sg:GetFirst(),true,nil)
					end
				end
			end
		end
	end
end

-- === 效果② ===
function s.sumfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsLevelBelow(4) and c:IsSummonable(true,nil)
end

-- === 效果③ ===
local SUMMON_TYPES_TABLE = {0, SUMMON_TYPE_FUSION, SUMMON_TYPE_SYNCHRO, SUMMON_TYPE_XYZ, SUMMON_TYPE_LINK, SUMMON_TYPE_SPECIAL, SUMMON_VALUE_SELF}

function s.sprule_filter(c)
	if not c:IsRace(RACE_DRAGON) then return false end
	for _,sumtype in pairs(SUMMON_TYPES_TABLE) do
		if c:IsSpecialSummonable(sumtype) then return true end
	end
	return false
end

function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end

function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sprule_filter,tp,0xff,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end

function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.sprule_filter,tp,0xff,0,1,1,nil)
	local sc=g:GetFirst()
	if sc then
		for _,sumtype in pairs(SUMMON_TYPES_TABLE) do
			if sc:IsSpecialSummonable(sumtype) then
				Duel.SpecialSummonRule(tp,sc,sumtype)
				break
			end
		end
	end
end