--蚁巢的威势
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--send replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(cm.reptg)
	e1:SetValue(cm.repval)
	c:RegisterEffect(e1)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
	--negative
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	--discard
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_CHAINING)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.discon2)
	e3:SetTarget(cm.distg2)
	e3:SetOperation(cm.disop2)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local _DiscardDeck=Duel.DiscardDeck
		Duel.DiscardDeck=function(tp,ct,r)
			local g=Duel.GetDecktopGroup(tp,ct)
			Duel.DisableShuffleCheck()
			return Duel.SendtoGrave(g,r)
		end
	end
end
function cm.repfilter(c,tp)
	return (not c:IsLocation(LOCATION_OVERLAY) and not c:IsType(TYPE_SPELL+TYPE_TRAP) and not (c:IsControler(tp) and c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5)) and c:GetDestination()==LOCATION_GRAVE and not c:IsForbidden()
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(cm.repfilter,e:GetHandler(),tp)
		return count>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
	local g=eg:Filter(cm.repfilter,e:GetHandler(),tp)
	if g:FilterCount(Card.IsOnField,nil)==#g then
		Duel.HintSelection(g)
	else
		Duel.ConfirmCards(tp,g)
	end
	local container=e:GetLabelObject()
	container:Clear()
	local res=false
	for tc in aux.Next(g) do
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectEffectYesNo(tp,tc,aux.Stringid(m,5)) then
			res=true
	--[[if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local container=e:GetLabelObject()
		container:Clear()
		local tc=g:GetFirst()
		while tc do--]]
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetRange(LOCATION_SZONE)
			e2:SetAbsoluteRange(tp,1,0)
			e2:SetTarget(function(e,c) return not c:IsRace(RACE_INSECT) end)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			--tc:RegisterEffect(e2,true)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
			container:AddCard(tc)
		end
	end
	return res
end
function cm.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) and re:GetActivateLocation()==LOCATION_MZONE
end
function cm.cfilter(c,tc)
	return c:IsRace(RACE_INSECT) and c:IsFaceup() and c:IsAttackAbove(1000) and c:GetAttack()>tc:GetAttack()
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,re:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil,re:GetHandler()):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(-1000)
		tc:RegisterEffect(e1)
		if not tc:IsHasEffect(EFFECT_REVERSE_UPDATE) then
			Duel.NegateEffect(ev)
		end
	end
end
function cm.discon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE
end
function cm.distg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.IsPlayerCanDiscardDeck(1-tp,1) end
end
function cm.spfilter(c)
	return c:IsRace(RACE_INSECT) and (c:IsSpecialSummonable(0) or c:IsSpecialSummonable(SUMMON_TYPE_FUSION) or c:IsSpecialSummonable(SUMMON_TYPE_SYNCHRO) or c:IsSpecialSummonable(SUMMON_TYPE_XYZ) or c:IsSpecialSummonable(SUMMON_TYPE_LINK) or c:IsSpecialSummonable(SUMMON_TYPE_SPECIAL) or c:IsSpecialSummonable(SUMMON_VALUE_SELF))
end
function cm.disop2(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.DiscardDeck(tp,1,REASON_EFFECT)
	local ct2=Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
	if ct1>0 or ct2>0 then
		local sg=Duel.GetMatchingGroup(cm.spfilter,tp,0xff,0,nil)
		if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=sg:Select(tp,1,1,nil):GetFirst()
			for _,sumtype in pairs({0,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_SPECIAL,SUMMON_VALUE_SELF}) do
				if tc:IsSpecialSummonable(sumtype) then Duel.SpecialSummonRule(tp,tc,sumtype) end
			end
		end
	end   
end