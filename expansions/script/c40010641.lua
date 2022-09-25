--银刺戏法
local m=40010641
local cm=_G["c"..m]
cm.named_with_SilverThorn=1
function cm.SilverThorn(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_SilverThorn
end
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Effect 2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+m)
	e2:SetCost(aux.bfgcost)
	e2:SetCost(cm.cost3)
	e2:SetTarget(cm.pentg)
	e2:SetOperation(cm.penop)
	c:RegisterEffect(e2)  
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(cm.checkcon)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.all(c)
	return (c:IsLevel(0) and c:IsRank(0)) 
		or (c:IsLevelAbove(1) and not c:IsLevel(3,6,9)) 
		or (c:IsRankAbove(1) and not c:IsRank(3,6,9))
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.all,1,nil)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.all,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m,RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsLevel(3,6,9) or c:IsRank(3,6,9))
end
--Effect 1
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if Duel.GetFlagEffect(tp,m)==0 then
		if chk==0 then return true end
		if Duel.GetFlagEffect(tp,m+m*2)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(1,0)
			e1:SetTarget(cm.splimit)
			Duel.RegisterEffect(e1,tp)
		end
	else
		if chk==0 then return Duel.GetFlagEffect(tp,m+m*2)==0 end
	end   
end
function cm.cfm(c,tp)
	local g=Duel.GetMatchingGroup(cm.th,tp,LOCATION_DECK,0,nil)
	g:AddCard(c)
	return not c:IsPublic() and cm.SilverThorn(c)
		and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
		and g:CheckSubGroup(cm.fselect,2,2)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) 
		or Duel.CheckLocation(tp,LOCATION_PZONE,1))
end
function cm.th(c)
	return cm.SilverThorn(c)
		and c:IsType(TYPE_PENDULUM)
end
function cm.fselect(g)
	return g:IsExists(Card.IsAbleToHand,1,nil) and not g:IsExists(Card.IsForbidden,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(cm.cfm,tp,LOCATION_HAND,0,1,nil,tp) 
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cfm,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SetTargetCard(g:GetFirst())
	Duel.RegisterFlagEffect(tp,m+m,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) 
		and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0
		and tc:IsLocation(LOCATION_DECK) then
		local g=Duel.GetMatchingGroup(cm.th,tp,LOCATION_DECK,0,nil)
		if  g:CheckSubGroup(cm.fselect,2,2)
			and (Duel.CheckLocation(tp,LOCATION_PZONE,0) 
			or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
			local sg=g:SelectSubGroup(tp,cm.fselect,false,2,2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) 
			local ag=sg:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
			sg:Remove(Card.IsCode,nil,ag:GetFirst():GetCode())
			if Duel.SendtoHand(ag,nil,REASON_EFFECT)>0 
				and ag:GetFirst():IsLocation(LOCATION_HAND)
				and not sg:GetFirst():IsForbidden() then
				Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		end
	end
end
--Effect 2
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFlagEffect(tp,m)==0 then
		if chk==0 then return true end
		if Duel.GetFlagEffect(tp,m+m)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(1,0)
			e1:SetTarget(cm.splimit)
			Duel.RegisterEffect(e1,tp)
		end
	else
		if chk==0 then return Duel.GetFlagEffect(tp,m+m)==0 end
	end   
end
function cm.fg(g)
	return g:GetClassCount(Card.GetLocation)==g:GetCount() and not g:IsExists(Card.IsForbidden,1,nil) 
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.th,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	local pg=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,nil)
	if chk==0 then return #pg==0 and g:CheckSubGroup(cm.fg,2,2) end
	Duel.RegisterFlagEffect(tp,m+m*2,RESET_PHASE+PHASE_END,0,1)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	local pg=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,nil)
	if #pg>0 then return end
	local g=Duel.GetMatchingGroup(cm.th,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=g:SelectSubGroup(tp,cm.fg,false,2,2)
	if sg and sg:GetCount()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local tg=sg:Select(tp,1,1,nil)
		sg:Remove(Card.IsCode,nil,tg:GetFirst():GetCode())
		Duel.MoveToField(tg:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
