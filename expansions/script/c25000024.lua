--黑幕游戏
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckLPCost(tp,1000,true) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.CheckLPCost(1-tp,1000,true) and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0
	end
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	local t={}
	local p={}
	local f=math.floor((lp1)/1000)
	local l=1
	while l<=f and l<=255 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=l do
		t[l]=l*1000
		l=l+1
	end
	local f=math.floor((lp2)/1000)
	local x=1
	while x<=f and x<=255 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=x do
		p[x]=x*1000
		x=x+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local announce1=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(id,0))
	local announce2=Duel.AnnounceNumber(1-tp,table.unpack(p))
	Duel.PayLPCost(tp,announce1,true)
	Duel.PayLPCost(1-tp,announce2,true)
	local ttp=0
	local announce=0
	if announce1>announce2 then
		ttp=tp
		announce=announce1
	elseif announce1==announce2 then
		ttp=2
	else
		ttp=1-tp
		announce=announce2
	end
	Duel.SetTargetPlayer(ttp)
	Duel.SetTargetParam(announce/1000)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if p==2 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Draw(1-tp,1,REASON_EFFECT)
		return
	end
	Duel.ConfirmDecktop(p,d)
	local g=Duel.GetDecktopGroup(p,d)
	if #g>0 then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(p,1,1,nil)
		local sc=sg:GetFirst()
		if sc:IsAbleToHand() then
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sc)
			Duel.ShuffleHand(p)
			g:Sub(sg)
		else
			Duel.SendtoGrave(sc,REASON_RULE)
			g:Sub(sg)
		end
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REVEAL)
	end
end