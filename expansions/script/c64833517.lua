-- 曙光之摩斯迪露姆
local s,id=GetID()

function s.initial_effect(c)
	-- 融合素材设定
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,64833501,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT),1,true,true)
	
	-- ① 强制送墓效果
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
	
	-- ② 双封禁效果
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ADD_TO_HAND)
	e2:SetTargetRange(0,1)
	e2:SetTarget(s.handlimit)
	e2:SetCondition(s.bancon)
	c:RegisterEffect(e2)
	
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_TO_GRAVE)
	e3:SetTarget(s.graveimit)
	c:RegisterEffect(e3)
end

-- 原持有者检测函数
function s.ownfilter(c,tp)
	return c:GetOwner()==tp
end

-- ① 效果条件判断
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) 
		and c:GetMaterial():FilterCount(s.ownfilter,nil,tp)==c:GetMaterial():GetCount()
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_MZONE,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
	local c=e:GetHandler()
	if c:GetMaterial():FilterCount(s.ownfilter,nil,e:GetHandlerPlayer())>=2 then
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(64833501,0))
	end
end

-- ② 封禁条件判断
function s.bancon(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) 
		and c:GetMaterial():FilterCount(s.ownfilter,nil,e:GetHandlerPlayer())>=2
end

-- 手牌封禁判断
function s.handlimit(e,c,tp)
	return c:IsLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end

-- 墓地封禁判断
function s.graveimit(e,c,tp)
	return c:IsLocation(LOCATION_DECK) 
end