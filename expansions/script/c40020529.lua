--空创天马
local s,id=GetID()
s.named_with_HighEvo=1

function s.HighEvo(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_HighEvo
end

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end

function s.thfilter(c)
	return s.HighEvo(c) 
		and not c:IsCode(40020509) 
		and not c:IsCode(id) 
		and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,2100,1800,5,RACE_BEAST,ATTRIBUTE_LIGHT)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			
			if not c:IsRelateToEffect(e) then return end
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			if not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,2100,1800,5,RACE_BEAST,ATTRIBUTE_LIGHT) then return end
			
			c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
			if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)>0 then
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(aux.Stringid(id,1))
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EFFECT_SEND_REPLACE)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCountLimit(1)
				e2:SetTarget(s.reptg)
				e2:SetValue(s.repval)
				e2:SetOperation(s.repop)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e2,true)
				c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
			end
		end
	end
end

function s.repfilter(c,tp,re)
	return c:IsControler(tp) 
		and c:IsLocation(LOCATION_MZONE) 
		and c:IsFaceup() 
		and c:IsType(TYPE_TRAP) and c:IsType(TYPE_MONSTER)
		and c:GetDestination()==LOCATION_GRAVE 
		and c:GetReasonPlayer()==1-tp 
		and c:IsReason(REASON_EFFECT)
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()

	local g=eg:Filter(s.repfilter,nil,tp,re):Filter(aux.TRUE,c)
	if chk==0 then return g:GetCount()>0 end
	
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local container=g:Clone()
		container:KeepAlive()
		e:SetLabelObject(container)
		return true
	else
		return false
	end
end

function s.repval(e,c)
	local g=e:GetLabelObject()
	return g and g:IsContains(c)
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,id)
	local tc=g:GetFirst()
	while tc do
		Duel.SSet(tp,tc)
		tc=g:GetNext()
	end
	g:DeleteGroup()
end