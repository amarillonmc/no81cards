--曲终的觉悟
local m=33701407
local cm=_G["c"..m]
function cm.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=7-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(1-tp,ct) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,ct)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=7-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ct>0 then
		local ct1=Duel.Draw(p,ct,REASON_EFFECT)
		if ct1~=0 then
			local sp=p
			if Duel.GetFieldGroupCount(1-p,LOCATION_HAND,0) and Duel.SelectYesNo(1-p,aux.Stringid(m,0)) then sp=1-p end
			local t2=Duel.GetMatchingGroupCount(aux.TRUE,p,LOCATION_EXTRA,0,nil)
			local t3=Duel.GetMatchingGroupCount(Card.IsFaceup,1-p,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
			local op=0
			local m={}
			local n={}
			local ct=1
			m[ct]=aux.Stringid(m,1) n[ct]=1 ct=ct+1 end
			if t2 then m[ct]=aux.Stringid(m,2) n[ct]=2 ct=ct+1 end
			if t3 then m[ct]=aux.Stringid(m,3) n[ct]=3 ct=ct+1 end
			local sp=Duel.SelectOption(sp,table.unpack(m))
			op=n[sp+1]
			if op==1 then
				Duel.Recover(1-p,ct1*4200)
			elseif op==2 then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(p,aux.TRUE,tp,LOCATION_EXTRA,0,1,ct1*2,nil)
				Duel.SendtoGrave(g,REASON_RULE)
			elseif op==3 then
				Duel.Hint(HINT_SELECTMSG,1-p,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(1-p,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct1,nil)
				local tc=g:GetFirst()
				while tc do
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetRange(LOCATION_ONFIELD)
					e1:SetCode(EFFECT_IMMUNE_EFFECT)
					e1:SetValue(cm.efilter)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					tc=g:GetNext()
				end
			end
		end
	end
end
function cm.efilter(e,te)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
