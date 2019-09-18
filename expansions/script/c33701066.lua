--小鸟 ～无悔的收获祭～
function c33701066.initial_effect(c)
	 --pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33701066,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCost(c33701066.recost)
	e3:SetTarget(c33701066.retg)
	e3:SetOperation(c33701066.reop)
	c:RegisterEffect(e3)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c33701066.spcon)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33701066,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c33701066.spcost)
	e1:SetTarget(c33701066.sptg)
	e1:SetOperation(c33701066.spop)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c33701066.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c33701066.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(33701066,2))
end
function c33701066.costfilter(c)
	return c:IsSetCard(0x6440) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c33701066.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33701066.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	 local g=Duel.SelectMatchingCard(tp,c33701066.costfilter,tp,LOCATION_HAND,1,1,e:GetHandler())
	e:SetLabel(g:GetFirst():GetLevel()*500)
	Duel.DiscardHand(g,1,REASON_COST)
end
function c33701066.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
	e:SetLabel(0)
end
function c33701066.reop(e,tp,eg,ep,ev,re,r,rp)
   local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(33701066,3))
end
function c33701066.filter(c)
	return c:IsFaceup() and c:IsLevel(5) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c33701066.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c33701066.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c33701066.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6440) and c:IsType(TYPE_MONSTER)
end
function c33701066.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c33701066.cfilter,1,nil) end
	local cg=Duel.SelectReleaseGroupEx(tp,c33701066.cfilter,1,1,nil)
	Duel.Release(cg,REASON_COST)
end
function c33701066.spfilter(c,e,tp)
	return c:IsLevel(5) and c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsCode(33701066)and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c33701066.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33701066.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c33701066.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33701066.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end