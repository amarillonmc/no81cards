--器灵符·灵魂共振
function c60153214.initial_effect(c)
	--1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60153214,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60153214)
	e1:SetCondition(c60153214.e1con)
	e1:SetTarget(c60153214.e1tg)
	e1:SetOperation(c60153214.e1op)
	c:RegisterEffect(e1)
	
	--2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60153214,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,6013214)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c60153214.e2tg)
	e2:SetOperation(c60153214.e2op)
	c:RegisterEffect(e2)
end

function c60153214.e1conf(c)
	return c:IsFaceup() and c:IsSetCard(0x3b2a)
end
function c60153214.e1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60153214.e1conf,tp,LOCATION_ONFIELD,0,1,nil)
end
function c60153214.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c60153214.e1op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		local tc=sg:GetFirst()
		if tc:IsLocation(LOCATION_GRAVE) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(0,1)
			e1:SetValue(c60153214.e1opl)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c60153214.e1opl(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end



function c60153214.e2tgf(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c60153214.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c60153214.e2tgf,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c60153214.e2tgf,tp,0,LOCATION_DECK,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
		and g:GetCount()>0 and g2:GetCount()>0 end
end
function c60153214.e2op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60153214.e2tgf,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c60153214.e2tgf,tp,0,LOCATION_DECK,nil)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
		and g:GetCount()>0 and g2:GetCount()>0 then 
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SSet(tp,sg)~=0 then
			local tc=sg:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e2:SetValue(LOCATION_DECKBOT)
			tc:RegisterEffect(e2,true)
		end
		
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
		local sg2=g2:Select(1-tp,1,1,nil)
		if Duel.SSet(1-tp,sg2)~=0 then
			local tc2=sg2:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e2:SetValue(LOCATION_DECKBOT)
			tc2:RegisterEffect(e2,true)
		end
	end
end