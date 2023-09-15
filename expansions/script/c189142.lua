local m=189142
local cm=_G["c"..m]
cm.name="老男孩工坊"
function cm.initial_effect(c)
	aux.AddCodeList(c,189131)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.hfilter(c)
	return not c:IsPublic()
end
function cm.thfilter(c,typ)
	local rtype=bit.band(c:GetType(),0x7)
	return aux.IsCodeListed(c,189131) and c:IsAbleToHand() and ((not typ) or (bit.band(rtype,typ)~=0))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(cm.hfilter,tp,0,LOCATION_HAND,nil)>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,nil) end
	local list={}
	local m=0
	local s=0
	local t=0
	if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER) then
		table.insert(list,70)
		m=1
	end
	if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,TYPE_SPELL) then
		table.insert(list,71)
		s=1
	end
	if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,TYPE_TRAP) then
		table.insert(list,72)
		t=1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.SelectOption(tp,table.unpack(list))
	local opt=0
	if op==0 then
		if m==1 then opt=0 end
		if m==0 and s==1 then opt=1 end
		if m==0 and s==0 and t==1 then opt=2 end
	end
	if op==1 then
		if m==1 and s==1 then opt=1 end
		if m==1 and s==0 and t==1 then opt=2 end
		if m==0 and s==1 and t==1 then opt=2 end
	end
	if op==2 then
		opt=2
	end
	e:SetLabel(opt)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.hfilter,tp,0,LOCATION_HAND,nil)
	local rtype=0
	if g:GetCount()~=0 then
		local ct=1
		if Duel.IsPlayerAffectedByEffect(tp,189137) and Duel.GetFlagEffect(tp,189137)==0 and g:GetCount()>=2 and Duel.SelectYesNo(tp,aux.Stringid(189137,2)) then
			ct=2
			Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+189138,e,REASON_EFFECT,tp,1-tp,ev)
			Duel.RegisterFlagEffect(tp,189137,RESET_PHASE+PHASE_END,0,1)
		end
		local ag=g:RandomSelect(tp,ct)
		local ac=ag:GetFirst()
		while ac do
			if bit.band(rtype,bit.band(ac:GetType(),0x7))==0 then
				rtype=rtype+bit.band(ac:GetType(),0x7)
			end
			ac:RegisterFlagEffect(189133,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,66)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			ac:RegisterEffect(e1)
			ac=ag:GetNext()
		end
		Duel.ConfirmCards(tp,ag)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,rtype)
		if g:GetCount()>0 then
			if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
				Duel.ConfirmCards(1-tp,g)
				local opt=e:GetLabel()
				if ((opt==0 and bit.band(rtype,TYPE_MONSTER)~=0) or (opt==1 and bit.band(rtype,TYPE_SPELL)~=0) or (opt==2 and bit.band(rtype,TYPE_TRAP)~=0)) then
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		end
	end
end