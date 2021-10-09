--骑士时刻·王权盖茨
function c9981532.initial_effect(c)
	  --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,99,c9981532.lcheck)
	c:EnableReviveLimit()
	--cannot be link material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.indoval)
	c:RegisterEffect(e5)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9981532.atkval)
	c:RegisterEffect(e1)
	--reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c9981532.rdcon)
	e3:SetOperation(c9981532.rdop)
	c:RegisterEffect(e3)
	--special summon (extra)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9981532,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(2,9981532)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetTarget(c9981532.esptg)
	e4:SetOperation(c9981532.espop)
	c:RegisterEffect(e4)
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981532,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(2,9981532)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c9981532.distg)
	e2:SetOperation(c9981532.disop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981532.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981532.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981532,2))
end
function c9981532.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xcbcd)
end
function c9981532.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c9981532.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c9981532.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbca) and c:GetBaseAttack()>=0
end
function c9981532.atkval(e,c)
	local lg=c:GetLinkedGroup():Filter(c9981532.atkfilter,nil)
	return lg:GetSum(Card.GetBaseAttack)
end
function c9981532.espfilter(c,e,tp)
	return c:IsSetCard(0xbca) and c:IsLevelBelow(10)
		and c:IsCanBeSpecialSummoned(e,124,tp,true,false)
end
function c9981532.esptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c9981532.espfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
end
function c9981532.espop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9981532.espfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,124,tp,tp,true,false,POS_FACEUP)
	end
end
function c9981532.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c9981532.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c9981532.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9981532.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c9981532.disfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,0xc,g)
	if g2:GetCount()>0 then
	   Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,g2:GetCount(),0,0)
	end
end
function c9981532.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,0xc,tc)
		if tc:IsImmuneToEffect(e) or g:GetCount()<=0 then return end
		Duel.Destroy(g,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981532,2))
end