--机甲龙兽
function c9951586.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),true)
--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
  --indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--attack twice
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(1)
	c:RegisterEffect(e4)
--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951586,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9951586)
	e1:SetCost(c9951586.cost)
	e1:SetTarget(c9951586.target)
	e1:SetOperation(c9951586.operation)
	c:RegisterEffect(e1)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951586.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951586.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951586,0))
end
function c9951586.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9951586.mgfilter(c,e,tp,fusc,mg)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
		and bit.band(c:GetReason(),0x40008)==0x40008 and c:GetReasonCard()==fusc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and fusc:CheckFusionMaterial(mg,c,PLAYER_NONE,true)
end
function c9951586.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetMaterial()
	if chk==0 then
		local ct=g:GetCount()
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if e:GetHandler():GetSequence()<5 then ft=ft+1 end
		return ct>0 and ft>=ct and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
			and g:FilterCount(c9951586.mgfilter,nil,e,tp,e:GetHandler(),g)==ct
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c9951586.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=e:GetHandler():GetMaterial()
	local ct=g:GetCount()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
		and g:FilterCount(c9951586.mgfilter,nil,e,tp,e:GetHandler(),g)==ct then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

