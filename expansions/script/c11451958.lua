--影蝙蝠
local cm,m=GetID()
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(cm.spcon)
	--e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--unsynchroable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsSummonPlayer(tp)
end
function cm.thfilter(c)
	return c:IsCode(m) and c:IsAbleToHand()
end
function cm.tdfilter(c)
	return c:IsAbleToHand() or (c:IsLocation(LOCATION_MZONE) and c:IsCanTurnSet())
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if not c:IsPublic() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,6))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e1)
	else
		e:GetHandler():RegisterFlagEffect(11451544,RESET_EVENT+RESETS_STANDARD,0,1)
		local eset={e:GetHandler():IsHasEffect(EFFECT_PUBLIC)}
		if #eset>0 then
			for _,ae in pairs(eset) do
				if ae:IsHasType(EFFECT_TYPE_SINGLE) then
					ae:Reset()
				else
					local tg=ae:GetTarget() or aux.TRUE
					ae:SetTarget(function(e,c,...) return tg(e,c,...) and c:GetFlagEffect(11451544)==0 end)
				end
			end
		end
	end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=eg:GetFirst()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil,tp,POS_FACEDOWN)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		local b3=Duel.GetTurnPlayer()==tp
		return true --#g>0 and (b1 or b2 or b3) and Duel.GetCurrentChain()>0
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil,tp,POS_FACEDOWN)
	local b1=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b3=Duel.GetTurnPlayer()==tp
	if #g>0 and (b1 or b2 or b3) and Duel.GetCurrentChain()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:CancelableSelect(tp,1,Duel.GetCurrentChain()-1,nil)
		if not rg or #rg==0 then return end
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
		local fid=c:GetFieldID()
		local og1=Duel.GetOperatedGroup()
		local ct=og1:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
		if og1:IsExists(cm.retfilter2,1,nil,tp,LOCATION_HAND) then Duel.ShuffleHand(tp) end
		if og1:IsExists(cm.retfilter2,1,nil,1-tp,LOCATION_HAND) then Duel.ShuffleHand(1-tp) end
		local og=og1:Filter(cm.rffilter,nil)
		if og and #og>0 then
			for oc in aux.Next(og) do
				oc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(11451461,0))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(og)
			e1:SetCondition(cm.retcon)
			e1:SetOperation(cm.retop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
		if ct<1 then return end
		local a1,a2,a3=false,false,false
		for i=1,ct do
			b1=not a1 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
			b2=not a2 and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			local ct=0
			local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SET_SUMMON_COUNT_LIMIT)}
			for _,te in ipairs(ce) do
				ct=math.max(ct,te:GetValue())
			end
			b3=not a3 and ct<2 and Duel.GetTurnPlayer()==tp
			if not (b1 or b2 or b3) then return end
			local opt=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,1)},{b2,aux.Stringid(m,2)},{b3,aux.Stringid(m,3)})
			if opt==1 then
				a1=true
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
				if #sg>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
					Duel.ConfirmCards(1-tp,sg)
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(m,6))
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
					e1:SetCode(EFFECT_PUBLIC)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					sg:GetFirst():RegisterEffect(e1)
				end
			elseif opt==2 then
				a2=true
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local sg=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
				if #sg>0 and (not (sg:GetFirst():IsLocation(LOCATION_MZONE) and sg:GetFirst():IsCanTurnSet()) or (sg:GetFirst():IsAbleToHand() and Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5))==0)) then
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
				elseif #sg>0 then
					Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
				end
			elseif opt==3 then
				a3=true
				local num=1
				local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SET_SUMMON_COUNT_LIMIT)}
				for _,te in ipairs(ce) do
					num=math.max(num,te:GetValue())
				end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetValue(num+1)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end  
end
function cm.retfilter2(c,p,loc)
	if (c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousTypeOnField()&TYPE_EQUIP>0) or c:IsPreviousLocation(LOCATION_FZONE) then return false end
	return c:IsPreviousControler(p) and c:IsPreviousLocation(loc)
end
function cm.rffilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function cm.returntofield(tc)
	if tc:IsPreviousLocation(LOCATION_FZONE) then
		local p=tc:GetPreviousControler()
		local gc=Duel.GetFieldCard(p,LOCATION_FZONE,0)
		if gc then
			Duel.SendtoGrave(gc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		return
	end
	if tc:GetPreviousTypeOnField()&TYPE_EQUIP>0 then
		Duel.SendtoGrave(tc,REASON_RULE+REASON_RETURN)
	else
		Duel.ReturnToField(tc)
	end
end
function cm.filter6(c,e)
	return c:GetFlagEffectLabel(m)==e:GetLabel()
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.filter6,1,nil,e) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(cm.filter6,nil,e)
	g:DeleteGroup()
	local ft,mg,pft,pmg={},{},{},{}
	ft[1]=Duel.GetLocationCount(tp,LOCATION_MZONE)
	ft[2]=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	ft[3]=Duel.GetLocationCount(tp,LOCATION_SZONE)
	ft[4]=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	pft[3],pft[4]=0,0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then pft[3]=pft[3]+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then pft[3]=pft[3]+1 end
	if Duel.CheckLocation(1-tp,LOCATION_PZONE,0) then pft[4]=pft[4]+1 end
	if Duel.CheckLocation(1-tp,LOCATION_PZONE,1) then pft[4]=pft[4]+1 end
	mg[1]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_MZONE)
	mg[2]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_MZONE)
	mg[3]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_SZONE)
	mg[4]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_SZONE)
	pmg[3]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_PZONE)
	pmg[4]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_PZONE)
	for i=1,2 do
		if #mg[i]>ft[i] then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451461,7))
			local tg=mg[i]:Select(tp,ft[i],ft[i],nil)
			for tc in aux.Next(tg) do cm.returntofield(tc) end
			sg:Sub(tg)
		end
	end
	for i=3,4 do
		if #mg[i]>ft[i] then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451461,7))
			local ct=math.min(#(mg[i]-pmg[i])+pft[i],ft[i])
			local tg=mg[i]:SelectSubGroup(tp,cm.fselect2,false,ct,ct,pft[i])
			local ptg=tg:Filter(Card.IsPreviousLocation,nil,LOCATION_PZONE)
			for tc in aux.Next(ptg) do cm.returntofield(tc) end
			for tc in aux.Next(tg-ptg) do cm.returntofield(tc) end
			sg:Sub(tg)
		elseif #pmg[i]>pft[i] then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451461,7))
			local tg=pmg[i]:Select(tp,pft[i],pft[i],nil)
			for tc in aux.Next(tg) do cm.returntofield(tc) end
			sg:Sub(tg)
		end
	end
	local psg=sg:Filter(Card.IsPreviousLocation,nil,LOCATION_PZONE)
	for tc in aux.Next(psg) do cm.returntofield(tc) end
	for tc in aux.Next(sg-psg) do
		if tc:GetPreviousLocation()&LOCATION_ONFIELD>0 then
			cm.returntofield(tc)
		elseif tc:IsPreviousLocation(LOCATION_HAND) then
			Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
		end
	end
end