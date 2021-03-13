--幻影狂风·暗魔
function c40009246.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,c40009246.mfilter,7,3,c40009246.ovfilter,aux.Stringid(40009246,0),3,c40009246.xyzop)   
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(2500)
	e2:SetCondition(c40009246.atkcon)
	c:RegisterEffect(e2) 
	--double
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e4:SetCondition(c40009246.atkcon)
	e4:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e4)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009246,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40009246)
	e1:SetCost(c40009246.tgcost)
	e1:SetTarget(c40009246.tgtg)
	e1:SetOperation(c40009246.tgop)
	c:RegisterEffect(e1)
end
function c40009246.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c40009246.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,40009249)
end
function c40009246.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40009246)==0 end
	Duel.RegisterFlagEffect(tp,40009246,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c40009246.atkcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,40009247)
end
function c40009246.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40009246.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c40009246.spfilter(c,e,tp)
	return c:IsSetCard(0xbf1d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009246.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40009246.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	if Duel.IsExistingMatchingCard(c40009246.filter,tp,LOCATION_MZONE,0,1,nil) then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(0)
	end
end
function c40009246.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(c40009246.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(40009246,1)) then
		local g1=Duel.GetMatchingGroup(c40009246.filter,tp,LOCATION_MZONE,0,nil)
		local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
		if #g1>0 and #g2>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg1=g1:Select(tp,1,#g2,nil)
			if Duel.SendtoGrave(sg1,REASON_EFFECT)~=0 and sg1:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
				local og1=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local ct=0
				if og1 and og1~=nil then
					ct=og1:GetCount()
					local sg2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,ct,ct,nil)
					Duel.SendtoGrave(sg2,REASON_EFFECT)
				end
			end
		end
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009246.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end






