--彼时此刻
function c11561002.initial_effect(c) 
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DICE) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,11561002+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c11561002.accost)
	e1:SetTarget(c11561002.actg) 
	e1:SetOperation(c11561002.acop) 
	c:RegisterEffect(e1) 
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c11561002.regop)
	c:RegisterEffect(e2)	
end
c11561002.toss_dice=true  
aux.c11561002dcrc={} 
function c11561002.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000,true) end
	local lp=Duel.GetLP(tp)
	local t={}
	local f=math.floor((lp)/1000)
	local l=1
	while l<=f and l<=20 do
		t[l]=l*1000
		l=l+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11561002,0))
	local announce=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,announce,true)
	e:SetLabel(announce)
end 
function c11561002.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
	local lp=e:GetLabel()
	local x=math.floor((lp)/1000)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,x) 
end  
function c11561002.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local lp=e:GetLabel()
	local x=math.floor((lp)/1000)
	for i=1,x do  
		local dc=Duel.TossDice(tp,1) 
		table.insert(aux.c11561002dcrc,dc) 
	end 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TOSS_DICE_NEGATE) 
	e1:SetCondition(c11561002.dicecon)
	e1:SetOperation(c11561002.diceop)
	Duel.RegisterEffect(e1,tp)  
end 
function c11561002.dicecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return #aux.c11561002dcrc>0  
end
function c11561002.diceop(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if Duel.SelectYesNo(tp,aux.Stringid(11561002,1)) then
		Duel.Hint(HINT_CARD,0,11561002) 
		local dc={Duel.GetDiceResult()}
		local ac=1
		local ct=(ev&0xff)+(ev>>16&0xff)
		if ct>1 then
			--choose the index of results
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11561002,2))
			local val,idx=Duel.AnnounceNumber(tp,table.unpack(aux.idx_table,1,ct))
			ac=idx+1
		end   
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11561002,3)) 
		local a,b=Duel.AnnounceNumber(tp,table.unpack(aux.c11561002dcrc)) 
		local x=#aux.c11561002dcrc  
		local y=0 
		for i=1,x do  
			if y==0 and aux.c11561002dcrc[i]==a then  
				table.remove(aux.c11561002dcrc,i)  
				y=y+1 
			end   
		end 
		dc[ac]=a
		Duel.SetDiceResult(table.unpack(dc))
	end
end
function c11561002.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCost(aux.bfgcost) 
	e1:SetTarget(c11561002.thtg)
	e1:SetOperation(c11561002.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c11561002.thfilter(c)
	return c.toss_dice and c:IsAbleToHand()
end
function c11561002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11561002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11561002.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11561002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end



