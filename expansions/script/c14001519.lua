--诞影之国的始焉 诞生之影
local m=14001519
local cm=_G["c"..m]
cm.named_with_EoS=1
function cm.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.Tuner(nil),1,1)
	c:EnableReviveLimit()
	--c:SetSPSummonOnce(m)
	--set
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MONSTER_SSET)
	e0:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.exsetcon)
	e1:SetOperation(cm.exsetop)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCondition(cm.repcon)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(0xff)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.setcon)
	e3:SetTarget(cm.settg)
	e3:SetOperation(cm.setop)
	c:RegisterEffect(e3)
	cm.changef_effect=e3
	if not eos_pos_check then
		eos_pos_check=true
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_SSET)
		e4:SetOperation(cm.ssetcon)
		Duel.RegisterEffect(e4,0)
		local e5=e4:Clone()
		e5:SetCode(EVENT_MSET)
		Duel.RegisterEffect(e5,0)
		local e6=e4:Clone()
		e6:SetCode(EVENT_CHANGE_POS)
		Duel.RegisterEffect(e6,0)
		local e7=e4:Clone()
		e7:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e7,0)
	end
	--tohand
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,1))
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetCountLimit(1,m)
	e8:SetCost(cm.thcost)
	e8:SetTarget(cm.thtg)
	e8:SetOperation(cm.thop)
	c:RegisterEffect(e8)
end
function cm.EoS(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_EoS
end
function cm.cfilter(c,tp)
	return cm.EoS(c) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsDiscardable()
end
function cm.exsetcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fug=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local fdg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local dhg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_HAND,0,nil,tp)
	return #fug>#fdg and #dhg>1 and (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 or c:IsSSetable()) and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.exsetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,2,2,c)
	if g and #g>0 then
		Duel.SendtoGrave(g,REASON_RULE+REASON_DISCARD)
		if Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.SelectOption(tp,aux.Stringid(14001521,4),aux.Stringid(14001521,5))==0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,c)
		elseif c:IsSSetable() then
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
			Duel.ConfirmCards(1-tp,c)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
function cm.filter(c,e,tp)
	return cm.EoS(c) and (c:IsSSetable() or (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
end
function cm.repcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.repfilter(c,tp)
	return c:IsOnField() and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and eg:IsExists(cm.repfilter,1,nil,tp) and c:GetFlagEffect(m)==0 end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,m)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,0,0)
		local tc=g:GetFirst()
		if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.SelectOption(tp,aux.Stringid(14001521,4),aux.Stringid(14001521,5))==0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,tc)
		elseif tc:IsSSetable() then
			Duel.SSet(tp,tc)
		end
	end
end
function cm.ssetfilter(c)
	return cm.EoS(c) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function cm.ssetcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if eg and #eg:Filter(cm.ssetfilter,nil)>0 then
		local eg1=eg:Filter(cm.ssetfilter,nil)
		local tc=eg1:GetFirst()
		while tc do
			local code=tc:GetOriginalCodeRule()
			local ccode=_G["c"..code]
			local catt=tc:GetOriginalAttribute()
			if (catt==ATTRIBUTE_LIGHT and Duel.GetTurnPlayer()~=tp) or (catt==ATTRIBUTE_DARK and Duel.GetTurnPlayer()==tp) and not tc:IsExtraDeckMonster() then return end
			if eg:IsContains(tc) and ccode.settg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.GetFlagEffect(tp,code)==0 then
				if Duel.GetCurrentChain()==0 then
					if tc:IsFacedown() and Duel.SelectEffectYesNo(tp,tc) then
						Duel.ChangePosition(tc,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)
						Duel.RaiseEvent(tc,EVENT_CUSTOM+code,e,0,0,0,0)
						Duel.RegisterFlagEffect(tp,code,RESET_PHASE+PHASE_END,0,1)
					end
				else
					local e1=Effect.CreateEffect(tc)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_CHAIN_END)
					e1:SetReset(RESET_EVENT+EVENT_CHAIN_END+RESET_PHASE+PHASE_END)
					e1:SetCountLimit(1)
					e1:SetLabelObject(tc)
					e1:SetOperation(cm.retop)
					Duel.RegisterEffect(e1,tp)
				end
			end
			tc=eg1:GetNext()
		end
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local code=c:GetOriginalCodeRule()
	if c and c:IsFacedown() and Duel.SelectEffectYesNo(tp,c) then
		Duel.ChangePosition(c,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)
		Duel.RaiseEvent(c,EVENT_CUSTOM+code,e,0,0,0,0)
		Duel.RegisterFlagEffect(tp,code,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c)
end
function cm.cefilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (cm.EoS(c) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGrave() and not c:IsCode(m)) then return false end
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local te=m.changef_effect
	local tg=nil
	if te then
		tg=te:GetTarget()
	end
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cefilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cefilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	if #g>0 then
		local tc=g:GetFirst()
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
			local m=_G["c"..tc:GetCode()]
			local te=m.changef_effect
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end
	end
end
function cm.tcfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and not c:IsLocation(LOCATION_PZONE)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tcfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.tcfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		tc:CancelToGrave()
		if tc:IsType(TYPE_MONSTER) then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		else
			Duel.ChangePosition(tc,POS_FACEDOWN)
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAbleToHand() and c:IsRelateToEffect(e) then
		if Duel.SendtoDeck(c,tp,2,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_EXTRA) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if #g>0 then
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end