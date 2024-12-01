--征服斗魂 狂龙烬灭
local m=11561071
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,11561071+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11561071.settg)
	e1:SetOperation(c11561071.setop)
	c:RegisterEffect(e1)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_HAND)  
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET) 
	e4:SetRange(LOCATION_SZONE) 
	e4:SetCondition(c11561071.damcon)
	e4:SetTarget(c11561071.damtg)
	e4:SetOperation(c11561071.damop)
	c:RegisterEffect(e4)
	
end
function c11561071.setfilter(c)
	return c:IsSetCard(0x195) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c11561071.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11561071.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c11561071.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,c11561071.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if sc then Duel.SSet(tp,sc)

	end
end
function c11561071.damcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(Card.IsPreviousLocation,nil,1,LOCATION_ONFIELD) 
end 
function c11561071.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
	local xatt=0
	local xg=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_ONFIELD)  
	local tc=xg:GetFirst() 
	while tc do 
	xatt=bit.bor(xatt,tc:GetAttribute())
	tc=xg:GetNext() 
	end 
	local xe=Duel.IsPlayerAffectedByEffect(tp,11561071)
	if xe and bit.band(xatt,xe:GetLabel())==xatt then 
		e:SetLabel(0) 
	else 
		e:SetLabel(1)
	end 
	if xe==nil then 
		local xe=Effect.CreateEffect(e:GetHandler()) 
		xe:SetType(EFFECT_TYPE_FIELD) 
		xe:SetCode(11561071) 
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
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end
function c11561071.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x195) 
end 
function c11561071.TTFfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c11561071.damop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)~=0 then 
		local b1=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c11561071.TTFfilter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) and Duel.GetFlagEffect(tp,21513082)==0 
		local b2=Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) and Duel.GetFlagEffect(tp,31513082)==0 
		local b3=Duel.IsExistingMatchingCard(c11561071.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,41513082)==0 
		local xtable={aux.Stringid(11561071,4)} 
		if b1 then table.insert(xtable,aux.Stringid(11561071,1)) end 
		if b2 then table.insert(xtable,aux.Stringid(11561071,2)) end 
		if b3 then table.insert(xtable,aux.Stringid(11561071,3)) end 
		local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
		Duel.BreakEffect() 
		if xtable[op]==aux.Stringid(11561071,1) then 
			Duel.RegisterFlagEffect(tp,21513082,RESET_PHASE+PHASE_END,0,1)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11561071.TTFfilter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil) 
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end 
		if xtable[op]==aux.Stringid(11561071,2) then 
			Duel.RegisterFlagEffect(tp,31513082,RESET_PHASE+PHASE_END,0,1)
			local sc=Duel.SelectMatchingCard(tp,Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil):GetFirst() 
			Duel.LinkSummon(tp,sc,nil)
		end 
		if xtable[op]==aux.Stringid(11561071,3) then 
			Duel.RegisterFlagEffect(tp,41513082,RESET_PHASE+PHASE_END,0,1)
			local sc=Duel.SelectMatchingCard(tp,c11561071.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst() 
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) 
		end 
	end  
end



