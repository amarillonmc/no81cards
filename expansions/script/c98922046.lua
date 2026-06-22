--青蔷薇破灭龙
-- 设定卡片ID（系统会自动获取）
local s,id=GetID()

function s.initial_effect(c)
	--①：自己场上或墓地有「蔷薇」同调怪兽存在的场合，这张卡可以从手卡特殊召唤。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	-- 作为①的方法的特殊召唤1回合只能有1次（使用OATH限制）
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	
	--②：自己主要阶段才能发动。在自己场上把1只「蔷薇衍生物」或「魔界蔷薇衍生物」特殊召唤，这张卡的等级下降那只衍生物的等级数值。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	-- 作为②的效果1回合只能使用1次
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

-- ① 效果的特殊召唤条件检查
function s.spfilter(c,fcheck)
	-- 同调怪兽必然是怪兽，这里只判断TYPE_SYNCHRO，并且场上的需要表侧表示，墓地不需要
	return (not fcheck or c:IsFaceup()) and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x123)
end

function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	-- 检查怪兽区域是否有空位，以及场上或墓地是否存在「蔷薇」同调怪兽
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil,true)
			or Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,false))
end

-- ② 效果的选择与发动目标检查
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 必须有怪兽区域空位，且玩家必须能够特招其中一种衍生物
		-- 此处使用 TYPE_MONSTER+TYPE_TOKEN 代替 IsMonster
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and (Duel.IsPlayerCanSpecialSummonMonster(tp,71645243,0,TYPE_MONSTER+TYPE_TOKEN,800,800,2,RACE_PLANT,ATTRIBUTE_DARK)
				or Duel.IsPlayerCanSpecialSummonMonster(tp,31986289,0,TYPE_MONSTER+TYPE_TOKEN,1200,1200,3,RACE_PLANT,ATTRIBUTE_DARK))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end

-- ② 效果的具体执行
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	
	-- 确认两种衍生物是否能特招
	local t1=Duel.IsPlayerCanSpecialSummonMonster(tp,71645243,0,TYPE_MONSTER+TYPE_TOKEN,800,800,2,RACE_PLANT,ATTRIBUTE_DARK)
	local t2=Duel.IsPlayerCanSpecialSummonMonster(tp,31986289,0,TYPE_MONSTER+TYPE_TOKEN,1200,1200,3,RACE_PLANT,ATTRIBUTE_DARK)
	if not (t1 or t2) then return end
	
	-- 决定特招哪一只
	local opt=0
	if t1 and t2 then
		-- 如果两个都可以召唤，让玩家进行选择
		-- 选项索引说明：0对应蔷薇衍生物，1对应魔界蔷薇衍生物
		opt=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif t1 then
		opt=0
	else
		opt=1
	end
	
	local token_id = opt==0 and 71645243 or 31986289
	local lv = opt==0 and 2 or 3
	
	-- 创建衍生物并特殊召唤
	local token=Duel.CreateToken(tp,token_id)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
		-- 只有当召唤成功，且这张卡依然在场上表侧表示存在时，才下降等级（同时处理）
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(-lv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end