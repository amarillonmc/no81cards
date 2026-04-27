--混沌召唤
--混沌召唤
local s,id,o=GetID()
function s.initial_effect(c)
	--仪式召唤规则
	c:EnableReviveLimit()
	
	--①：这张卡只要在怪兽区域存在，卡名当作「恶魔召唤」使用。
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(70781052)
	c:RegisterEffect(e1)
	
	--②：只要这张卡在怪兽区域存在，原本卡名是「混沌召唤」的怪兽以外的自己场上的「混沌」仪式怪兽以及「恶魔召唤」不受对方的效果影响。
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.imtg)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)

	--③：以「混沌召唤」以外的自己墓地的等级或者阶级是6的1只恶魔族怪兽为对象才能发动。...对象可以变成2只。
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end

--②效果：过滤需要受到保护的怪兽
function s.imtg(e,c)
	-- 原本卡名是「混沌召唤」的怪兽以外
	if c:IsOriginalCodeRule(id) then return false end
	-- 包含自己场上的「混沌」仪式怪兽以及「恶魔召唤」
	return (c:IsSetCard(0xcf) and c:IsType(TYPE_RITUAL)) or c:IsCode(70781052)
end

--②效果：过滤对方的效果
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--③效果：墓地特殊召唤合法性判断
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_FIEND) and (c:IsLevel(6) or c:IsRank(6)) and not c:IsCode(id)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

--③效果：检测自己场上是否有其他的「恶魔召唤」
function s.skfilter(c,ec)
	return c:IsFaceup() and c:IsCode(70781052) and c~=ec
end

--③效果：发动目标选择
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	-- 判断场上是否有其他的「恶魔召唤」
	local b = Duel.IsExistingMatchingCard(s.skfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler())
	local max = 1
	-- 如果有其他的「恶魔召唤」并且怪兽区空位足够，最大对象数量提升到2
	if b and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		max = 2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,max,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end

--③效果：特殊召唤处理
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	-- 场地位置判断与特殊规则限制（如青眼精灵龙同时特召限制）
	if #g>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if #g>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end