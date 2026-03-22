--圣赎·救赎圣女
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DECKDES+CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.pentg)
	e1:SetOperation(s.penop)
	c:RegisterEffect(e1)	
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	c:RegisterEffect(e2)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil,POS_FACEDOWN)
	local b2=Duel.IsPlayerAffectedByEffect(tp,10485010) and Duel.CheckLPCost(tp,500)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(10485000,1)},
		{b2,aux.Stringid(10485000,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil,POS_FACEDOWN)
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	else
		Duel.PayLPCost(tp,500)
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x9f0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x9f0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.penfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x9f0) and c:IsType(TYPE_PENDULUM) and not c:IsCode(id) and not c:IsForbidden()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFlagEffect(tp,10485000+1)==0
	local b2=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFlagEffect(tp,10485000+2)==0
	local b3=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
		and Duel.GetFlagEffect(tp,10485000+3)==0
	local b4=Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
		and Duel.GetFlagEffect(tp,10485000+4)==0
	if chk==0 then return c:IsDestructable()
		and Duel.IsExistingMatchingCard(s.penfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
		and (b1 or b2 or b3 or b4)  end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local pc=Duel.SelectMatchingCard(tp,s.penfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil):GetFirst()
		if pc and Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
			local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
				and Duel.GetFlagEffect(tp,10485000+1)==0
			local b2=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
				and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.GetFlagEffect(tp,10485000+2)==0
			local b3=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
				and Duel.GetFlagEffect(tp,10485000+3)==0
			local b4=Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
				and Duel.GetFlagEffect(tp,10485000+4)==0
			if (b1 or b2 or b3 or b4) then
				local op=aux.SelectFromOptions(tp,
					{b1,aux.Stringid(10485000,3)},
					{b2,aux.Stringid(10485000,4)},
					{b3,aux.Stringid(10485000,5)},
					{b4,aux.Stringid(10485000,6)})
				if op==1 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local tg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
					if #tg>0 then
						Duel.RegisterFlagEffect(tp,10485000+op,RESET_PHASE|PHASE_END,0,1)
						Duel.BreakEffect()
						Duel.SendtoHand(tg,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,tg)
					end
				end
				if op==2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
					if #sg>0 then
						Duel.RegisterFlagEffect(tp,10485000+op,RESET_PHASE|PHASE_END,0,1)
						Duel.BreakEffect()
						Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
					end
				end
				if op==3 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
					if #g>0 then
						Duel.RegisterFlagEffect(tp,10485000+op,RESET_PHASE|PHASE_END,0,1)
						Duel.BreakEffect()
						Duel.HintSelection(g)
						Duel.SendtoGrave(g,REASON_EFFECT)
					end
				end
				if op==4 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
					local tc=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
					if tc and  tc:IsCanBeDisabledByEffect(e) then
						Duel.RegisterFlagEffect(tp,10485000+op,RESET_PHASE|PHASE_END,0,1)
						Duel.BreakEffect()
						Duel.HintSelection(Group.FromCards(tc))
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_DISABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e1)
						local e2=Effect.CreateEffect(c)
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetCode(EFFECT_DISABLE_EFFECT)
						e2:SetValue(RESET_TURN_SET)
						e2:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e2)
					end
				end
			end
		end
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(s.splimit)
	e3:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e3,tp)
end 
function s.splimit(e,c)
	return not (c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT)) and not c:IsLocation(LOCATION_EXTRA)
end

function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0x9f0) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp)
		and e:GetHandler():IsAbleToExtra() end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.SendtoExtraP(e:GetHandler(),nil,REASON_EFFECT)
		return true
	end
	return false
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
