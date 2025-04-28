--三战之英
local s,id,o=GetID()
function c98921107.initial_effect(c)
	c:SetSPSummonOnce(id)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)	
	--activate effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,id+o)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.chainfilter(re,tp,cid)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(1-tp,id,RESET_PHASE+PHASE_END,0,1)
	end
	return not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,id)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c98921107.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c98921107.spfilter(c,e,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.IsExistingMatchingCard(c98921107.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	local g2=Duel.IsPlayerCanDiscardDeck(tp,5)
	local g3=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c98921107.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	if chk==0 then return g1 or g2 or g3 end
	e:SetCategory(0)
	local off=1
	local ops={}
	local opval={}
	if g1 then
		ops[off]=aux.Stringid(id,2)
		opval[off]=0
		off=off+1
	end
	if g2 then
		ops[off]=aux.Stringid(id,3)
		opval[off]=1
		off=off+1
	end
	if g3 then
		ops[off]=aux.Stringid(id,4)
		opval[off]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_TOHAND)
		local sg=Duel.GetMatchingGroup(c98921107.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
	elseif sel==1 then
		e:SetCategory(CATEGORY_TOHAND)
	elseif sel==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		local sg=Duel.GetMatchingGroup(c98921107.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	elseif sel==1 then
		if Duel.IsPlayerCanDiscardDeck(tp,5) then
		   Duel.ConfirmDecktop(tp,5)
		   local g=Duel.GetDecktopGroup(tp,5)
		   if g:GetCount()>0 then
			   Duel.DisableShuffleCheck()
			   if g:IsExists(aux.TRUE,1,nil) then
				   Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
				   local sg=g:Select(1-tp,1,1,nil)
				   Duel.SendtoHand(sg,nil,REASON_EFFECT)
				   Duel.ConfirmCards(1-tp,sg)
				   Duel.ShuffleHand(tp)
				   g:Sub(sg)
			   end
			   Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
			end
		 end
	elseif sel==2 then
		 if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		 local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98921107.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		 if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		 end
	end
end