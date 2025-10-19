-- 仪式魔法卡：暗月仪式
local s, id = GetID()

function s.initial_effect(c)
	-- 仪式魔法卡
	c:EnableReviveLimit()
	
	-- 效果①：仪式召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.rtarget)
	e1:SetOperation(s.ractivate)
	c:RegisterEffect(e1)
	
	-- 效果②：墓地除外发动保护效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
 --   e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.protg)
	e2:SetOperation(s.proop)
	c:RegisterEffect(e2)
end

-- 定义暗月字段
s.darkmoon_setcode = 0x696c

-- 效果①：仪式召唤目标设定
function s.rtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,s.ritual_filter,e,tp,mg1,mg2,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end

-- 效果①：仪式召唤操作
function s.ractivate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_DECK,0,nil)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,s.ritual_filter,e,tp,mg1,mg2,Card.GetLevel,"Greater")
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		
		if not mat then return end
		
		-- 处理解放/除外素材
		local deck_mat=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		local other_mat=mat:Filter(function(c) return not c:IsLocation(LOCATION_DECK) end,nil)
		
		if #deck_mat>0 then
			Duel.Remove(deck_mat,POS_FACEUP,REASON_EFFECT+REASON_REPLACE+REASON_MATERIAL)
		end
		if #other_mat>0 then
			Duel.ReleaseRitualMaterial(other_mat)
		end
		
		tc:SetMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

-- 仪式怪兽筛选器（念动力族）
function s.ritual_filter(c)
	return c:IsRace(RACE_PSYCHO)
end

-- 卡组暗月怪兽筛选器（作为解放代替）
function s.mfilter(c)
	return c:IsSetCard(s.darkmoon_setcode) and c:GetLevel()>0 and c:IsAbleToRemove()
end

-- 效果②：目标设定
function s.protg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

-- 效果②：操作处理
function s.proop(e,tp,eg,ep,ev,re,r,rp)
	-- 这个回合，自己场上的暗月怪兽不会被对方的效果破坏
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,s.darkmoon_setcode))
	e1:SetValue(aux.indoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end