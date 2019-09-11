--幽灵骑士Specter·罪魂
function c9980952.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c9980952.lcheck)
	c:EnableReviveLimit()
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_SZONE)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
	--double battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c9980952.damcon)
	e2:SetOperation(c9980952.damop)
	c:RegisterEffect(e2)
	--destroy all
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9980952,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,99809520)
	e4:SetTarget(c9980952.destg)
	e4:SetOperation(c9980952.desop)
	c:RegisterEffect(e4)
	--special summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(9980952,1))
	e7:SetCategory(CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetCountLimit(1,99809520)
	e7:SetCondition(aux.bdocon)
	e7:SetTarget(c9980952.destg)
	e7:SetOperation(c9980952.desop)
	c:RegisterEffect(e7)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9980952,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,9980952)
	e4:SetCost(c9980952.spcost)
	e4:SetTarget(c9980952.sptg)
	e4:SetOperation(c9980952.spop)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980952.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980952.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980952,2))
end
function c9980952.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xcbc2)
end
function c9980952.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil and e:GetHandler():GetSequence()>4
end
function c9980952.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c9980952.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c9980952.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	   Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980952,3))
	end
end
function c9980952.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c9980952.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9980952.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9980952.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9980952.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9980952,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
