if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53756002
local cm=_G["c"..m]
cm.name="临终的暮辞 望美"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0xa530),LOCATION_MZONE)
	local e1,e1_1,e2,e3=SNNM.ActivatedAsSpellorTrap(c,0x20004,LOCATION_HAND)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetTarget(cm.acsptg)
	e1:SetOperation(cm.spop)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetTarget(cm.reptg)
	e5:SetValue(cm.repval)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,3))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_F)
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_SZONE)
	e6:SetLabel(1)
	e6:SetCondition(cm.spcon)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		cm[2]=Duel.GetDecktopGroup
		Duel.GetDecktopGroup=function(tp,ct)
			Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,0)
			return cm[2](tp,ct)
		end
		cm[3]=Duel.DiscardDeck
		Duel.DiscardDeck=function(tp,ct,reason)
			local g=Duel.GetDecktopGroup(tp,ct)
			Duel.DisableShuffleCheck()
			return Duel.SendtoGrave(g,reason)
		end
	end
	SNNM.ActivatedAsSpellorTrapCheck(c)
end
GM_global_to_deck_check=true
function cm.acsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CHAINING,true)
	if res and tre:IsHasCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES) then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	else
		e:SetLabel(0)
		e:SetCategory(0)
	end
end
function cm.repcheck(c,p,loc)
	local g=Duel.GetFieldGroup(p,loc,0)
	if #g==0 then return true end
	local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
	return c~=tc
end
function cm.repfilter(c)
	return c:GetDestination()==LOCATION_GRAVE and c:GetLeaveFieldDest()==0 and c:IsReason(REASON_EFFECT) and cm.repcheck(c,0,LOCATION_DECK) and cm.repcheck(c,1,LOCATION_DECK) and cm.repcheck(c,0,LOCATION_EXTRA) and cm.repcheck(c,1,LOCATION_EXTRA)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return GM_global_to_deck_check and not eg:IsContains(c) and eg:IsExists(cm.repfilter,1,nil) end
	local p=Duel.GetTurnPlayer()
	local apply=true
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,p,LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(p,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rc=Duel.SelectMatchingCard(p,Card.IsAbleToRemove,p,LOCATION_HAND,0,1,1,nil):GetFirst()
		if Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)~=0 and rc:IsLocation(LOCATION_REMOVED) then
			rc:RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(rc)
			e1:SetCountLimit(1)
			e1:SetCondition(cm.retcon)
			e1:SetOperation(cm.retop)
			Duel.RegisterEffect(e1,p)
			if not c:IsImmuneToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
				apply=false
				local e2=Effect.CreateEffect(c)
				e2:SetCode(EFFECT_CHANGE_TYPE)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e2:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				c:RegisterEffect(e2)
				return false
			end
		end
	end
	if apply then
		GM_global_to_deck_check=false
		local g=eg:Filter(cm.repfilter,nil)
		local confirm=Group.__add(g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD):Filter(Card.IsFacedown,nil),g:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA))
		Duel.ConfirmCards(tp,confirm)
		Duel.ConfirmCards(1-tp,confirm)
		local g2=g:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		local chkg=g2:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if #chkg>0 and Duel.GetFlagEffect(tp,m)==0 then Duel.ShuffleDeck(tp) end
		for tc2 in aux.Next(g2) do
			Duel.MoveSequence(tc2,0)
			tc2:RegisterFlagEffect(m+33,RESET_EVENT+RESETS_STANDARD,0,1,1)
		end
		if #g2==#g then
			for i=0,1 do
				local sog2=g2:Filter(Card.IsControler,nil,i)
				local exg2=sog2:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
				local mag2=Group.__sub(sog2,exg2)
				if #mag2>1 then Duel.SortDecktop(tp,tp,#mag2) end
				for i=1,#mag2 do Duel.MoveSequence(Duel.GetDecktopGroup(tp,1):GetFirst(),1) end
				local temp2=Group.CreateGroup()
				for i=1,#exg2 do
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
					local mg2=exg2:Select(tp,1,1,temp2)
					Duel.MoveSequence(mg2:GetFirst(),1)
					temp2:Merge(mg2)
				end
			end
		else
			local g1=g:Filter(aux.NOT(Card.IsLocation),nil,LOCATION_DECK+LOCATION_EXTRA)
			if #g1>0 then
				for tc1 in aux.Next(g1) do
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetValue(LOCATION_DECK)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc1:RegisterEffect(e3,true)
					tc1:RegisterFlagEffect(m+33,RESET_EVENT+0x13e0000,0,1)
				end
			end
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e4:SetCode(EVENT_TO_DECK)
			e4:SetCountLimit(1)
			e4:SetOperation(cm.tdop)
			Duel.RegisterEffect(e4,tp)
		end
		GM_global_to_deck_check=true
		return true
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m+100)==0 then
		e:Reset()
		return false
	else return true end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),tp,REASON_EFFECT)
end
function cm.repval(e,c)
	return c:GetFlagEffect(m+33)~=0 and c:GetFlagEffectLabel(m+33)==1
end
function cm.tdfilter(c)
	return c:GetFlagEffect(m+33)~=0
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local gg1=Duel.GetMatchingGroup(cm.tdfilter,0,LOCATION_DECK,LOCATION_DECK,nil)
	local gg2=Duel.GetMatchingGroup(cm.tdfilter,0,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	for p=0,1 do
		local g1=gg1:Filter(Card.IsControler,nil,p)
		local g2=gg2:Filter(Card.IsControler,nil,p)
		if #g1>0 then
			g1:ForEach(Card.ResetFlagEffect,m)
			Duel.SortDecktop(p,p,#g1)
			for i=1,#g1 do Duel.MoveSequence(Duel.GetDecktopGroup(p,1):GetFirst(),1) end
		end
		if #g2>0 then
			g2:ForEach(Card.ResetFlagEffect,m)
			local temp2=Group.CreateGroup()
			for i=1,#g2 do
				Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(m,2))
				local mg2=g2:Select(p,1,1,temp2)
				Duel.MoveSequence(mg2:GetFirst(),1)
				temp2:Merge(mg2)
			end
		end
	end
	e:Reset()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES) and e:GetHandler():GetType()&0x20004==0x20004 and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_HAND)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
