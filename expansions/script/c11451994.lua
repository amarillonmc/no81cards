--业之舞姬
local cm,m=GetID()
function cm.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(cm.scon)
	e1:SetTarget(cm.stg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.Remove(c,POS_FACEUP,REASON_EFFECT) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.drcon1)
	e1:SetOperation(cm.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	e2:SetLabel(Duel.GetTurnCount())
	e2:SetCountLimit(1)
	e2:SetOperation(cm.retop)
	Duel.RegisterEffect(e2,tp)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
	e2:SetLabelObject(g)
end
function cm.filter(c)
	return not c:IsSummonLocation(LOCATION_REMOVED)
end
function cm.filter1(c,p)
	return not c:IsSummonLocation(LOCATION_REMOVED) and c:IsSummonPlayer(p)
end
function cm.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil)
end
function cm.drop1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	for tp in aux.TurnPlayers() do
		if eg:IsExists(cm.filter1,1,nil,tp) then
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.DisableShuffleCheck()
			if Duel.Remove(mg,POS_FACEUP,REASON_EFFECT)>0 then
				local tc=Duel.GetOperatedGroup():GetFirst()
				Duel.ConfirmCards(1-tp,tc)
				Duel.BreakEffect()
				if tc:IsLocation(LOCATION_REMOVED) and tc:IsType(TYPE_MONSTER) then
					if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
						local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,nil,tp)
						local rc=tg:GetFirst()
						if Duel.Remove(rc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and not rc:IsReason(REASON_REDIRECT) then
							rc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,Duel.GetCurrentPhase(),aux.Stringid(m,1))
							g:AddCard(rc)
						end
					end
				end
			end
		end
	end
end
function cm.GetCardsInZone(tp,fd)
	if fd==0x400020 then return Duel.GetFieldCard(tp,LOCATION_MZONE,5) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) end
	if fd==0x200040 then return Duel.GetFieldCard(tp,LOCATION_MZONE,6) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) end
	local seq=math.log(fd,2)
	local p=tp
	if seq>=16 then
		p=1-tp
		seq=seq-16
	end
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	return Duel.GetFieldCard(p,loc,math.floor(seq+0.5))
end
function cm.mzlock(tp,seq,usep)
	local mzc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq)
	local fd=0
	if mzc then fd=Duel.GetMZoneCount(tp,mzc,usep,LOCATION_REASON_TOFIELD,1<<seq) end
	return ((not mzc and not Duel.CheckLocation(tp,LOCATION_MZONE,seq)) or (mzc and fd==0)),mzc
end
function cm.nlockcount(tp,usep)
	local ct=0
	local zone=0
	for i=0,4 do
		local bool,mzc=cm.mzlock(tp,i,usep)
		if not bool then
			ct=ct+1
			zone=zone|(1<<i)
		end
	end
	return ct,zone
end
function cm.filter2(c)
	return c:GetFlagEffectLabel(m) and c:GetFlagEffectLabel(m)<PHASE_END
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local rg=g:Clone()
	if e:GetLabel()==Duel.GetTurnCount() then rg=rg:Filter(cm.filter2,nil) g:Sub(rg) end
	for tp in aux.TurnPlayers() do
		local tg=rg:Filter(Card.IsPreviousControler,nil,tp)
		local ft,zone=cm.nlockcount(tp,tp)
		local g=Group.CreateGroup()
		local dg=Group.CreateGroup()
		while ft>0 and #tg>0 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local tc=tg:Select(tp,1,1,nil):GetFirst()
			g:AddCard(tc)
			tg:RemoveCard(tc)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
			local fd=Duel.SelectField(tp,1,LOCATION_MZONE,0,(~zone))
			local mzc=cm.GetCardsInZone(tp,fd)
			if mzc then dg:AddCard(mzc) end
			cm[tc]=fd
			zone=zone&(~fd)
			ft=ft-1
		end
		if #g>0 then
			if #dg>0 then Duel.Destroy(dg,REASON_RULE) end
			for tc in aux.Next(g) do
				tc:ResetFlagEffect(m)
				Duel.ReturnToField(tc,tc:GetPreviousPosition(),cm[tc])
				cm[tc]=nil
			end
		end
		for tc in aux.Next(tg-g) do
			tc:ResetFlagEffect(m)
			Duel.ReturnToField(tc)
		end
	end
end