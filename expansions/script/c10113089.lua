--光与影的牵绊
function c10113089.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10113089+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10113089.target)
	e1:SetOperation(c10113089.activate)
	c:RegisterEffect(e1)	
end
function c10113089.filter1(c,e,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(c10113089.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel(),c:GetRace(),ATTRIBUTE_DARK)
end
function c10113089.filter2(c,e,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and Duel.IsExistingMatchingCard(c10113089.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel(),c:GetRace(),ATTRIBUTE_LIGHT)
end
function c10113089.spfilter(c,e,tp,lv,race,att)
	return c:GetLevel()==lv and c:IsRace(race) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10113089.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and (c10113089.filter1(chkc,e,tp) or c10113089.filter2(chkc,e,tp)) end
	if chk==0 then return (Duel.IsExistingTarget(c10113089.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) or Duel.IsExistingTarget(c10113089.filter2,tp,LOCATION_MZONE,0,1,nil,e,tp)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local op,g=0
	Duel.Hint(HINT_SELECTMSG,tp,550)
	if Duel.IsExistingTarget(c10113089.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingTarget(c10113089.filter2,tp,LOCATION_MZONE,0,1,nil,e,tp) then
	   op=Duel.SelectOption(tp,aux.Stringid(10113089,0),aux.Stringid(10113089,1))
	elseif Duel.IsExistingTarget(c10113089.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) then
	   op=Duel.SelectOption(tp,aux.Stringid(10113089,0))
	else 
	   Duel.SelectOption(tp,aux.Stringid(10113089,1))
	   op=1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	if op==0 then
		g=Duel.SelectTarget(tp,c10113089.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	else
		g=Duel.SelectTarget(tp,c10113089.filter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	end
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10113089.activate(e,tp,eg,ep,ev,re,r,rp)
	local c,tc,op,g=e:GetHandler(),Duel.GetFirstTarget(),e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if op==0 then
	   g=Duel.SelectMatchingCard(tp,c10113089.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetLevel(),tc:GetRace(),ATTRIBUTE_DARK)
	else
	   g=Duel.SelectMatchingCard(tp,c10113089.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetLevel(),tc:GetRace(),ATTRIBUTE_LIGHT)
	end
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
