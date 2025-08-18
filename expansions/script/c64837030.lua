--『乐队的主心骨』千早爱音
local s,id=GetID()
function s.initial_effect(c)
	  --
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
 Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return  c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)~=0
		and not Duel.IsExistingMatchingCard(Card.IsPublic,tp,LOCATION_HAND,0,1,nil) and Duel.GetCustomActivityCount(703897,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.PayLPCost(tp,2000)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
  local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE) + Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if chk==0 then return ft>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local ct=cg:GetCount()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and ct>1 then return end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft1<=0 and ft2<=0 then return end
	if ft2>ct then ft2=ct end
	local ct2=ct-ft1
	local tc=nil
	local ckg=Group.CreateGroup()
	if ft2>0 and (ct2>0 or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=cg:FilterSelect(tp,Card.IsCanBeSpecialSummoned,ct2,ft2,nil,e,0,tp,false,false,POS_FACEUP,1-tp)
		tc=sg1:GetFirst()
		cg:Sub(sg1)
		ct=ct-sg1:GetCount()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)
			ckg:AddCard(tc)
			tc=sg1:GetNext()
		end
	end
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=cg:Select(tp,ct,ct,nil)
		tc=sg2:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			ckg:AddCard(tc)
			tc=sg2:GetNext()
		end
	end
	Duel.SpecialSummonComplete()
	
	if (not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_MONSTER)) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,ckg) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,ckg)
			if g2:GetCount()>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
	end
end
function s.ckfilter(c,tc)
	return  c:GetLevel()==tc:GetLevel() or c:GetAttack()==tc:GetAttack() or c:GetDefense()==tc:GetDefense()
end
function s.thfilter(c,ckg)
	return c:IsAttribute(ATTRIBUTE_FIRE)  and c:IsAbleToHand() and (not ckg:IsExists(s.ckfilter,1,nil,c))
end










