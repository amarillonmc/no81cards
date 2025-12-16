--征服斗魂 决战之仪
function c11513082.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,11513082+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c:IsSetCard(0x195) end)
	e2:SetValue(function(e) 
	return (Duel.GetFlagEffect(0,11513082)+Duel.GetFlagEffect(1,11513082))*100 end)
	c:RegisterEffect(e2) 
	-- 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,21513082) 
	e3:SetTarget(c11513082.thtg)
	e3:SetOperation(c11513082.thop)
	c:RegisterEffect(e3) 
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_HAND)  
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET) 
	e4:SetRange(LOCATION_FZONE) 
	e4:SetCondition(c11513082.damcon)
	e4:SetTarget(c11513082.damtg)
	e4:SetOperation(c11513082.damop)
	--c:RegisterEffect(e4)
	if not c11513082.global_check then
		c11513082.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(c11513082.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c11513082.checkop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=eg:GetFirst()
	while tc do 
		if tc:IsType(TYPE_MONSTER) and not tc:IsPreviousLocation(LOCATION_DECK) then 
			Duel.RegisterFlagEffect(tc:GetControler(),11513082,RESET_PHASE+PHASE_END,0,1) 
		end 
		tc=eg:GetNext()
	end
end
function c11513082.pbfil(c)
	return not c:IsPublic() and c:IsAbleToDeck()-- and Duel.IsExistingMatchingCard(c11513082.thfil,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c11513082.thfil(c)
	return c:IsSetCard(0x195) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c11513082.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11513082.pbfil,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c11513082.pbfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.ConfirmCards(1-tp,g)
	if g:GetFirst():IsSetCard(0x195) then
		Duel.RaiseEvent(g,EVENT_CUSTOM+9091064,e,REASON_COST,tp,tp,0)
	end
	Duel.ShuffleHand(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end  
function c11513082.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local pc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c11513082.thfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		if Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,tc)  
			if pc:IsRelateToEffect(e) then
				Duel.SendtoDeck(pc,nil,2,REASON_EFFECT) 
			end
		end
	end
end 
function c11513082.damcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(Card.IsPreviousLocation,nil,1,LOCATION_ONFIELD) 
end 
function c11513082.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
	local xatt=0
	local xg=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_ONFIELD)  
	local tc=xg:GetFirst() 
	while tc do 
	xatt=bit.bor(xatt,tc:GetAttribute())
	tc=xg:GetNext() 
	end 
	local xe=Duel.IsPlayerAffectedByEffect(tp,11513082)
	if xe and bit.band(xatt,xe:GetLabel())==xatt then
		e:SetLabel(0) 
	else 
		e:SetLabel(1)
	end 
	if xe==nil then 
		local xe=Effect.CreateEffect(e:GetHandler()) 
		xe:SetType(EFFECT_TYPE_FIELD) 
		xe:SetCode(11513082) 
		xe:SetProperty(EFFECT_FLAG_PLAYER_TARGET) 
		xe:SetTargetRange(1,0) 
		xe:SetLabel(xatt) 
		xe:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(xe,tp)
	else 
		local att=xe:GetLabel()
		att=bit.bor(att,xatt) 
		xe:SetLabel(att) 
	end 
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c11513082.xdamop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM) 
	local x=e:GetLabel() 
	if Duel.Damage(p,d,REASON_EFFECT)~=0 and x~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11513082,0)) then
		Duel.BreakEffect() 
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil) 
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end  
end
function c11513082.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x195) 
end 
function c11513082.damop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)~=0 then 
		local b1=Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,21513082)==0 
		local b2=Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) and Duel.GetFlagEffect(tp,31513082)==0 
		local b3=Duel.IsExistingMatchingCard(c11513082.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,41513082)==0 
		local xtable={aux.Stringid(11513082,4)} 
		if b1 then table.insert(xtable,aux.Stringid(11513082,1)) end 
		if b2 then table.insert(xtable,aux.Stringid(11513082,2)) end 
		if b3 then table.insert(xtable,aux.Stringid(11513082,3)) end 
		local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
		Duel.BreakEffect() 
		if xtable[op]==aux.Stringid(11513082,1) then 
			Duel.RegisterFlagEffect(tp,21513082,RESET_PHASE+PHASE_END,0,1)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil) 
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end 
		if xtable[op]==aux.Stringid(11513082,2) then 
			Duel.RegisterFlagEffect(tp,31513082,RESET_PHASE+PHASE_END,0,1)
			local sc=Duel.SelectMatchingCard(tp,Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil):GetFirst() 
			Duel.LinkSummon(tp,sc,nil)
		end 
		if xtable[op]==aux.Stringid(11513082,3) then 
			Duel.RegisterFlagEffect(tp,41513082,RESET_PHASE+PHASE_END,0,1)
			local sc=Duel.SelectMatchingCard(tp,c11513082.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst() 
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) 
		end 
	end  
end




