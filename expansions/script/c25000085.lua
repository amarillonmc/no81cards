--蝴蝶梦
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000085)
function cm.initial_effect(c)
	c:SetUniqueOnField(1,1,m)
	local e0=rsef.ACT(c)
	local e1=rsef.FC(c,EVENT_PHASE+PHASE_STANDBY,nil,{1,m},nil,LOCATION_DECK,cm.thcon,cm.thop)   
	local e2=rsef.FTF(c,EVENT_PHASE+PHASE_STANDBY,{m,3},1,"rm,td",nil,LOCATION_SZONE,nil,nil,cm.rmtg,cm.rmop)
	local e3=rsef.QO(c,nil,{m,4},nil,nil,nil,LOCATION_SZONE,nil,rscost.cost(Card.IsAbleToGrave,"tg"),nil,cm.damop)
end
function cm.damop(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function cm.rmop(e,tp)
	local c=e:GetHandler()
	local plist={Duel.GetTurnPlayer(),1-Duel.GetTurnPlayer()}
	for index=1,2 do
		local p=plist[index]
		local dg=Duel.GetMatchingGroup(Card.IsAbleToRemove,p,LOCATION_DECK,0,nil)
		if #dg>=5 then
			local rg=dg:RandomSelect(p,5)
			if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 then
				local og=Duel.GetOperatedGroup()
				if #og>0 and Duel.SendtoDeck(og,1-p,2,REASON_EFFECT)>0 then
					og=Duel.GetOperatedGroup()
					Duel.ShuffleDeck(1-p)
					--og:ForEach(cm.nfun,c)
					local dg2=Duel.GetMatchingGroup(Card.IsAbleToRemove,p,LOCATION_EXTRA,0,nil,POS_FACEDOWN,REASON_RULE)
					if og:IsExists(Card.IsCode,1,nil,m-1) and #dg2>=3 then 
						local rg2=dg2:RandomSelect(p,3)
						if Duel.Remove(rg2,POS_FACEDOWN,REASON_RULE)>0 then
							local og2=Duel.GetOperatedGroup()
							Duel.SendtoDeck(og2,1-p,2,REASON_EFFECT)
						end
					end
				end
			end
		end
	end
end
function cm.nfun(tc,c)
	tc:ReverseInDeck()
	tc:RegisterFlagEffect(m,rsreset.est,0,1)
	local e1=rsef.SV_ADD({c,tc,true},"code",25010013,nil,rsreset.est)
end
function cm.tdfilter(c)
	return Duel.IsPlayerCanSendtoDeck(c:GetControler(),c)
end
function cm.thcon(e,tp)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanSendtoHand(tp,c) 
	local b2=not c:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:CheckUniqueOnField(tp)
	return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_HAND,0,2,nil) and (b1 or b2) and Duel.IsExistingMatchingCard(rscf.fufilter(Card.IsCode,25010013),tp,LOCATION_DECK,0,1,nil)
end
function cm.thop(e,tp)
	rshint.Card(m)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanSendtoHand(tp,c)
	local b2=not c:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:CheckUniqueOnField(tp)
	local op=rsop.SelectOption(tp,true,{m,0},b1,{m,1},b2,{m,2})
	if op==1 then return end
	rsop.SelectToDeck(tp,cm.tdfilter,tp,LOCATION_HAND,0,2,2,nil,{nil,2,REASON_RULE })
	if op==2 then
		Duel.SendtoHand(c,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,c)
	elseif op==3 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end