--热炎异种捕捞
function c33332266.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,33332266)
	e2:SetTarget(c33332266.target)
	e2:SetOperation(c33332266.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33432266,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CUSTOM+33332266)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,33432266)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetTarget(c33332266.sptg1)
	e3:SetOperation(c33332266.spop1)
	c:RegisterEffect(e3)
end
function c33332266.filter(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_FISH) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33332266.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c33332266.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33332266.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c33332266.lpfilter(c,tp)
	return c:IsAbleToHand() and Duel.CheckLPCost(tp,c:GetDefense())
end
function c33332266.fselect(g)
	return g:GetSum(Card.GetAttack)<=tp:GetLP()
end
function c33332266.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 or (g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if g:GetCount()<=ft then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if g:Filter(c33332266.lpfilter,nil,1-tp):GetCount()>=1 and Duel.SelectYesNo(1-tp,aux.Stringid(33332266,2)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local sc=g:Select(1-tp,1,1,nil)
			local tk=Duel.SendtoHand(sc,1-tp,REASON_EFFECT)
			Duel.PayLPCost(1-tp,sc:GetSum(Card.GetTextDefense))
			Duel.RaiseEvent(c,EVENT_CUSTOM+33332266,re,r,rp,ep,ev)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ft,ft,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		if sg:Filter(c33332266.lpfilter,nil,1-tp):GetCount()>=1 and Duel.SelectYesNo(1-tp,aux.Stringid(33332266,2)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local sc=sg:SelectSubGroup(1-tp,c33332266.fselect,false,1,1,1-tp)
			sc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
			local tk=Duel.SendtoHand(sc,1-tp,REASON_EFFECT)
			Duel.PayLPCost(1-tp,sc:GetSum(Card.GetTextDefense))
			Duel.RaiseEvent(c,EVENT_CUSTOM+33332266,re,r,rp,ep,ev,tk)
		end
		g:Sub(sg)
		Duel.SendtoGrave(g,REASON_RULE)
	end
end
function c33332266.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc,tk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,33332258,0x5552,TYPES_TOKEN_MONSTER,0,0,1,RACE_AQUA,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	e:SetLabel(tk)
end
function c33332266.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tk=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33332258,0x5552,TYPES_TOKEN_MONSTER,0,0,1,RACE_AQUA,ATTRIBUTE_FIRE) then
		local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),tk)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local ct=1
		if ft>1 then
			local num={}
			local i=1
			while i<=ft do
				num[i]=i
				i=i+1
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33332266,6))
			ct=Duel.AnnounceNumber(tp,table.unpack(num))
		end
		repeat
			local token=Duel.CreateToken(tp,33332258)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			ct=ct-1
		until ct==0
	end
end