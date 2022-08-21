--虚拟YouTuber 虹河Laki
local m=33700354
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c,nil,cm.gcheck,2,63)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.dicecon)
	e2:SetOperation(cm.diceop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TOSS_COIN)
	e3:SetOperation(cm.coinop)
	c:RegisterEffect(e3)
	
end
function cm.gcheck(g)
	return g:GetClassCount(Card.GetCode)==1
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	if op==0 then
		local coinop=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
		_TossCoin=Duel.TossCoin
		function Duel.TossCoin(player,count)	
			local boolflg=false
			local result = {_TossCoin(player,count)}
			local result_ret={}
			for i=0,count do
				if boolflg==false then
					table.insert(result_ret,coinop)
				else	
					table.insert(result_ret,result[i])
				end
			end
			Duel.TossCoin=_TossCoin
			return table.unpack(result_ret) 
		end
	else
		local diceop=Duel.AnnounceNumber(tp,1,2,3,4,5,6)
		_TossDice=Duel.TossDice
		function Duel.TossDice(player,count,count2) 
			local boolflg=true
			local result = {_TossDice(player,count,count2)}
			local result_ret={}
			local sum=count
			if count2 then
				sum=sum+count2
			end
			for i=0,sum do
				if boolflg == true then
					table.insert(result_ret,diceop)
					boolflg=false
				else	
					table.insert(result_ret,result[i])
				end
			end
			Duel.TossDice=_TossDice
			return table.unpack(result_ret) 
		end
	end	  
end
function cm.dicecon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp
end
function cm.diceop(e,tp,eg,ep,ev,re,r,rp)
	local flag=0
	local dc={Duel.GetDiceResult()}
	for _,v in ipairs(dc) do
		if v==6 then
			flag=flag+1
		end
	end
	Duel.Recover(tp,flag*2000,REASON_EFFECT)
end
function cm.coinop(e,tp,eg,ep,ev,re,r,rp)
	local flag=0
	local dc={Duel.GetCoinResult()}
	for _,v in ipairs(dc) do
		if v==1 then
			flag=flag+1
		end
	end
	Duel.Recover(tp,flag*2000,REASON_EFFECT)
end