-- 融合怪兽：替罪之子 摩斯迪露姆 + 暗属性
local s,id=GetID()

function s.initial_effect(c)
	-- 融合素材设定
	c:EnableReviveLimit()
		--fusion material
	aux.AddFusionProcCodeFun(c,64833501,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),1,true,true)
	-- ① 抽卡效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.drcon)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	
	-- ② 效果封锁
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.lockcon)
	e2:SetValue(s.lockval)
	--c:RegisterEffect(e2)
end

-- ① 抽卡条件判断
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.selfmatfilter(c,tp)
	return c:GetOwner()==tp
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetMaterial():IsExists(s.selfmatfilter,1,nil,tp) end
	local ct=c:GetMaterial():FilterCount(s.selfmatfilter,nil,tp)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=e:GetHandler():GetMaterial():FilterCount(s.selfmatfilter,nil,tp)
	if ct>0 then
		Duel.Draw(p,ct,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if c:GetMaterial():FilterCount(s.ownfilter,nil,e:GetHandlerPlayer())>=2 then
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(64833501,0))
	end
end

-- ② 效果封锁判断
function s.ownfilter(c,tp)
	return c:GetOwner()==tp
end
function s.lockcon(e)
	local c=e:GetHandler()
	return c:GetMaterial():FilterCount(s.ownfilter,nil,e:GetHandlerPlayer())>=2
end
function s.lockval(e,re,tp)
	local rc=re:GetHandler()
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) 
		and rc:IsLocation(LOCATION_HAND) and re:IsHasCategory(CATEGORY_HANDES)
end