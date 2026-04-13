local s,id=GetID()
function s.initial_effect(c)
	local xyzfilter = function(c,xyz,sumtype,tp) 
		return c:IsSetCard(0x5f51,xyz,sumtype,tp) and c:GetLevel()>0 
	end
	local xyzcheck = function(g,tp,xyz) 
		return g:GetClassCount(Card.GetLevel)==1 
	end
	if Xyz and Xyz.AddProcedure then
		Xyz.AddProcedure(c,xyzfilter,nil,2,2,nil,nil,nil,nil,xyzcheck)
	else
		aux.AddXyzProcedureLevelFree(c,xyzfilter,xyzcheck,2,2)
	end	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)   
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id+1)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)	
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		local code = tc:GetCode()
		Duel.RegisterFlagEffect(0,code+1,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1,code+1,RESET_PHASE+PHASE_END,0,1)
	end
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,0x5f51)
		and Duel.IsExistingMatchingCard(function(c,e,tp) return c:IsSetCard(0x5f51) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end,tp,LOCATION_DECK,0,1,nil,e,tp) 
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,0x5f51)
		if #g>0 then
			local tc=g:GetFirst()
			if tc:IsFacedown() or tc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,tc) end
			if Duel.Destroy(tc,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=Duel.SelectMatchingCard(tp,function(c,e,tp) return c:IsSetCard(0x5f51) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end,tp,LOCATION_DECK,0,1,1,nil,e,tp)
				if #sg>0 then
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetOperation(s.delayed_th)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.delayed_th(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	e:Reset()
	local g=Duel.GetMatchingGroup(function(c) 
		return c:IsAbleToHand() and Duel.GetFlagEffect(tp,c:GetCode()+1)>0 
	end,tp,LOCATION_GRAVE,0,nil)  
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end