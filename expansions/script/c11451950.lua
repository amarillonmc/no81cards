--升华念力斗士
local cm,m=GetID()
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,function(c) return c:IsRace(RACE_PSYCHO) and c:IsFusionSetCard(0xe) end,1,true)
	local e10=aux.AddContactFusionProcedure(c,cm.filter,LOCATION_GRAVE+LOCATION_MZONE,0,cm.tdcfop(c))
	local con=e10:GetCondition()
	local op=e10:GetOperation()
	e10:SetCondition(function(e,...)
		return c:GetFlagEffect(m)>0 and con(e,...)
	end)
	e10:SetOperation(function(e,...) 
		c:ResetFlagEffect(m)
		op(e,...)
	end)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetLabelObject(e10)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.sumcon)
	e3:SetTarget(cm.sumtg)
	e3:SetOperation(cm.sumop1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(aux.TRUE) --cm.sumcon2)
	e4:SetOperation(cm.sumop2)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetDescription(aux.Stringid(m,3))
	e5:SetCondition(cm.sumcon3)
	e5:SetOperation(cm.sumop)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EVENT_CUSTOM+m+1)
	e6:SetCondition(aux.TRUE)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		local _Overlay=Duel.Overlay
		function Duel.Overlay(xc,v,...)
			local t=Auxiliary.GetValueType(v)
			local g=Group.CreateGroup()
			if t=="Card" then g:AddCard(v) else g=v end
			if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
				Duel.RaiseEvent(g:Filter(Card.IsLocation,nil,LOCATION_HAND),EVENT_CUSTOM+m+1,e,0,0,0,0)
			end
			return _Overlay(xc,v,...)
		end
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_ACTIVATING)
		ge2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
		ge2:SetOperation(cm.chkop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,r,rp,ep,ev)
end
function cm.tdcfop(c)
	return function(g)
				if #g==0 then return end
				local tp=c:GetControler()
				local dg=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
				local cg=g:Filter(Card.IsFacedown,nil)
				if #dg>0 then
					Duel.SendtoHand(dg,nil,REASON_COST)
				end
				Duel.SendtoDeck(g-dg,nil,2,REASON_COST)
				if #dg>0 or #cg>0 then Duel.ConfirmCards(1-tp,g) end
			end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
	if Duel.GetFlagEffect(tp,m)>0 or not c:IsSpecialSummonable(0) then c:ResetFlagEffect(m) return end
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		te:GetTarget()(te,tp,eg,ep,ev,re,r,rp,1,c)
		te:GetOperation()(te,tp,eg,ep,ev,re,r,rp,c)
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
		c:CompleteProcedure()
	else
		c:ResetFlagEffect(m)
	end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.filter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsFusionSetCard(0xe) and (c:IsLocation(LOCATION_MZONE) and c:IsAbleToHandAsCost()) or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToDeckAsCost())
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and not (c:IsLocation(LOCATION_HAND) and c:IsControler(c:GetPreviousControler()))
end
function cm.cfilter2(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and not c:IsOnField() --bug.
end
function cm.smfilter(c)
	return c:IsSetCard(0xe) and c:IsAbleToHand()
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp) and not eg:IsExists(cm.cfilter2,1,nil,1-tp)
end
function cm.sumcon2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsExists(cm.cfilter,1,nil,1-tp) and eg:IsExists(cm.cfilter2,1,nil,1-tp)
end
function cm.sumcon3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp) and eg:IsExists(cm.cfilter2,1,nil,1-tp)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_DECK,0)
	if #g<1 then return end
	local opt=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local typ,typ2=Duel.AnnounceType(tp),0
	if typ==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		typ2=Duel.AnnounceAttribute(tp,1,0x7f)
	end
	if opt==1 then
		local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
		Duel.MoveSequence(tc,0)
	end
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	Duel.ConfirmDecktop(1-tp,1)
	if tc:IsType(1<<typ) and (typ>0 or tc:IsAttribute(typ2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_DECK,0,1,1,tc)
		if tc:IsAbleToHand() then g:AddCard(tc) end
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	else
		if opt==1 then Duel.MoveSequence(tc,1) end
		if e:GetHandler():IsRelateToEffect(e) then Duel.GetControl(e:GetHandler(),1-tp) end
	end
end
function cm.sumop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_DECK,0)
	if #g<1 then return end
	local opt=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local typ,typ2=Duel.AnnounceType(tp),0
	if typ==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		typ2=Duel.AnnounceAttribute(tp,1,0x7f)
	end
	if opt==1 then
		local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
		Duel.MoveSequence(tc,0)
	end
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	Duel.ConfirmDecktop(1-tp,1)
	if tc:IsType(1<<typ) and (typ>0 or tc:IsAttribute(typ2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_DECK,0,1,1,tc)
		if tc:IsAbleToHand() then g:AddCard(tc) end
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	else
		if opt==1 then Duel.MoveSequence(tc,1) end
		if e:GetHandler():IsRelateToEffect(e) then Duel.GetControl(e:GetHandler(),1-tp) end
	end
end
function cm.sumop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_DECK,0)
	if #g<1 then return end
	local opt=1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local typ,typ2=Duel.AnnounceType(tp),0
	if typ==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		typ2=Duel.AnnounceAttribute(tp,1,0x7f)
	end
	if opt==1 then
		local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
		Duel.MoveSequence(tc,0)
	end
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	Duel.ConfirmDecktop(1-tp,1)
	if tc:IsType(1<<typ) and (typ>0 or tc:IsAttribute(typ2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_DECK,0,1,1,tc)
		if tc:IsAbleToHand() then g:AddCard(tc) end
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	else
		if opt==1 then Duel.MoveSequence(tc,1) end
		if e:GetHandler():IsRelateToEffect(e) then Duel.GetControl(e:GetHandler(),1-tp) end
	end
end