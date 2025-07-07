--绮奏·封律散华 绯焰澪兔
function c66620235.initial_effect(c)

	-- 「绮奏」融合怪兽＋「绮奏」怪兽
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c66620235.matfilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0x666a),true)
	
	-- 这张卡不会被对方的效果破坏
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)
	
	-- 这张卡融合召唤的场合，指定没有使用的主要怪兽区域或者魔法与陷阱区域2处才能发动，指定的区域在这只怪兽表侧表示存在期间不能使用
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66620235,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,66620235)
	e2:SetCondition(c66620235.lzcon)
	e2:SetTarget(c66620235.lztg)
	e2:SetOperation(c66620235.lzop)
	c:RegisterEffect(e2)
	
	-- 融合召唤的这张卡因对方从场上离开的场合才能发动，给与对方1500伤害
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66620235,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,66620236)
	e3:SetCondition(c66620235.damcon)
	e3:SetTarget(c66620235.damtg)
	e3:SetOperation(c66620235.damop)
	c:RegisterEffect(e3)
end

-- 「绮奏」融合怪兽＋「绮奏」怪兽
function c66620235.matfilter(c)
	return c:IsFusionType(TYPE_FUSION) and c:IsFusionSetCard(0x666a)
end

-- 这张卡融合召唤的场合，指定没有使用的主要怪兽区域或者魔法与陷阱区域2处才能发动，指定的区域在这只怪兽表侧表示存在期间不能使用
function c66620235.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

function c66620235.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)
		+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
		+Duel.GetLocationCount(tp,LOCATION_SZONE,PLAYER_NONE,0)
		+Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)>0 end
	local dis=Duel.SelectDisableField(tp,2,LOCATION_ONFIELD,LOCATION_ONFIELD,0xe000e0)
	Duel.SetTargetParam(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
end

function c66620235.lzop(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tp==1 then
		zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
	end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(zone)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

-- 融合召唤的这张卡因对方从场上离开的场合才能发动，给与对方1500伤害
function c66620235.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end

function c66620235.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1500)
end

function c66620235.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
