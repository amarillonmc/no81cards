--追忆之白皇后
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,6100146)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	
	--【怪兽效果】这张卡不能同调召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)

	c:SetUniqueOnField(1,0,6100416)
	
	local p_proc=Effect.CreateEffect(c)
	p_proc:SetDescription(aux.Stringid(id,0)) -- "放置在灵摆区域"
	p_proc:SetType(EFFECT_TYPE_FIELD)
	p_proc:SetCode(EFFECT_SPSUMMON_PROC_G)
	p_proc:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	p_proc:SetRange(LOCATION_EXTRA+LOCATION_HAND)
	p_proc:SetCondition(s.pzcon)
	p_proc:SetOperation(s.pzop)
	c:RegisterEffect(p_proc)
	
	--①：1回合1次，自己主要阶段才能发动。特召手卡·墓地的「破碎世界的愚者」
	local p_ign=Effect.CreateEffect(c)
	p_ign:SetDescription(aux.Stringid(id,1)) -- "特殊召唤「破碎世界的愚者」"
	p_ign:SetCategory(CATEGORY_SPECIAL_SUMMON)
	p_ign:SetType(EFFECT_TYPE_IGNITION)
	p_ign:SetRange(LOCATION_PZONE)
	p_ign:SetCountLimit(1)
	p_ign:SetTarget(s.sptg)
	p_ign:SetOperation(s.spop)
	c:RegisterEffect(p_ign)
	
	--①：只要这张卡在灵摆区域存在，可以把魔法卡当作通常怪兽特召 (不入连锁的手续)
	local p_adj=Effect.CreateEffect(c)
	p_adj:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	p_adj:SetCode(EVENT_ADJUST)
	p_adj:SetRange(LOCATION_PZONE)
	p_adj:SetOperation(s.adjustop)
	c:RegisterEffect(p_adj)

	--③：把「破碎世界的愚者」当作调整使用
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_TUNER)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(function(e,tc) return tc:IsType(TYPE_NORMAL) and c:IsRace(RACE_SPELLCASTER) end)
	c:RegisterEffect(e4)

	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_PZONE)
	e7:SetTargetRange(1,0)
	e7:SetCondition(s.fcon)
	e7:SetValue(s.actlimit)
	c:RegisterEffect(e7)
end

function s.fcon(e,c,og)
	return e:GetHandler():GetFlagEffect(id)>0
end

function s.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

-- === 怪兽效果限制 ===
function s.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_SYNCHRO)==0
end

-- === 怪兽效果：放置灵摆区手续 ===
function s.pzfilter_all(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function s.pzfilter_req(c)
	-- 要求是魔法卡、能够送墓，并且卡名记述了 6100146 (请确保对应的魔法卡本身有 aux.AddCodeList(c,6100146))
	return c:IsType(TYPE_SPELL) and aux.IsCodeListed(c,6100146) and c:IsAbleToGraveAsCost()
end

-- 动态空间检测：判断选取的卡片送墓后，灵摆区是否会有空位
function s.pz_zone_check(c1,c2,tp)
	local ct = 0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct = ct + 1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct = ct + 1 end
	-- 如果作为Cost的卡在自己灵摆区，送去墓地后也会腾出空位
	if c1 and c1:IsLocation(LOCATION_PZONE) and c1:IsControler(tp) then ct = ct + 1 end
	if c2 and c2:IsLocation(LOCATION_PZONE) and c2:IsControler(tp) then ct = ct + 1 end
	return ct > 0
end

-- 检查第2张卡是否合法
function s.pz_check2(c2,c1,tp)
	return s.pz_zone_check(c1,c2,tp)
end
-- 检查第1张卡是否合法（是否存在对应的第2张卡）
function s.pz_check1(c1,tp,g2)
	return g2:IsExists(s.pz_check2,1,c1,c1,tp)
end

function s.pzcon(e,c,og)
	local tp=e:GetHandler():GetControler()
	
	local g1=Duel.GetMatchingGroup(s.pzfilter_req,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	local g2=Duel.GetMatchingGroup(s.pzfilter_all,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	
	return g1:IsExists(s.pz_check1,1,nil,tp,g2) and Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_ONFIELD,0,nil,id)<1
end

function s.pzop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	Duel.RegisterFlagEffect(tp,id+100,RESET_PHASE+PHASE_END,0,1)
	
	local g1=Duel.GetMatchingGroup(s.pzfilter_req,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	local g2=Duel.GetMatchingGroup(s.pzfilter_all,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	-- 先选第1张（必须有愚者记述的魔法卡）
	local sel1=g1:FilterSelect(tp,s.pz_check1,1,1,nil,tp,g2)
	local tc1=sel1:GetFirst()
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	-- 再选第2张（任意魔法卡）
	local sel2=g2:FilterSelect(tp,s.pz_check2,1,1,tc1,tc1,tp)
	
	sel1:Merge(sel2)
	Duel.ConfirmCards(1-tp,sel1)
	Duel.SendtoGrave(sel1,REASON_COST)
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end

-- === 灵摆效果①：起动特召愚者 ===
function s.spfilter(c,e,tp)
	return c:IsCode(6100146) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end

-- === 全局分发：只要在P区，就赋予手卡魔法卡特召能力 ===
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_PZONE) then return end
	if c:GetFlagEffect(id)>0 then
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_SPELL)
	for tc in aux.Next(g) do
		-- 利用专属的隐藏 Effect ID 作为标记，避免给同1张魔法卡重复注册
		if not tc:IsHasEffect(id) then
			local sp=Effect.CreateEffect(c)
			sp:SetDescription(aux.Stringid(id,2)) -- "当作通常怪兽特殊召唤"
			sp:SetType(EFFECT_TYPE_FIELD)
			sp:SetCode(EFFECT_SPSUMMON_PROC_G)
			sp:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			sp:SetRange(LOCATION_HAND)
			sp:SetCondition(s.spell_spcon)
			sp:SetOperation(s.spell_spop)
			sp:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(sp)
			
			local marker=Effect.CreateEffect(c)
			marker:SetType(EFFECT_TYPE_SINGLE)
			marker:SetCode(id)
			marker:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			marker:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(marker)
		end
		end
	end
end

-- === 魔法卡的特召手续条件与执行 ===
function s.spell_spcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	-- 安全检测：检查发动者的灵摆区是否依然存在此卡
	if not Duel.IsExistingMatchingCard(function(tc) return tc:IsCode(id) and tc:IsFaceup() end,tp,LOCATION_PZONE,0,1,nil) then return false end
	
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0,TYPE_NORMAL+TYPE_SPELL,0,0,3,RACE_SPELLCASTER,ATTRIBUTE_LIGHT)
end

function s.spell_spop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	-- 将魔法卡属性转换为怪兽（通常怪兽·魔法师族·光·3星·攻/守0），由于包含了 TYPE_SPELL，它登场后“也当作魔法卡使用”
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_SPELL,ATTRIBUTE_LIGHT,RACE_SPELLCASTER,3,0,0)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
