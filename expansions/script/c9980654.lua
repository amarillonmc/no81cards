--假面驾驭·帝骑-完全形态
function c9980654.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,99,c9980654.lcheck)
	c:EnableReviveLimit()
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980654.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9980654.atkval)
	c:RegisterEffect(e1)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetDescription(aux.Stringid(9980654,1))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9980654.eqtg)
	e1:SetOperation(c9980654.eqop)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980654,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,9980654)
	e1:SetCost(c9980654.spcost)
	e1:SetTarget(c9980654.sptg)
	e1:SetOperation(c9980654.spop)
	c:RegisterEffect(e1)
	--reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c9980654.rdcon)
	e3:SetOperation(c9980654.rdop)
	c:RegisterEffect(e3)
end
function c9980654.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980654,2))
end 
function c9980654.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c9980654.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c9980654.atkval(e,c)
	local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil)
	return g:GetSum(Card.GetBaseAttack)
end
function c9980654.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xbca)
end
function c9980654.filter(c)
	return c:IsRace(RACE_WARRIOR) and not c:IsForbidden()
end
function c9980654.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9980654.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c9980654.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9980654.filter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,true) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c9980654.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(500)
		tc:RegisterEffect(e2)
	end
   Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980654,3))
end
function c9980654.eqlimit(e,c)
	return e:GetOwner()==c
end
function c9980654.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9980654.spfilter(c,e,tp)
	return c:IsSetCard(0x9bcd) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c9980654.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c9980654.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
	if e:GetHandler():GetMutualLinkedGroupCount()>0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
		e:SetLabel(2)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(0)
	end
end
function c9980654.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9980654.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)~=0
		and e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,2)
		and Duel.SelectYesNo(tp,aux.Stringid(9980654,4)) then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	end
end