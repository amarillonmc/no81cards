--好多可怕的Bug啊
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.GetCardsInZone(tp,fd)
	if fd==0x400020 then return Duel.GetFieldCard(tp,LOCATION_MZONE,5) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) end
	if fd==0x200040 then return Duel.GetFieldCard(tp,LOCATION_MZONE,6) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) end
	local seq=math.log(fd,2)
	local p=tp
	if seq>=16 then
		p=1-tp
		seq=seq-16
	end
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	return Duel.GetFieldCard(p,loc,math.floor(seq+0.5))
end
function cm.mzlock(tp,seq,usep)
	local mzc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq)
	local fd=0
	if mzc then fd=Duel.GetMZoneCount(tp,mzc,usep,LOCATION_REASON_TOFIELD,1<<seq) end
	return ((not mzc and not Duel.CheckLocation(tp,LOCATION_MZONE,seq)) or (mzc and fd==0)),mzc
end
function cm.nlockcount(tp,usep)
	local ct=0
	local zone=0
	for i=0,4 do
		local bool,mzc=cm.mzlock(tp,i,usep)
		if not bool then
			ct=ct+1
			zone=zone|(1<<i)
		end
	end
	return ct,zone
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.filter(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.nlockcount(1-tp,tp)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft,zone=cm.nlockcount(1-tp,tp)
	local tg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if ft<=0 or #tg==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Group.CreateGroup()
	local dg=Group.CreateGroup()
	while ft>0 and #tg>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		g:AddCard(tc)
		local subg=tg:Filter(Card.IsCode,nil,tc:GetCode())
		tg:Sub(subg)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		local fd=Duel.SelectField(tp,1,0,LOCATION_MZONE,(~(zone<<16)))
		local mzc=cm.GetCardsInZone(tp,fd)
		if mzc then dg:AddCard(mzc) end
		fd=fd>>16
		cm[tc]=fd
		zone=zone&(~fd)
		ft=ft-1
	end
	if #g>0 then
		if #dg>0 then Duel.Destroy(dg,REASON_RULE) end
		for tc in aux.Next(g) do
			Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP_ATTACK,cm[tc])
			cm[tc]=nil
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			--tc:RegisterEffect(e3,true)
		end
		Duel.SpecialSummonComplete()
	end
end