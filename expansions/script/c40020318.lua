--觉龙的神托
local s,id=GetID()
s.named_with_AwakenedDragon=1

function s.AwakenedDragon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_AwakenedDragon
end

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.thfilter(c)
	return s.AwakenedDragon(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.rmfilter(c)
	return s.AwakenedDragon(c) and not c:IsCode(id) and c:IsAbleToRemove()
end

function s.spfilter(c,e,tp)
	return c:IsFaceup() and s.AwakenedDragon(c) and c:IsType(TYPE_MONSTER) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)

	local b1 = Duel.GetFlagEffect(tp,id)==0 
			   and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
			   
	local b2 = Duel.GetFlagEffect(tp,id+1)==0 
			   and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
			   
	local b3 = Duel.GetFlagEffect(tp,id+2)==0 
			   and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			   and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
			   
	if chk==0 then return b1 or b2 or b3 end
	
	local op=0
	local off=1
	local ops={}
	local opval={}
	
	if b1 then
		ops[off]=aux.Stringid(id,1) 
		opval[off]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,2)
		opval[off]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(id,3) 
		opval[off]=3
		off=off+1
	end
	
	local sel=Duel.SelectOption(tp,table.unpack(ops))+1
	op=opval[sel]
	e:SetLabel(op)
	
	if op==1 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	else
		Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
		
	elseif op==3 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end