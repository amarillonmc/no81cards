--星之奔流★十三拘束解放
local cm,m=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(cm.imop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	--addition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(cm.chcon)
	e4:SetOperation(cm.chop)
	c:RegisterEffect(e4)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.imop(e,tp,eg,ep,ev,re,r,rp)
	--tograve
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetOperation(cm.adjustop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	e:GetHandler():RegisterEffect(e1,true)
end
function cm.tgfilter(c,tc)
	if c:IsLocation(LOCATION_FZONE) then return false end
	local seq=c:GetSequence()
	if seq==5 then seq=1 elseif seq==6 then seq=3 end
	local tseq=tc:GetSequence()
	if tseq==5 then tseq=1 elseif tseq==6 then tseq=3 end
	return tc:GetColumnGroup():IsContains(c) or (seq+tseq==3) or (seq+tseq==5)
end
function cm.adjustop(e,tp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_ONFIELD,e:GetHandler(),e:GetHandler())
	if Duel.SendtoGrave(g,REASON_RULE)>0 then
		Duel.Readjust()
	end
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and e:GetLabel()==ev-1 and ev<=13
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cat={CATEGORY_RECOVER,CATEGORY_DAMAGE,CATEGORY_DECKDES+CATEGORY_TOGRAVE,CATEGORY_DRAW,CATEGORY_REMOVE,0,CATEGORY_REMOVE,0,CATEGORY_ATKCHANGE,CATEGORY_TOGRAVE,0,CATEGORY_TODECK,CATEGORY_DISABLE}
	local cat0=re:GetCategory()
	local op0=re:GetOperation()
	local repop=function(e,tp,eg,ep,ev,re,r,rp)
		op0(e,tp,eg,ep,ev,re,r,rp)
		cm.addition(e,tp,eg,ep,ev,re,r,rp)
	end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,14)) then return end
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.Hint(HINT_CARD,0,m)
	re:SetCategory(cat0|cat[ev])
	re:SetOperation(repop)
	e:SetLabel(ev)
	if ev==13 then
		if Duel.IsExistingMatchingCard(Card.IsAbleToHandAsCost,tp,LOCATION_MZONE,0,1,nil) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.SelectYesNo(tp,aux.Stringid(m,15)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHandAsCost,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_COST)
			if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
				c:CompleteProcedure()
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabel(ev)
	e1:SetLabelObject(e)
	e1:SetCondition(cm.rscon)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) re:SetOperation(op0) re:SetCategory(cat0) e:GetLabelObject():SetLabel(4650) end)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return ev==e:GetLabel()
end
function cm.addition(e,tp,eg,ep,ev,re,r,rp)
	local ev=Duel.GetCurrentChain()
	if ev==1 and cm[ev]==nil and Duel.SelectYesNo(tp,aux.Stringid(m,ev)) then
		Duel.Recover(tp,100,REASON_EFFECT)
	elseif ev==2 and cm[ev]==nil and Duel.SelectYesNo(tp,aux.Stringid(m,ev)) then
		Duel.Damage(1-tp,100,REASON_EFFECT)
	elseif ev==3 and cm[ev]==nil and Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,ev)) then
		Duel.DiscardDeck(tp,1,REASON_EFFECT)
	elseif ev==4 and cm[ev]==nil and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,ev)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif ev==5 and cm[ev]==nil and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,ev)) then
		local g=Duel.GetDecktopGroup(1-tp,1)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	elseif ev==6 and cm[ev]==nil then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
		if Duel.CheckLocation(tp,LOCATION_MZONE,5) and Duel.CheckLocation(1-tp,LOCATION_MZONE,6) then ft=ft+1 end
		if Duel.CheckLocation(tp,LOCATION_MZONE,6) and Duel.CheckLocation(1-tp,LOCATION_MZONE,5) then ft=ft+1 end
		if ft>0 and Duel.SelectYesNo(tp,aux.Stringid(m,ev)) then
			local zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0)
			if tp==1 then
				zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
			end
			--disable field
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE_FIELD)
			e1:SetValue(zone)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
		end
	elseif ev==7 and cm[ev]==nil and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,POS_FACEDOWN) and Duel.SelectYesNo(tp,aux.Stringid(m,ev)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,POS_FACEDOWN)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		end
	elseif ev==8 and cm[ev]==nil and Duel.IsExistingMatchingCard(cm.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,ev)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,cm.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		if tc then
			local p1,p2
			if tc:IsControler(tp) then
				p1=LOCATION_MZONE
				p2=0
			else
				p1=0
				p2=LOCATION_MZONE
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local seq=math.log(Duel.SelectDisableField(tp,1,p1,p2,0),2)
			if tc:IsControler(1-tp) then seq=seq-16 end
			Duel.MoveSequence(tc,seq)
		end
	elseif ev==9 and cm[ev]==nil then
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,ev)) then
			local tc=g:GetFirst()
			while tc do
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_UPDATE_ATTACK)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				e3:SetValue(500)
				tc:RegisterEffect(e3)
				tc=g:GetNext()
			end
		end
	elseif ev==10 and cm[ev]==nil then
		local g2=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,ev)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g2:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	elseif ev==11 and cm[ev]==nil and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,ev)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,SEQ_DECKTOP)
			Duel.ConfirmDecktop(tp,1)
		end
	elseif ev==12 and cm[ev]==nil and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,ev)) then
		local p=tp
		local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
		if g:GetCount()>0 then
			Duel.ConfirmCards(p,g)
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local sg=g:Select(p,1,1,nil)
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			Duel.ShuffleHand(1-p)
		end
	elseif ev==13 and cm[ev]==nil and Duel.SelectYesNo(tp,aux.Stringid(m,ev)) then
		local c=e:GetHandler()
		--negate
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_DISABLE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.negcon)
		e1:SetOperation(cm.negop)
		e1:SetLabel(tp)
		Duel.RegisterEffect(e1,tp)
	end
	cm[ev]=1
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetLabel()
	return rp==1-tp and re:IsActivated()
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetLabel()
	local c=e:GetHandler()
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.dis2con)
	e2:SetOperation(cm.dis2op)
	e2:SetLabelObject(re)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	e:Reset()
end
function cm.dis2con(e,tp,eg,ep,ev,re,r,rp)
	return re and e:GetLabelObject() and re==e:GetLabelObject()
end
function cm.dis2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateEffect(ev)
end
function cm.seqfilter(c)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)>0
end