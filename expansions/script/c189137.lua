local m=189137
local cm=_G["c"..m]
cm.name="Furioso"
function cm.initial_effect(c)
	aux.AddCodeList(c,189131)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(189133,4))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1150)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--add public count
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(189137)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CUSTOM+189138)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(cm.setop)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,4))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(cm.hancon)
	e4:SetTarget(cm.hantg)
	e4:SetOperation(cm.activate)
	c:RegisterEffect(e4)
	if not cm.FuriosoCheck then
		cm.FuriosoCheck=true
		_FuriosoIsHasType=Effect.IsHasType
		function Effect.IsHasType(e,typ)
			if typ==EFFECT_TYPE_ACTIVATE and e:GetDescription() and e:GetDescription()+1==aux.Stringid(m,4)+1 then return true end
			return _FuriosoIsHasType(e,typ)
		end
	end
end
function cm.hancon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActivated() and aux.IsCodeListed(re:GetHandler(),189131)
end
function cm.handcon(e)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),189133)~=0
end
function cm.hantg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local b1=c:GetActivateEffect():IsActivatable(tp,true)
		e:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetLabelObject(e)
		e1:SetCondition(cm.regcon)
		e1:SetOperation(cm.regop)
		e1:SetReset(RESET_CHAIN)
		e1:SetLabel(tp)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHAINING)
		Duel.RegisterEffect(e2,tp)
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and b1
	end
	Duel.RegisterFlagEffect(tp,189132,RESET_CHAIN,0,1,e:GetFieldID())
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject()
	local tp=e:GetLabel()
	local x=0
	if Duel.GetFlagEffect(tp,189132)~=0 then
		for _,i in ipairs{Duel.GetFlagEffectLabel(tp,189132)} do
			if i==se:GetFieldID() then x=1 end
		end
	end
	return se and ((not re) or (re~=se and (e:GetCode()==EVENT_CHAINING and (Duel.GetFlagEffect(tp,189132)==0 or x==0))))
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject()
	if se and se:IsHasType(EFFECT_TYPE_ACTIVATE) then
		se:SetType(EFFECT_TYPE_QUICK_O)
	end
end
function cm.tgfilter(c)
	return aux.IsCodeListed(c,189131) and c:IsAbleToGrave()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	if e:GetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE) then
		e:SetType(EFFECT_TYPE_QUICK_O)
	end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,189137)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.setcon2)
	e1:SetOperation(cm.setop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.setfilter(c)
	return aux.IsCodeListed(c,189131) and ((c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSSetable()) or (c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)))
end
function cm.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.setop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,tc)
		elseif (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and tc:IsSSetable() then
			Duel.SSet(tp,tc)
		end
	end
end