--小镇智能
local m=43990105
local cm=_G["c"..m]
function c43990105.initial_effect(c)
	-- 超量召唤规则
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	
	-- 效果①：永续伤害+生成衍生物
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c43990105.damcon)
	e1:SetOperation(c43990105.damop)
	c:RegisterEffect(e1)
	
	-- 效果②：伤害+抽卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990105,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,43990105)
	e2:SetCondition(c43990105.damcon2)
	e2:SetTarget(c43990105.damtg2)
	e2:SetOperation(c43990105.damop2)
	c:RegisterEffect(e2)
end

-- 效果①条件：对方特殊召唤
function c43990105.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) and #eg==1
end

function c43990105.dcfilter(c)
	return c:IsCode(43990106) and c:IsFaceup()
end
-- 效果①操作：伤害计算+衍生物生成
function c43990105.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local dam=0
			local val=0
			if tc:IsType(TYPE_XYZ) then
				val=tc:GetRank()
			elseif tc:IsType(TYPE_LINK) then
				val=tc:GetLink()
			else
				val=tc:GetLevel()
			end
			dam=dam+val*50
	if dam>0 then
		-- 基础伤害
		dam=dam+Duel.GetMatchingGroupCount(c43990105.dcfilter,tp,0,LOCATION_MZONE,nil)*100
		Duel.Damage(1-tp,dam,REASON_EFFECT)
		-- 生成蔷薇衍生物
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,43990106,0,TYPES_TOKEN_MONSTER,0,0,2,RACE_ILLUSION,ATTRIBUTE_WIND) then
			local token=Duel.CreateToken(tp,43990106)
			Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
		end
	end
end

-- 效果②条件：幻想魔效果发动
function c43990105.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE)
	return re:IsActiveType(TYPE_MONSTER) and race&RACE_ILLUSION>0 and rc:IsAttackAbove(1)
end

-- 效果②目标设定
function c43990105.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local rc=re:GetHandler()
	local dam=math.floor(rc:GetAttack()/2)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

-- 效果②操作处理
function c43990105.damop2(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if Duel.Damage(1-tp,d,REASON_EFFECT)>0 then
			Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end