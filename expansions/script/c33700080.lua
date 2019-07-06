--动物朋友 河马
function c33700080.initial_effect(c)
	c33700080[c]={}
	local effect_list=c33700080[c]
	  --tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3841833,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33700080.cost)
	e1:SetTarget(c33700080.target)
	e1:SetOperation(c33700080.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetDescription(aux.Stringid(25165047,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	effect_list[5]=e2
	e2:SetCondition(c33700080.con)
	e2:SetTarget(c33700080.tg)
	e2:SetOperation(c33700080.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c33700080.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c33700080.thfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(33700080)
end
function c33700080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700080.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33700080.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700080.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c33700080.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c33700080.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return  re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c33700080.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c33700080.con(e,tp,eg,ep,ev,re,r,rp)
	  local g=Duel.GetMatchingGroup(c33700080.confilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=5  or e:GetLabel()==33700090 
end
function c33700080.desfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c33700080.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	 local g=Duel.GetMatchingGroup(c33700080.confilter,tp,LOCATION_GRAVE,0,nil) 
   if chk==0 then return true  end
	if   g:GetClassCount(Card.GetCode)>=5 then
 local sg=Duel.GetMatchingGroup(c33700080.desfilter,tp,0,LOCATION_ONFIELD,nil)
end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,1)
   if   g:GetClassCount(Card.GetCode)>=21 then
 local sg=Duel.GetMatchingGroup(c33700080.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
end
function c33700080.spfilter(c,e,tp)
	return c:IsSetCard(0x442) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700080.jfilter(c)
	return c:GetCode()==33700090 and c:IsFaceup() and not c:IsDisabled()
end
function c33700080.op(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c33700080.confilter,tp,LOCATION_GRAVE,0,nil) 
   if g:GetClassCount(Card.GetCode)>=5  or  e:GetLabel()==33700090 then
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local cg=Duel.SelectMatchingCard(tp,c33700080.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if cg:GetCount()>0 then
		Duel.SpecialSummon(cg,0,tp,tp,false,false,POS_FACEUP)
	end
end
   if g:GetClassCount(Card.GetCode)>=12  or  e:GetLabel()==33700090 then
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 or  Duel.GetMZoneCount(tp)<=0 then return end
	Duel.ConfirmDecktop(tp,1)
	local hg=Duel.GetDecktopGroup(tp,1)
	local tc=hg:GetFirst()
	 Duel.DisableShuffleCheck()
	if tc:IsSetCard(0x442) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
	 Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	  end  
end
	local sg=Duel.GetMatchingGroup(c33700080.desfilter,tp,0,LOCATION_ONFIELD,nil)
   if g:GetClassCount(Card.GetCode)>=21 and sg:GetCount()>0 then
	 Duel.Destroy(sg,REASON_EFFECT)
end
end