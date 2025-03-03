-- 替罪之囚笼 摩斯迪洛
local s,id=GetID()

function s.initial_effect(c)
	-- 全局卡名限制
	c:SetUniqueOnField(1,0,id)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	-- ② 融合召唤封锁
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_FORBIDDEN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND)
	e2:SetCondition(s.lockcon)
	c:RegisterEffect(e2)
	
	-- ③ 融合召唤时点封锁
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(s.chainop)
	c:RegisterEffect(e3)
end

-- ① 检索效果
function s.thfilter(c)
	return c:IsSetCard(0x1419) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- ② 融合相关封锁
function s.lockcon(e)
	local ex,g,gc,_,_,et=Duel.GetOperationInfo(Duel.GetCurrentChain(),CATEGORY_SPECIAL_SUMMON)
	return ex and et==SUMMON_TYPE_FUSION
end

-- ③ 连锁处理
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasCategory(CATEGORY_FUSION_SUMMON) then
		-- 禁止对方连锁
		Duel.SetChainLimitTillChainEnd(s.chainfilter)
		-- 注册召唤成功时封锁
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetOperation(s.spsumop)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.chainfilter(re,rp,tp)
	return tp==rp
end
function s.spsumop(e,tp,eg,ep,ev,re,r,rp)
	-- 融合召唤成功时封锁
	if eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_FUSION) then
		Duel.SetChainLimitTillChainEnd(s.chainfilter)
	end
end