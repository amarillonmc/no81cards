--皇家黑魔术师
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,46986414,id)
	--spsummon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.sprcon)
	e1:SetTarget(s.sprtg)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)	
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE,EFFECT_FLAG2_WICKED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.adval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e3)
	--check
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(21208154)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
end
function s.cfilter(c,tp,f)
	return f(c) and Duel.GetMZoneCount(tp,c)>0 and aux.IsCodeOrListed(c,46986414)
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if c:IsLocation(LOCATION_GRAVE) and c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,c,tp,Card.IsAbleToDeckAsCost)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,0,c,tp,Card.IsAbleToDeckAsCost)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	if tc:IsFacedown() then
		Duel.ConfirmCards(1-tp,tc)
	end
	Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_SPSUMMON)
end
function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and not c:IsCode(id) and not c:IsHasEffect(21208154)
end
function s.adval(e,c)
	local g=Duel.GetMatchingGroup(s.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then
		return 100
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		return val+100
	end
end

function s.spfilter(c,e,tp)
	return aux.IsCodeOrListed(c,46986414) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spselect(g,atk)
	return g:GetSum(Card.GetAttack)<=atk and aux.dncheck(g)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ct>0 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		return ct>0 and g:CheckSubGroup(s.spselect,1,ct,c:GetAttack()) and c:IsAbleToRemove() 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,tp,LOCATION_MZONE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<=0 then return end
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		if #g==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,s.spselect,false,1,ct,c:GetAttack())
		if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.BreakEffect()
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		end
	end
end