--交织的悲愿
function c33400470.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_COUNTER+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400470+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c33400470.condition)
	e1:SetTarget(c33400470.target)
	e1:SetOperation(c33400470.activate)
	c:RegisterEffect(e1)
end
function c33400470.cnfilter(c)
	return c:IsSetCard(0x3341) or c:IsSetCard(0x5342) and c:IsType(TYPE_MONSTER)
end
function c33400470.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33400470.cnfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c33400470.cnfilter1(c)
	return c:IsSetCard(0x3341)  and c:IsType(TYPE_MONSTER)
end
function c33400470.cnfilter2(c)
	return  c:IsSetCard(0x5342) and c:IsType(TYPE_MONSTER)
end
function c33400470.cnfilter10(c,e,tp)
	return c:IsSetCard(0x3341)  and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400470.cnfilter20(c,e,tp)
	return c:IsSetCard(0x5342)  and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400470.cnfilter11(c)
	return c:IsSetCard(0x3340)  and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c33400470.cnfilter210(c,tc)
	return c:IsSetCard(0x6343)  and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c33400470.cnfilter211(c)
	return c:IsSetCard(0x6343)  and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c33400470.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400470.cnfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c33400470.activate(e,tp,eg,ep,ev,re,r,rp)
   if not Duel.IsExistingMatchingCard(c33400470.cnfilter,tp,LOCATION_MZONE,0,1,nil) then return end
   local g1=Duel.GetMatchingGroupCount(c33400470.cnfilter1,tp,LOCATION_MZONE,0,nil)
   local g2=Duel.GetMatchingGroupCount(c33400470.cnfilter2,tp,LOCATION_MZONE,0,nil)
   local g3=Duel.GetLocationCount(tp,LOCATION_MZONE)
   local g10=Duel.GetMatchingGroup(c33400470.cnfilter10,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
   local g20=Duel.GetMatchingGroup(c33400470.cnfilter20,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
   local op
   if g1>0 and  g2==0 then
	   if g3 and g20 then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		   local g4=g20:Select(tp,1,1,nil)
		   if Duel.SpecialSummon(g4,0,tp,tp,false,false,POS_FACEUP) then 
			  if   Duel.SelectYesNo(tp,aux.Stringid(33400470,5)) then 
				 local tc=g4:GetFirst()
				 local pg210=Duel.GetMatchingGroupCount(c33400470.cnfilter210,tp,LOCATION_GRAVE,0,nil,tc)
				 local pg211=Duel.GetMatchingGroupCount(c33400470.cnfilter211,tp,LOCATION_GRAVE,0,nil) 
				 local g210=Duel.GetMatchingGroup(c33400470.cnfilter210,tp,LOCATION_GRAVE,0,nil,tc)
				 local g211=Duel.GetMatchingGroup(c33400470.cnfilter211,tp,LOCATION_GRAVE,0,nil)
				 if  pg210==0 and  pg211==0 then return end
				 if pg210>0 and pg211>0 then 
					 op=Duel.SelectOption(tp,aux.Stringid(33400470,0),aux.Stringid(33400470,3))
				 end
				 if  pg210>0 and pg211==0 then 
					  op=0					 
				 end
				 if pg210==0 and pg211>0 then  
					   op=1					  
				 end
				 if op==0 then
					 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
					local g5=g210:Select(tp,1,1,nil)
					local ec1=g5:GetFirst()   
					 Duel.Equip(tp,ec1,tc)
				 end
				 if op==1 then 
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local g6=g211:Select(tp,1,1,nil)
					Duel.SendtoHand(g6,tp,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g6)
				 end
			  end
		   end
	   end
   end 
   if g1==0 and g2>0 then 
	   if g3>0 and g10 then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		   local g4=g10:Select(tp,1,1,nil)
		   if Duel.SpecialSummon(g4,0,tp,tp,false,false,POS_FACEUP) then 
				 local g11=Duel.GetMatchingGroup(c33400470.cnfilter11,tp,LOCATION_GRAVE,0,nil)
				 if g11 then
					if Duel.SelectYesNo(tp,aux.Stringid(33400470,1)) then		   
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local g6=g11:Select(tp,1,1,nil)
					Duel.SendtoHand(g6,tp,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g6)
					end
				 end
		   end
	   end
   end
   if g1>0 and g2>0 then 
		local g22=Duel.GetMatchingGroup(c33400470.cnfilter2,tp,LOCATION_MZONE,0,nil)
		local tc=g22:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			e4:SetValue(0)
			tc:RegisterEffect(e4)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			e3:SetValue(0)
			tc:RegisterEffect(e3)
			tc=g22:GetNext()
		end
		 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400470,4))
		 local tc1=Duel.SelectMatchingCard(tp,c33400470.filter4,tp,LOCATION_ONFIELD,0,1,1,nil,g2)
		 tc2=tc1:GetFirst()
		 tc2:AddCounter(0x34f,5*g2)
		 local g33=Duel.GetMatchingGroup(c33400470.filter5,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		 local pg33=Duel.GetMatchingGroupCount(c33400470.filter5,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		 if pg33>0 then 
			 if Duel.SelectYesNo(tp,aux.Stringid(33400470,2)) then 
				 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local g7=g33:Select(tp,1,1,nil)
					Duel.SendtoHand(g7,tp,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g7)
			 end
		 end
		 
   end 
end
function c33400470.filter4(c,n)
	return c:IsFaceup() and c:IsCanAddCounter(0x34f,5*n)
end
function c33400470.filter5(c)
	return c:IsCode(33400112)
end