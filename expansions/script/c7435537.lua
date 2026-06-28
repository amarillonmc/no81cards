--髑岩王 华劣斯托姆
local s,id=GetID()

--规则上当作「叛骨」卡使用
s.named_with_Rebellion_Skull=1

--判定函数
function s.Rebellion_Skull(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Rebellion_Skull) or (SETCARD_REBELLION_SKULL and c:IsSetCard(SETCARD_REBELLION_SKULL))
end
function s.Skullize(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Skullize) or (SETCARD_SKULLIZE and c:IsSetCard(SETCARD_SKULLIZE))
end

function s.initial_effect(c)
	--融合召唤手续：8星以下的不死族怪兽×3
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.matfilter,3,true)

	--①：抗性效果
	--抗性：自身不受对方效果影响
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	
	--抗性：自己场上的魔法·陷阱卡不受对方效果影响
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	-- 关键点：增加此 Flag，确保盖放的魔陷也能获得抗性
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	-- 参考白龙忍者，设为 ONFIELD
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(s.etg)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
end

--融合素材过滤器
function s.matfilter(c,fc,sumtype,tp)
	return c:IsRace(RACE_ZOMBIE,fc,sumtype,tp) and c:IsLevelBelow(8)
end

--抗性过滤器：源自对方
function s.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--目标过滤器：魔法或陷阱卡（包含里侧）
function s.etg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
