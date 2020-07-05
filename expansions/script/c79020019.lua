--整合运动·无人机-威龙
function c79020019.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,99,c79020019.lcheck)
	c:EnableReviveLimit()   
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83755611,1))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c79020019.destg)
	e1:SetOperation(c79020019.desop)
	c:RegisterEffect(e1)
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79020019.dacon)
	e2:SetTarget(c79020019.datg)
	e2:SetOperation(c79020019.daop)
	c:RegisterEffect(e2)
	--direct atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c79020019.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c79020019.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3903)
end
function c79020019.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x3903)
end
function c79020019.desfilter(c,ft)
	return ft>0 or (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5)
end
function c79020019.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1
		and Duel.IsExistingTarget(c79020019.desfilter,tp,LOCATION_MZONE,0,1,nil,ft)
		and Duel.IsExistingTarget(c79020019.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectTarget(tp,c79020019.desfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c79020019.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end
function c79020019.desop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_RELEASE)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	if tc1:IsRelateToEffect(e) and tc2:IsRelateToEffect(e) and Duel.Release(tc1,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c79020019.dacon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsSetCard(0x3903) and eg:GetFirst():GetFlagEffect(79020019)==0
end
function c79020019.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetFirst():IsAbleToRemoveAsCost() end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(eg:GetFirst():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,nil,1-tp,eg:GetFirst():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,eg:GetFirst(),1,0,0)
	eg:GetFirst():RegisterFlagEffect(79020019,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,0)
end
function c79020019.daop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Release(eg:GetFirst(),REASON_COST)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c79020019.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x3903)
end











