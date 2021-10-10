--影密忍军 百鬼风行
local m=40009509
local cm=_G["c"..m]
cm.named_with_Covertforces=1
function cm.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)	
end
function cm.Covertforces(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Covertforces
end
function cm.costfilter(c,e,tp)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		else
			return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.drfilter(c)
	return c:IsFaceup() and c:IsCode(m)
end
function cm.filter2(c)
	return c:IsFaceup() and cm.Covertforces(c)
end
function cm.thfilter(c)
	return cm.Covertforces(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if tc then
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local g=Duel.GetMatchingGroup(cm.drfilter,tp,LOCATION_MZONE,0,nil)
				local b1=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,m)==0
				local b2=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,m+1)==0
				local b3=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,m+2)==0
				local op=0
				if g:GetCount()>2 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
					Duel.BreakEffect()
					if chk==0 then return b1 or b2 or b3 end
					local off=1
					local ops={}
					local opval={}
					if b1 then
					ops[off]=aux.Stringid(m,2)
					opval[off-1]=1
					off=off+1
					end
					if b2 then
					ops[off]=aux.Stringid(m,3)
					opval[off-1]=2
					off=off+1
					end
					if b3 then
					ops[off]=aux.Stringid(m,4)
					opval[off-1]=3
					off=off+1
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
					local op=Duel.SelectOption(tp,table.unpack(ops))
					if opval[op]==1 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
						local g1=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
						Duel.SendtoHand(g1,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,g1)
						Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
					elseif opval[op]==2 then
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_FIELD)
						e1:SetCode(EFFECT_UPDATE_ATTACK)
						e1:SetTargetRange(LOCATION_MZONE,0)
						e1:SetValue(700)
						e1:SetReset(RESET_PHASE+PHASE_END)
						Duel.RegisterEffect(e1,tp)
						Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
					elseif opval[op]==3 then
						local g2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_MZONE,0,nil)
						local tc2=g2:GetFirst()
						while tc2 do
							local e3=Effect.CreateEffect(c)
							e3:SetType(EFFECT_TYPE_SINGLE)
							e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
							e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
							e3:SetValue(aux.tgoval)
							tc2:RegisterEffect(e3)
							tc2=g2:GetNext()
						end
						Duel.RegisterFlagEffect(tp,m+2,RESET_PHASE+PHASE_END,0,1)
					end
				end
			end
			local fid=e:GetHandler():GetFieldID()
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabel(fid)
			e1:SetLabelObject(tc)
			e1:SetCondition(cm.thcon)
			e1:SetOperation(cm.thop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.atktg(e,c)
	return cm.Covertforces(c)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end