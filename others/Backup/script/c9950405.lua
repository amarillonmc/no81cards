--X·虚拟怪兽-电子怨灵宙达
function c9950405.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x5bd2),c9950405.ffilter2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9950405.splimit)
	c:RegisterEffect(e1)
--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c9950405.immval)
	c:RegisterEffect(e3)
--ATK Gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c9950405.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950405,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c9950405.sptg)
	e3:SetOperation(c9950405.spop)
	c:RegisterEffect(e3)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950405.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950405.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950405,0))
end
function c9950405.ffilter2(c)
	return c:GetOriginalLevel()>=8 and c:IsFusionAttribute(ATTRIBUTE_DARK)
end
function c9950405.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c9950405.immval(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER) and te:IsActivated()
		and te:GetOwner():GetBaseAttack()<=4500 and te:GetOwner():GetBaseAttack()>=0
end
function c9950405.val(e,c)
	return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_EXTRA,0,nil)*1000
end
function c9950405.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c9950405.rmfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x5bd2) and c:IsAbleToRemove()
end
function c9950405.spop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if Duel.Destroy(dg,REASON_EFFECT)==0 then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9950405.rmfilter,tp,LOCATION_GRAVE,0,c)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.SelectYesNo(tp,aux.Stringid(9950405,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:Select(tp,1,1,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
