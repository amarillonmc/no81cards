--电子化古典芭蕾短裙
local s,id,o=GetID()
function c98920889.initial_effect(c)
	--effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,id+o*2)
	e3:SetTarget(s.tg)
	e3:SetOperation(s.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)	
end
function s.schfilter(c)
	return c:IsSetCard(0x93) and c:IsRace(RACE_FAIRY) and c:IsAbleToHand()
end
function s.desfilter(c,e,tp)
	return c:IsSetCard(0x93) and c:IsRace(RACE_WARRIOR) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920889.cfilter(c,rit)
	return c:IsSetCard(0x124) and c:IsType(TYPE_SPELL)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.schfilter,tp,LOCATION_DECK,0,1,nil) 
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_DECK,0,1,nil,e,tp)) end
	local sel=0
	local ac=0
	if Duel.IsExistingMatchingCard(s.schfilter,tp,LOCATION_DECK,0,1,nil)  then sel=sel+1 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then sel=sel+2 end
	if sel==1 then
		ac=Duel.SelectOption(tp,aux.Stringid(98920889,0))
	elseif sel==2 then
		ac=Duel.SelectOption(tp,aux.Stringid(98920889,1))+1
	elseif Duel.IsExistingMatchingCard(c98920889.cfilter,tp,LOCATION_GRAVE,0,1,nil,true) then
		ac=Duel.SelectOption(tp,aux.Stringid(98920889,0),aux.Stringid(98920889,1),aux.Stringid(98920889,2))
	else
		ac=Duel.SelectOption(tp,aux.Stringid(98920889,0),aux.Stringid(98920889,1))
	end
	e:SetLabel(ac)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	if ac==0 or ac==2 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local g=Duel.SelectMatchingCard(tp,s.schfilter,tp,LOCATION_DECK,0,1,1,nil)
	   if g:GetCount()>0 then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
		end
	end
	if ac==1 or ac==2 then
	   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	   if g:GetCount()>0 then
		   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	 	end
	end
end