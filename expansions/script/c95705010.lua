--不屈之真红眼
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.totg)
	e2:SetOperation(s.toop)
	c:RegisterEffect(e2)
	--return replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(s.reptg)
	e3:SetValue(s.repval)
	c:RegisterEffect(e3)
end
function s.filter1(c,e,tp)
	return c:IsSetCard(0x3b) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(7)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) 
	   and Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function s.filter2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x3b) and c:IsType(TYPE_MONSTER)
end
function s.totg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
end
function s.toop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	if #g~=0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,s.tofilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if tg:GetCount()>0 and Duel.SendtoHand(tg,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function s.tofilter(c,e,tp)
	return c:IsSetCard(0x3b) and c:IsAbleToHand()
end
function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x3b)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re
		 and eg:IsExists(s.repfilter,1,nil,tp) end
	local reg=eg:Filter(s.repfilter,nil,tp)
	local undg=reg:Filter(Card.IsHasEffect,nil,EFFECT_INDESTRUCTABLE_BATTLE)
	if #undg>0 then
		reg:Sub(undg)
		local tc=undg:GetFirst()
		while tc do
			Duel.Hint(HINT_CARD,0,tc:GetOriginalCodeRule())
			tc=undg:GetNext()
		end
	end
	if #reg>0 then
		Duel.Destroy(reg,REASON_BATTLE)
		local desg=Duel.GetOperatedGroup()
		if #desg>0 then
			Duel.RaiseEvent(desg,EVENT_DESTROYED,e,REASON_BATTLE,tp,tp,Duel.GetCurrentChain())
			Duel.RaiseEvent(desg,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,Duel.GetCurrentChain())
			local tc=desg:GetFirst()
			while tc do
				Duel.RaiseSingleEvent(tc,EVENT_DESTROYED,e,REASON_BATTLE,tp,tp,Duel.GetCurrentChain())
				Duel.RaiseSingleEvent(tc,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp, tp,Duel.GetCurrentChain())
				tc=desg:GetNext()
			end
		end
	end
	if (#reg+#undg)==0 then return false end
	return true
end
function s.repval(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x3b)
end