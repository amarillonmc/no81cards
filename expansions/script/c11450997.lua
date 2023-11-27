--如是我闻
local cm,m=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
local KOISHI_CHECK=false
if Card.SetEntityCode then KOISHI_CHECK=true end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,e:GetHandler())
end
function cm.nfilter(c)
	return c:GetOriginalCode()==m
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if cm[c]~=1 then
		if Duel.GetFlagEffect(tp,m)>0 or cm[c]==2 then cm[c]=nil return end
		local g=Duel.GetMatchingGroup(cm.nfilter,tp,LOCATION_HAND+LOCATION_DECK,0,c)
		if not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			for rc in aux.Next(g) do cm[rc]=2 end
			return
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		g:AddCard(c)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc~=c then
			Debug.Message(tc:GetLocation())
			for rc in aux.Next(g) do cm[rc]=2 end
			cm[tc]=1
			cm[c]=nil
			return
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,c)
	if #g>0 then
		cm[c]=nil
		Duel.ConfirmCards(1-tp,g)
		Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
		if KOISHI_CHECK then
			local code=g:GetFirst():GetOriginalCode()
			c:SetEntityCode(code)
			if not g:GetFirst():IsType(TYPE_NORMAL) or g:GetFirst():IsType(TYPE_PENDULUM) then
				c:ReplaceEffect(code,0)
			else
				local ini=cm.initial_effect
				cm.initial_effect=function() end
				c:ReplaceEffect(m,0)
				cm.initial_effect=ini
			end
		else
			local loc=c:GetLocation()
			Duel.SendtoGrave(c,REASON_EFFECT)
			c=Duel.CreateToken(tp,g:GetFirst():GetOriginalCode())
			if loc==LOCATION_HAND then
				Duel.SendtoHand(c,nil,0)
				Duel.ConfirmCards(1-tp,c)
			else
				Duel.SendtoDeck(c,nil,2,0)
			end
		end
	end
end