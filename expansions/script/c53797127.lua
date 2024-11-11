local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.spfilter(c,e,sp)
	return c:IsSetCard(0x30) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if #cg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=cg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.cfilter(c,code)
	return c:IsCode(code) and c:IsFaceupEx()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()~=1 then return false end
	local tc=eg:GetFirst()
	return tc:IsFaceup() and tc:IsRace(RACE_FAIRY) and tc:IsSetCard(0x30) and not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,tc,tc:GetCode())
end
function s.thfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function s.spsfilter(c,e,tp)
	return c:IsSetCard(0x30) and c:IsType(TYPE_EQUIP) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPE_MONSTER+TYPE_NORMAL+TYPE_TUNER,0,0,1,RACE_MACHINE,ATTRIBUTE_LIGHT) 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	local b1=tc:IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=not tc:IsType(TYPE_SYNCHRO) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spsfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	if b1 then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetLabel(2)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif e:GetLabel()==2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.spsfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if tc then
			tc:AddMonsterAttribute(TYPE_NORMAL+TYPE_TUNER,ATTRIBUTE_LIGHT,RACE_MACHINE,1,0,0)
			if Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE,EFFECT_FLAG2_WICKED)
				e1:SetValue(s.lv)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				tc:RegisterEffect(e1,true)
				Duel.SpecialSummonComplete()
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(id)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				tc:RegisterEffect(e2)
			end
		end
	end
end
function s.filter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function s.lv(e,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,c)
	if #g<=0 then return 1 end
	if g:IsExists(Card.IsHasEffect,1,nil,id) then return 1 end
	local _,lv=g:GetMinGroup(Card.GetLevel)
	lv=lv-1
	if lv<=0 then lv=1 end
	return lv
end
