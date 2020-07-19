--曹操
local m=14010110
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--ban
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--timing chk
	if cm.call==nil then
		cm.call=true
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetCondition(cm.callcon1)
		e3:SetOperation(cm.callchk1)
		Duel.RegisterEffect(e3,0)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) then
		if Duel.IsPlayerAffectedByEffect(tp,m) or Duel.IsPlayerAffectedByEffect(tp,14011110) then return end
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
			end
			local e_t=Effect.CreateEffect(e:GetHandler())
			e_t:SetType(EFFECT_TYPE_FIELD)
			e_t:SetCode(14011110)
			e_t:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e_t:SetTargetRange(1,0)
			e_t:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e_t,tp)
		else
			local e_t=Effect.CreateEffect(e:GetHandler())
			e_t:SetType(EFFECT_TYPE_FIELD)
			e_t:SetCode(m)
			e_t:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e_t:SetTargetRange(1,0)
			e_t:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e_t,tp)
		end
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	e:GetHandler():SetHint(CHINT_CARD,ac)
	--forbidden
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0x7f,0x7f)
	e1:SetTarget(cm.bantg)
	e1:SetLabel(ac)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--forbidden
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.hintop)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)	
end
function cm.hintop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():SetHint(CHINT_CARD,0)
end
function cm.bantg(e,c)
	return c:IsCode(e:GetLabel())
end
function cm.callcon1(e,tp,eg,ep,ev,re,r,rp)
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_ANNOUNCE)
	return ex --and bit.band(cv,ANNOUNCE_CARD+ANNOUNCE_CARD_FILTER)~=0 
		and not Duel.IsPlayerAffectedByEffect(tp,14011110)
end
function cm.callchk1(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(ev,CHAININFO_TARGET_PARAM)
	if bit.band(code,14010110)==14010110 then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,0,0,0,0)
		local te1=Duel.IsPlayerAffectedByEffect(tp,m)
		if te1 then
			te1:Reset()
			return
		end
	end
end