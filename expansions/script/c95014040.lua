--岩嗣护卫 贝丝尔
-- 岩嗣融合怪兽
local s,id=GetID()

function s.initial_effect(c)
	-- 融合召唤设置
	c:EnableReviveLimit()
	-- 融合召唤方法1：正规融合召唤
	aux.AddFusionProcCodeRep(c,s.fusionfilter,2,false,false)
	
	-- 融合召唤方法2：接触融合（将场上的怪兽送去墓地）
   aux.AddContactFusionProcedure(c,s.cffilter,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)
	
	-- 效果①：特殊召唤时发动
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.atkcon)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
	
	-- 效果②：场上攻击力0的怪兽效果无效化
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(s.distg)
	c:RegisterEffect(e4)
end

-- 融合素材过滤器：岩嗣怪兽
function s.fusionfilter(c,fc,sub,mg,sg)
	return c:IsSetCard(0x396d) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end

-- 特殊召唤条件（接触融合）
function s.cffilter(c,fc)
	return c:IsAbleToGraveAsCost() and (c:IsControler(fc:GetControler()) or c:IsFaceup())
end

-- 效果①：特殊召唤时发动的条件
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) or e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end

-- 效果①：目标设定
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,0,1-tp,0)
end

-- 效果①：操作处理
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- 对方场上怪兽攻击力下降1000
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
	
	-- 添加特殊召唤限制：直到回合结束时，自己不是恶魔族·地属性怪兽不能特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

-- 特殊召唤限制函数
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_EARTH))
end

-- 效果②：效果无效化目标
function s.distg(e,c)
	return c:GetAttack()==0
end