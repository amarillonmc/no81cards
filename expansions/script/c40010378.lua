--哀哭之珠玉圣骑 爱什莉－逆
local m=40010378
local cm=_G["c"..m]
cm.named_with_JewelPaladin=1
cm.named_with_Reverse=1
function cm.JewelPaladin(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_JewelPaladin
end
function cm.initial_effect(c)
		c:SetUniqueOnField(1,0,m)   
	--spsummon cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	e0:SetOperation(cm.jpop)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)  
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BATTLED)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)

end
function cm.jpfilter(c)
	return  c:IsType(TYPE_MONSTER)
end
function cm.jpop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.jpfilter,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=-1 then return end
	--if Duel.GetFlagEffect(tp,m+2)>0 then return end
	if sg:GetCount()>0 and ft>0 then
		if  Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			local g=Duel.SelectReleaseGroup(tp,cm.jpfilter,1,1,nil)
			local tc=g:GetFirst()
			if Duel.Release(tc,REASON_COST)~=0 and tc:IsCode(40010010) then
				e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
			end
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	else
		local g=Duel.SelectReleaseGroup(tp,cm.jpfilter,1,1,nil)
		local tc=g:GetFirst()
		if Duel.Release(tc,REASON_COST)~=0 and tc:IsCode(40010010) then
			e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	--e:GetLabelObject():SetLabel(0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message("0")
	local rc=e:GetHandler():GetReasonCard()
	if rc then else rc=e:GetHandler():GetReasonEffect():GetHandler() end
	if rc then
		--Debug.Message("1")
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCountLimit(1)
		e1:SetLabelObject(rc)
		e1:SetOperation(cm.op2)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local rc=e:GetLabelObject()
	--Debug.Message("2")
	if rc and rc==eg:GetFirst() and rc:GetSequence()==c:GetPreviousSequence() and rc:IsControler(tp) then
		--Debug.Message("3")
		Duel.RaiseEvent(c,EVENT_CUSTOM+m,nil,0,0,tp,0)
	end
	e:Reset()
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) and Duel.IsExistingMatchingCard(cm.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cm.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ChangePosition(g,POS_FACEDOWN_ATTACK)
			local tc=g:GetFirst()
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetCondition(cm.flipcon)
		e1:SetOperation(cm.flipop)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
		--e2:SetCondition(cm.rcon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		Duel.RegisterEffect(e3,tp)
end
function cm.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:IsFacedown() and Duel.GetTurnPlayer()==tc:GetControler() and tc:GetFlagEffect(m)~=0 and Duel.GetFlagEffect(tp,40010160)==0
end
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD+LOCATION_HAND)
end
function cm.spfilter(c,e,tp)
	return cm.JewelPaladin(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		local dg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if Duel.SendtoGrave(sg,REASON_RULE) and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sdg=dg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sdg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.spcfilter(c)
	return c:IsPosition(POS_FACEDOWN_ATTACK)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetFlagEffect(m)>0
end
function cm.sp2filter(c,e,tp)
	return cm.JewelPaladin(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)

	local cg=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_MZONE,0,nil)
	--local ct=math.min(#cg,(Duel.GetLocationCount(tp,LOCATION_MZONE)))
	if cg>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then cg=1 end
	local g=Duel.GetMatchingGroup(cm.sp2filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,cg)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end













