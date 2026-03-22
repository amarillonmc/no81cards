---圣赎·逆命神子
local s,id=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DECKDES+CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(id)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCondition(s.condition)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetTargetRange(0,1)
	e5:SetCondition(aux.NOT(s.condition))
	c:RegisterEffect(e5)
end
function s.tgfilter(c,tp)
	return Duel.GetMZoneCount(c:GetControler(),c,tp)>0 and c:IsAbleToGrave()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and s.tgfilter(chkc,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE)
		and Duel.GetLocationCount(tc:GetPreviousControler(),LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tc:GetPreviousControler(),false,false,POS_FACEUP)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(s.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END, 2)
	Duel.RegisterEffect(e3,tp)
end 
function s.splimit(e,c)
	return not (c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT)) and not c:IsLocation(LOCATION_EXTRA)
end
function s.thfilter(c)
	return c:IsSetCard(0x9f0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x9f0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		local b1=Duel.IsExistingMatchingCard(s.thfilter,c:GetOwner(),LOCATION_DECK,0,1,nil)
			and Duel.GetFlagEffect(c:GetOwner(),10485000+1)==0
		local b2=Duel.IsExistingMatchingCard(s.spfilter,c:GetOwner(),LOCATION_DECK,0,1,nil,e,c:GetOwner())
			and Duel.GetLocationCount(c:GetOwner(),LOCATION_MZONE)>0
			and Duel.GetFlagEffect(c:GetOwner(),10485000+2)==0
		local b3=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,c:GetOwner(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			and Duel.GetFlagEffect(c:GetOwner(),10485000+3)==0
		local b4=Duel.IsExistingMatchingCard(aux.NegateAnyFilter,c:GetOwner(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			and Duel.GetFlagEffect(c:GetOwner(),10485000+4)==0
		if (b1 or b2 or b3 or b4) then
			local op=aux.SelectFromOptions(c:GetOwner(),
				{b1,aux.Stringid(10485000,3)},
				{b2,aux.Stringid(10485000,4)},
				{b3,aux.Stringid(10485000,5)},
				{b4,aux.Stringid(10485000,6)})
			if op==1 then
				Duel.Hint(HINT_SELECTMSG,c:GetOwner(),HINTMSG_ATOHAND)
				local tg=Duel.SelectMatchingCard(c:GetOwner(),s.thfilter,c:GetOwner(),LOCATION_DECK,0,1,1,nil)
				if #tg>0 then
					Duel.RegisterFlagEffect(c:GetOwner(),10485000+op,RESET_PHASE|PHASE_END,0,1)
					Duel.BreakEffect()
					Duel.SendtoHand(tg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-c:GetOwner(),tg)
				end
			end
			if op==2 then
				Duel.Hint(HINT_SELECTMSG,c:GetOwner(),HINTMSG_SPSUMMON)
				local sg=Duel.SelectMatchingCard(c:GetOwner(),s.spfilter,c:GetOwner(),LOCATION_DECK,0,1,1,nil,e,c:GetOwner())
				if #sg>0 then
					Duel.RegisterFlagEffect(c:GetOwner(),10485000+op,RESET_PHASE|PHASE_END,0,1)
					Duel.BreakEffect()
					Duel.SpecialSummon(sg,0,c:GetOwner(),c:GetOwner(),false,false,POS_FACEUP)
				end
			end
			if op==3 then
				Duel.Hint(HINT_SELECTMSG,c:GetOwner(),HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(c:GetOwner(),Card.IsAbleToGrave,c:GetOwner(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
				if #g>0 then
					Duel.RegisterFlagEffect(c:GetOwner(),10485000+op,RESET_PHASE|PHASE_END,0,1)
					Duel.BreakEffect()
					Duel.HintSelection(g)
					Duel.SendtoGrave(g,REASON_EFFECT)
				end
			end
			if op==4 then
				Duel.Hint(HINT_SELECTMSG,c:GetOwner(),HINTMSG_DISABLE)
				local tc=Duel.SelectMatchingCard(c:GetOwner(),aux.NegateAnyFilter,c:GetOwner(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
				if tc and  tc:IsCanBeDisabledByEffect(e) then
					Duel.RegisterFlagEffect(c:GetOwner(),10485000+op,RESET_PHASE|PHASE_END,0,1)
					Duel.BreakEffect()
					Duel.HintSelection(Group.FromCards(tc))
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
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
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetControler()==c:GetOwner()
end