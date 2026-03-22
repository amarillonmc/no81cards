--圣赎·罪堕之龙
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99) 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DECKDES+CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.mattg)
	e1:SetOperation(s.matop)
	c:RegisterEffect(e1)  
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.ofilter(c,e)
	return c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e))
end
function s.thfilter(c)
	return c:IsSetCard(0x9f0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x9f0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFlagEffect(tp,10485000+1)>=1
	local b2=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFlagEffect(tp,10485000+2)>=1
	local b3=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.GetFlagEffect(tp,10485000+3)>=1
	local b4=Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.GetFlagEffect(tp,10485000+4)>=1
	if chk==0 then return c:IsType(TYPE_XYZ) 
		and Duel.IsExistingMatchingCard(s.ofilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
		and (b1 or b2 or b3 or b4) end
end
function s.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,s.ofilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,2,nil,e)
		if g and #g>0 then
			Duel.Overlay(c,g)
			local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
				and Duel.GetFlagEffect(tp,10485000+1)>=1
			local b2=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
				and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.GetFlagEffect(tp,10485000+2)>=1
			local b3=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
				and Duel.GetFlagEffect(tp,10485000+3)>=1
			local b4=Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
				and Duel.GetFlagEffect(tp,10485000+4)>=1
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
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_GRAVE,0,4,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_GRAVE,0,4,4,e:GetHandler())
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end