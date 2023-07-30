--神赵云
function c11561043.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c11561043.hspcon)
	e2:SetOperation(c11561043.hspop)
	c:RegisterEffect(e2) 
	--xx
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(11561043,6))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetTarget(c11561043.xxtg) 
	e3:SetOperation(c11561043.xxop) 
	c:RegisterEffect(e3) 
	--xxx
	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(11561043,7))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e4:SetCode(EVENT_DISCARD) 
	e4:SetProperty(EFFECT_FLAG_DELAY) 
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCondition(c11561043.xxxcon) 
	e4:SetTarget(c11561043.xxxtg) 
	e4:SetOperation(c11561043.xxxop) 
	c:RegisterEffect(e4) 
	--draw 
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11561043,8)) 
	e5:SetCategory(CATEGORY_DRAW) 
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY) 
	e5:SetRange(LOCATION_MZONE) 
	e5:SetCountLimit(1) 
	e5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandlerPlayer()==Duel.GetTurnPlayer() end)
	e5:SetTarget(c11561043.drtg) 
	e5:SetOperation(c11561043.drop) 
	c:RegisterEffect(e5) 
	local e5=Effect.CreateEffect(c) 
	e5:SetCategory(CATEGORY_DRAW) 
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e5:SetCode(EVENT_DAMAGE) 
	e5:SetRange(LOCATION_MZONE) 
	e5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and 1-tp==rp end)
	e5:SetTarget(c11561043.drtg) 
	e5:SetOperation(c11561043.drop) 
	c:RegisterEffect(e5) 
	--cannot target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
end
function c11561043.eqspfilter(c)
	return c:IsFaceup() and c:IsCode(11561042)
end
function c11561043.hspfilter(c,tp,sc)
	return c:IsRace(RACE_WARRIOR) and c:IsControler(tp) and c:GetEquipGroup():IsExists(c11561043.eqspfilter,1,nil) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0  
end
function c11561043.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c11561043.hspfilter,1,nil,c:GetControler(),c)
end
function c11561043.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c11561043.hspfilter,1,1,nil,tp,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function c11561043.dcgck(g) 
	local x=0 
	if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) and Duel.GetFlagEffect(tp,11561043)~=0 then return false end 
	if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) and Duel.GetFlagEffect(tp,21561043)~=0 then return false end 
	if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) and Duel.GetFlagEffect(tp,31561043)~=0 then return false end 
	if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then x=x+1 end 
	if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then x=x+1 end 
	if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then x=x+1 end 
	return x==1 
end 
function c11561043.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:CheckSubGroup(c11561043.dcgck,1,2) end 
	local dg=g:SelectSubGroup(tp,c11561043.dcgck,false,1,2) 
	if dg:GetFirst():IsType(TYPE_MONSTER) then Duel.RegisterFlagEffect(tp,11561043,RESET_PHASE+PHASE_END,0,1) end 
	if dg:GetFirst():IsType(TYPE_SPELL) then Duel.RegisterFlagEffect(tp,21561043,RESET_PHASE+PHASE_END,0,1) end 
	if dg:GetFirst():IsType(TYPE_TRAP) then Duel.RegisterFlagEffect(tp,31561043,RESET_PHASE+PHASE_END,0,1) end  
	local x=Duel.SendtoGrave(dg,REASON_COST+REASON_DISCARD) 
	e:SetLabel(x) 
end 
function c11561043.desfil(c,atk)  
	return c:IsAttackBelow(atk) and c:IsFaceup()  
end 
function c11561043.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local b1=Duel.IsExistingMatchingCard(c11561043.desfil,tp,0,LOCATION_MZONE,1,nil,c:GetAttack()) 
	local b2=c:IsRelateToEffect(e) 
	local b3=Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil)  
	local b4=true 
	local xtable={} 
	if b1 then table.insert(xtable,aux.Stringid(11561043,1)) end 
	if b2 then table.insert(xtable,aux.Stringid(11561043,2)) end 
	if b3 then table.insert(xtable,aux.Stringid(11561043,3)) end 
	if b4 then table.insert(xtable,aux.Stringid(11561043,4)) end   
	local a=1 
	if e:GetLabel()==2 then a=2 end 
	local b=0 
	while b<a do   
		if b==0 or (b==1 and Duel.SelectYesNo(tp,aux.Stringid(11561043,0))) then
			local x=Duel.SelectOption(tp,table.unpack(xtable))+1  
			local xt=xtable[x]
			table.remove(xtable,x)   
			if xt==aux.Stringid(11561043,1) then 
						local dg=Duel.SelectMatchingCard(tp,c11561043.desfil,tp,0,LOCATION_MZONE,1,1,nil,c:GetAttack()) 
						Duel.Destroy(dg,REASON_EFFECT) 
			end 
			if xt==aux.Stringid(11561043,2) then 
						local e1=Effect.CreateEffect(c) 
						e1:SetType(EFFECT_TYPE_SINGLE) 
						e1:SetCode(EFFECT_SET_ATTACK_FINAL)
						e1:SetRange(LOCATION_MZONE)
						e1:SetValue(c:GetAttack()*2) 
						e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
						c:RegisterEffect(e1)  
			end 
			if xt==aux.Stringid(11561043,3) then 
						local xc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
						--indes
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE) 
						e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
						e1:SetRange(LOCATION_MZONE)
						e1:SetValue(1)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
						xc:RegisterEffect(e1)
						local e2=e1:Clone()
						e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
						xc:RegisterEffect(e2)
			end 
			if xt==aux.Stringid(11561043,4) then 
				Duel.Recover(tp,2000,REASON_EFFECT) 
			end  
		end 
		b=b+1 
	end 
end 
function c11561043.xckfil(c,e,tp) 
	local re=c:GetReasonEffect()
	return c:IsPreviousControler(tp) and re and re:GetHandler()==e:GetHandler() and c:IsReason(REASON_COST)  
end 
function c11561043.xxxcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c11561043.xckfil,1,nil,e,tp)
end 
function c11561043.xxxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end 
end 
function c11561043.xxxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=eg:Filter(c11561043.xckfil,nil,e,tp) 
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst() 
	if tc then 
		Duel.ConfirmCards(1-tp,tc)  
		local flag=0 
		if tc:IsType(TYPE_MONSTER) then flag=bit.bor(flag,TYPE_MONSTER) end 
		if tc:IsType(TYPE_SPELL) then flag=bit.bor(flag,TYPE_SPELL) end 
		if tc:IsType(TYPE_TRAP) then flag=bit.bor(flag,TYPE_TRAP) end  
		if g:IsExists(Card.IsType,1,nil,flag) then 
			Duel.SendtoHand(tc,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,tc) 
		else 
			Duel.ShuffleDeck(tp) 
			if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) then 
				local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil) 
				Duel.Destroy(dg,REASON_EFFECT)   
			end 
		end 
	end 
end 
function c11561043.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(1) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end 
function c11561043.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 and Duel.GetLP(tp)<=2000 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(11561043,5)) then  
		Duel.Draw(tp,1,REASON_EFFECT)
	end 
end 




