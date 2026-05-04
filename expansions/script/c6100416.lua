--追忆之白皇后
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,6100146)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)

	c:SetUniqueOnField(1,0,6100416)
	
	local p_proc=Effect.CreateEffect(c)
	p_proc:SetDescription(aux.Stringid(id,0)) 
	p_proc:SetType(EFFECT_TYPE_FIELD)
	p_proc:SetCode(EFFECT_SPSUMMON_PROC_G)
	p_proc:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	p_proc:SetRange(LOCATION_EXTRA+LOCATION_HAND)
	p_proc:SetCondition(s.pzcon)
	p_proc:SetOperation(s.pzop)
	c:RegisterEffect(p_proc)
	
	local p_ign=Effect.CreateEffect(c)
	p_ign:SetDescription(aux.Stringid(id,1)) 
	p_ign:SetCategory(CATEGORY_SPECIAL_SUMMON)
	p_ign:SetType(EFFECT_TYPE_IGNITION)
	p_ign:SetRange(LOCATION_PZONE)
	p_ign:SetCountLimit(1)
	p_ign:SetTarget(s.sptg)
	p_ign:SetOperation(s.spop)
	c:RegisterEffect(p_ign)
	
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_FIELD)
	ge0:SetCode(EFFECT_SPSUMMON_PROC_G)
	ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ge0:SetRange(LOCATION_HAND)
	ge0:SetCondition(s.spell_spcon)
	ge0:SetOperation(s.spell_spop)
	--effect grant
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e0:SetRange(LOCATION_PZONE)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetCondition(s.efcon)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL))
	e0:SetLabelObject(ge0)
	c:RegisterEffect(e0)

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

function s.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_SYNCHRO)==0
end

function s.pzfilter_all(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function s.pzfilter_req(c)
	return c:IsType(TYPE_SPELL) and aux.IsCodeListed(c,6100146) and c:IsAbleToGraveAsCost()
end

function s.pz_zone_check(c1,c2,tp)
	local ct = 0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct = ct + 1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct = ct + 1 end
	if c1 and c1:IsLocation(LOCATION_PZONE) and c1:IsControler(tp) then ct = ct + 1 end
	if c2 and c2:IsLocation(LOCATION_PZONE) and c2:IsControler(tp) then ct = ct + 1 end
	return ct > 0
end

function s.pz_check2(c2,c1,tp)
	return s.pz_zone_check(c1,c2,tp)
end

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
	local sel1=g1:FilterSelect(tp,s.pz_check1,1,1,nil,tp,g2)
	local tc1=sel1:GetFirst()
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sel2=g2:FilterSelect(tp,s.pz_check2,1,1,tc1,tc1,tp)
	
	sel1:Merge(sel2)
	Duel.ConfirmCards(1-tp,sel1)
	Duel.SendtoGrave(sel1,REASON_COST)
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end

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

function s.efcon(e)
	return e:GetHandler():GetFlagEffect(id)~=0
end

function s.spell_spcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0,TYPE_NORMAL+TYPE_MONSTER+TYPE_SPELL,0,0,3,RACE_SPELLCASTER,ATTRIBUTE_LIGHT)--setcard
end

function s.spell_spop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local KOISHI_CHECK=false
	if Card.SetCardData then KOISHI_CHECK=true end
	-- 将魔法卡属性转换为怪兽（通常怪兽·魔法师族·光·3星·攻/守0），由于包含了 TYPE_SPELL，它登场后“也当作魔法卡使用”
	if KOISHI_CHECK then
		c:RegisterFlagEffect(id,0,0,1,c:GetOriginalType())
		c:SetCardData(CARDDATA_TYPE,TYPE_NORMAL+TYPE_MONSTER+TYPE_SPELL)
	end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_SPELL,ATTRIBUTE_LIGHT,RACE_SPELLCASTER,3,0,0)
	if not KOISHI_CHECK then Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP) end
	if KOISHI_CHECK then
		--summon cost
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_SPSUMMON_COST)
		ge0:SetTargetRange(LOCATION_HAND,0)
		ge0:SetLabelObject(c)
		ge0:SetCost(s.costchk)
		ge0:SetOperation(s.costop)
		Duel.RegisterEffect(ge0,tp)
	end
	if not KOISHI_CHECK then Duel.SpecialSummonComplete() end
end
function s.costchk(e,c,tp)
	return true
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id)~=0 then
		tc:SetCardData(CARDDATA_TYPE,tc:GetFlagEffectLabel(id))
		tc:ResetFlagEffect(id)
	end
	e:Reset()
end
