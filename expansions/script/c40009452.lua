--古代龙的苏醒
function c40009452.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c40009452.miltg)
	e1:SetOperation(c40009452.milop)
	c:RegisterEffect(e1)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009452,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,40009452)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c40009452.target)
	e3:SetOperation(c40009452.operation)
	c:RegisterEffect(e3)
end
function c40009452.miltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c40009452.spfilter(c,e,tp)
	return c:IsRace(RACE_DINOSAUR) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)
end
function c40009452.milfilter(c)
	return c:IsRace(RACE_DINOSAUR)
end
function c40009452.milop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:Filter(Card.IsRace,nil,RACE_DINOSAUR)
	if g:GetCount()>0 then
		if ct:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40009452,0)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.DisableShuffleCheck()
			local tg=Duel.SelectMatchingCard(tp,c40009452.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			local tc=tg:GetFirst()
			Duel.SendtoGrave(ct,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL+REASON_RELEASE)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
			tc:RegisterFlagEffect(40009452,RESET_EVENT+RESETS_STANDARD,0,1)
			local atk=ct:GetSum(Card.GetAttack)
			local def=ct:GetSum(Card.GetDefense)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+0xff0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(def)
			e2:SetReset(RESET_EVENT+0xff0000)
			tc:RegisterEffect(e2)
			tc:CompleteProcedure()
		end
	end
	Duel.SortDecktop(tp,tp,5-ct:GetCount())
	for i=1,5-ct:GetCount() do
		local mg=Duel.GetDecktopGroup(tp,1)
		Duel.MoveSequence(mg:GetFirst(),1)
	end
end
function c40009452.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsReleasableByEffect()
end
function c40009452.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.CheckReleaseGroupEx(tp,c40009452.filter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c40009452.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDraw(tp) then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then ct=1 end
	if ct>2 then ct=2 end
	local g=Duel.SelectReleaseGroupEx(tp,c40009452.filter,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local rct=Duel.Release(g,REASON_EFFECT)
		Duel.Draw(tp,rct,REASON_EFFECT)
	end
end