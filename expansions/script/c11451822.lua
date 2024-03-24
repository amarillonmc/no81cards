--波动连携·叠波干涉
local cm,m=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.filter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e) and c:IsLevelAbove(1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	if chk==0 then return #mg>=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg1=mg:Select(tp,2,#mg,nil)
	Duel.SetTargetCard(sg1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ct=tg:FilterCount(Card.IsRelateToEffect,nil,e)
	if ct~=#tg then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetOperation(cm.spop)
	Duel.RegisterEffect(e2,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetLabelObject(e2)
	Duel.RegisterEffect(e1,tp)
	local eid=e1:GetFieldID()
	e1:SetLabel(eid)
	e1:SetCondition(function(e)
						local eid=e:GetLabel()
						local sg=Duel.GetMatchingGroup(cm.cfilter2,0,LOCATION_MZONE,LOCATION_MZONE,nil,eid)
						return #sg==ct
					end)
	e1:SetTarget(function(e,c)
					local eid=e:GetLabel()
					local sg=Duel.GetMatchingGroup(cm.cfilter2,0,LOCATION_MZONE,LOCATION_MZONE,nil,eid)
					local res=sg:IsContains(c)
					--[[if res and Duel.GetFlagEffect(tp,m)>0 then
						local tab={e:GetLabelObject():GetLabel()}
						for tc in aux.Next(sg) do table.insert(tab,tc:GetLevel()) end
						e:GetLabelObject():SetLabel(table.unpack(tab))
					end--]]
					return res
				end)
	e1:SetValue(function(e,te)
					local eid=e:GetLabel()
					local res=te:IsActivated() and e:GetOwnerPlayer()~=te:GetOwnerPlayer()
					local sg=Duel.GetMatchingGroup(cm.cfilter2,0,LOCATION_MZONE,LOCATION_MZONE,nil,eid)
					if res then
						Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
						local tab={}
						for tc in aux.Next(sg) do table.insert(tab,tc:GetLevel()) end
						e:GetLabelObject():SetLabel(table.unpack(tab))
					end
					return false
				end)
	for tc in aux.Next(tg) do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,eid,aux.Stringid(m,0))
	end
end
function cm.cfilter2(c,eid)
	return c:IsFaceup() and c:GetFlagEffect(m)~=0 and c:GetFlagEffectLabel(m)==eid
end
function cm.spfilter(c,e,tp)
	if not (c:IsRace(RACE_PSYCHO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end
	for _,lv in pairs({e:GetLabel()}) do
		if c:IsLevel(lv) then return false end
	end
	return true
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and Duel.GetFlagEffect(tp,m)>0 then
		local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	e:SetLabel(0)
	Duel.ResetFlagEffect(tp,m)
end
function cm.rfilter(c)
	return c:GetPreviousLocation()==LOCATION_REMOVED and c:GetPreviousPosition()&POS_FACEDOWN>0
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and eg:IsExists(cm.rfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end