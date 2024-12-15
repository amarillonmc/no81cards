--战华史略-火烧赤壁
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(s.target)
	c:RegisterEffect(e0)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.stgcon)
	e1:SetOperation(s.stgop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
end
function s.stgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.stgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function s.filter(c)
	return c:IsSetCard(0x137) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.setfilter(c,e,tp)
	return (c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp)) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0)
			and c:IsSSetable(true))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.ShuffleHand(tp)
		if #sg>0 then
			local sc=sg:GetFirst()
			if sc:IsType(TYPE_MONSTER) then
				Duel.BreakEffect()
				Duel.SpecialSummon(sc,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,sc)
				--Duel.ConfirmCards(tp,sc)
			else
				Duel.BreakEffect()
				Duel.SSet(tp,sc,1-tp)
			end
		end
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desfilter(c,dc,tp)
	local x1,y1=s.xylabel(c,tp)
	local x2,y2=s.xylabel2(dc,tp)
	return (x1==x2 and math.abs(y1-y2)==1) or (y1==y2 and math.abs(x1-x2)==1)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local desg=Group.CreateGroup()
		if #og>0 then 
			for dc in aux.Next(og) do
				local desg2=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil,dc,tp)
				desg:Merge(desg2)
			end
		end
		while desg:GetCount()>0 do
			Duel.BreakEffect()
			Duel.HintSelection(desg)
			if Duel.Destroy(desg,REASON_EFFECT)==0 then return end
			og=Duel.GetOperatedGroup()
			desg=Group.CreateGroup()
			if #og>0 then 
				for dc in aux.Next(og) do
					local desg2=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil,dc,tp)
					desg:Merge(desg2)
				end
			end
		end
	end
end
function s.xylabel(c,tp)
	local x=c:GetSequence()
	local y=0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then y=0
		else x,y=-1,1 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then x,y=4-x,4
		else x,y=5,3 end
	end
	return x,y
end
function s.xylabel2(c,tp)
	local x=c:GetPreviousSequence()
	local y=0
	if c:GetPreviousControler()==tp then
		if c:IsPreviousLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsPreviousLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsPreviousLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		elseif c:IsPreviousLocation(LOCATION_SZONE) and x<=4 then y=0
		else x,y=-1,1 end
	elseif c:GetPreviousControler()==1-tp then
		if c:IsPreviousLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsPreviousLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsPreviousLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		elseif c:IsPreviousLocation(LOCATION_SZONE) and x<=4 then x,y=4-x,4
		else x,y=5,3 end
	end
	return x,y
end
