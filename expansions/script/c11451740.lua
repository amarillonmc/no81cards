--泪渊炙燃的不归路
local m=11451740
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter1(c,e,tp)
	return c:IsSetCard(0x6977) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,e:GetHandler())
	local b1=#g1>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=#g2>0 and Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	end
	e:SetLabel(s)
	if s==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	end
	if s==1 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(tp)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter1),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if e:GetLabel()==0 and #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g1:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(cm.immval)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetOwnerPlayer(tp)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetLabelObject(tc)
			e2:SetCondition(cm.descon)
			e2:SetOperation(cm.desop)
			Duel.RegisterEffect(e2,tp)
		end
		Duel.SpecialSummonComplete()
	elseif e:GetLabel()==1 then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local res=0
		--[[local g=Duel.GetMatchingGroup(aux.NOT(Card.IsSetCard),p,LOCATION_DECK,0,nil,0x6977)
		local dcount=Duel.GetFieldGroupCount(p,LOCATION_DECK,0)
		local seq=-1
		local tc=g:GetFirst()
		local dcard=nil
		while tc do
			if tc:GetSequence()>seq then
				seq=tc:GetSequence()
				dcard=tc
			end
			tc=g:GetNext()
		end
		res=Duel.Draw(p,dcount-seq,REASON_EFFECT)--]]
		local ct=Duel.Draw(p,1,REASON_EFFECT)
		while ct>0 do
			local dc=Duel.GetOperatedGroup():GetFirst()
			Duel.ConfirmCards(1-p,dc)
			res=res+1
			ct=0
			if dc:IsSetCard(0x6977) and not dc:IsLevel(8) then
				Duel.BreakEffect()
				ct=Duel.Draw(p,1,REASON_EFFECT)
			end
		end
		if res>0 then
			--local dg=Duel.GetOperatedGroup()
			--Duel.ConfirmCards(1-p,dg)
			local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
			if #g<2 then return end
			Duel.BreakEffect()
			Duel.ShuffleHand(p)
			Duel.DiscardHand(p,aux.TRUE,2,2,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function cm.immval(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end