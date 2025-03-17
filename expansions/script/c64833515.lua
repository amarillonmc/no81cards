-- 荒芜之摩斯迪露姆
local s,id=GetID()

function s.initial_effect(c)
	-- 融合素材设定
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,64833501,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_EARTH),1,true,true)
	
	-- ① 双方送墓效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.invalidcon)
	e2:SetOperation(s.invalidop)
	--c:RegisterEffect(e2)
end

-- 共用原持有者检测函数
function s.ownfilter(c,tp)
	return c:GetOwner()==tp
end

-- ① 效果判断
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) 
		and c:GetMaterial():FilterCount(s.ownfilter,nil,tp)==c:GetMaterial():GetCount()
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,PLAYER_ALL,0)
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	-- 对方场送墓
	local tg=Group.CreateGroup()
	if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,0,1,1,nil)
		if #g1>0 then
			tg:Merge(g1)
		end
	end
	
	-- 己方卡组送墓
	if Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,1,nil)
		if #g2>0 then
			tg:Merge(g2)
		end
	end
	if #tg>0 then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if c:GetMaterial():FilterCount(s.ownfilter,nil,e:GetHandlerPlayer())>=2 then
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(64833501,0))
	end
end

-- 优化后的检测函数
function s.summoned_this_turn(c)
	local tid=Duel.GetTurnCount()
	return c:GetTurnID()==tid 
		and (c:IsSummonType(SUMMON_TYPE_NORMAL)
			or c:IsSummonType(SUMMON_TYPE_SPECIAL))
end

-- 效果无效判断（优化版）
function s.invalidcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return e:GetHandler():GetMaterial():FilterCount(s.ownfilter,nil,tp)>=2
		and rc:IsControler(1-tp)
		and rc:IsType(TYPE_MONSTER)
		and s.summoned_this_turn(rc)
		and re:IsActiveType(TYPE_MONSTER)
end

-- 效果无效处理（优化版）
function s.invalidop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.NegateEffect(ev)
end