--皇帝龙兽
function c9951571.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),7,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c9951571.hspcon)
	e2:SetOperation(c9951571.hspop)
	c:RegisterEffect(e2)
 --atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951571,0))
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c9951571.atkcost)
	e3:SetOperation(c9951571.atkop)
	c:RegisterEffect(e3)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951571.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951571.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951571,0))
end
function c9951571.hspfilter(c,tp,sc)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_FUSION) and c:IsLevel(12) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c9951571.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c9951571.hspfilter,1,nil,c:GetControler(),c)
end
function c9951571.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c9951571.hspfilter,1,1,nil,tp,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function c9951571.cfilter(c)
	return (c:IsAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_DRAGON)) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c9951571.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9951571.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,e:GetHandler())
	if chk==0 then return g:GetCount()>0 and g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==g:GetCount() end
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9951571.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()*5000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
