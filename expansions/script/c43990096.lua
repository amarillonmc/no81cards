--N公司的圣典诵读
local m=43990096
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,43990096+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c43990096.target)
	e1:SetOperation(c43990096.activate)
	c:RegisterEffect(e1)
end
function c43990096.filter(c)
	return not c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function c43990096.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990096.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c43990096.stfilter(c,e,tp)
	return c:IsSetCard(0x3510) and not c:IsCode(43990096) and ((c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)) or (c:IsType(TYPE_FIELD) or (c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable(true))))
end
function c43990096.gcheck(g,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:Filter(Card.IsType,nil,TYPE_MONSTER):GetCount() and Duel.GetLocationCount(tp,LOCATION_SZONE)>=(g:Filter(Card.IsType,nil,0x6):GetCount()-g:Filter(Card.IsType,nil,TYPE_FIELD):GetCount())
end
function c43990096.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c43990096.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	local aa=0
	while tc and not tc:IsImmuneToEffect(e) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_MACHINE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			aa=aa+1
		tc=g:GetNext()
	end
	local bb=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-aa
	local g2=Duel.GetMatchingGroup(c43990096.stfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if aa>0 and g2:CheckSubGroup(c43990096.gcheck,bb,bb,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(43990096,2)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			Duel.BreakEffect()
	local sg=g2:SelectSubGroup(tp,c43990096.gcheck,false,bb,bb,e,tp)
	local sgmg=sg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local sgsg=sg:Filter(Card.IsType,nil,0x6)
	if sgmg:GetCount()>0 then
			Duel.SpecialSummon(sgmg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
	if sgsg:GetCount()>0 and Duel.SSet(tp,sgsg)~=0 then
		 local sgsgc=sgsg:GetFirst()
		 while sgsgc do
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetDescription(aux.Stringid(22348163,0))
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			 e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			 sgsgc:RegisterEffect(e1)
			 sgsgc=sgsg:GetNext()
		 end
	end
			Duel.ConfirmCards(1-tp,sg)
   end
end