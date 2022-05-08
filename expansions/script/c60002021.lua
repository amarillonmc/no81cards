--时光酒桌 意识
local m=60002021
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c60002009") end) then require("script/c60002009") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(timeTable.actionCon)
	e1:SetTarget(cm.actg)
	e1:SetOperation(cm.acop)
	c:RegisterEffect(e1)
	timeTable.spell(c,cm.extra3,cm.extra5)
	timeTable.globle(c)
end
--e1
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if chk==0 then return g:GetCount()==Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil) and g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),tp,LOCATION_HAND) 
	if Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,0,nil):GetCount()>=3 then 
		Duel.SetChainLimit(cm.chlimit)
	end
end
function cm.ckfil(c)
	return c:IsSetCard(0x629) or (c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER))
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function cm.ssfil(c)
	return c:IsSSetable() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)  
	local x=g:FilterCount(cm.ckfil,nil)
	if x>=0 then
		Duel.Draw(tp,x,REASON_EFFECT) 
		local tc=g:GetFirst()
		while tc do 
			local code=tc:GetCode()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(cm.aclimit)
			e1:SetLabel(code)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)  
			tc=g:GetNext()
		end
	end 
	if x>=2 then 
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if x>=4 and g:IsExists(cm.ssfil,1,nil) then
		local sc=g:FilterSelect(tp,cm.ssfil,1,1,nil):GetFirst()
		Duel.SSet(tp,sc)
	end
end
--e2
function cm.extra3(e,tp)
	local g=Duel.GetMatchingGroup(cm.setfilter,tp,LOCATION_HAND,0,nil) 
	local ct=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),g:GetCount())
	if ct>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,1,ct,nil)
		Duel.SSet(tp,sg)
		local tc=sg:GetFirst()
		while tc do 
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)   
			tc=sg:GetNext()
		end
	end
end
function cm.extra5(e,tp)
	if Duel.IsExistingMatchingCard(cm.thfil1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.thfil2,tp,LOCATION_DECK,0,1,nil) then 
		local g1=Duel.SelectMatchingCard(tp,cm.thfil1,tp,LOCATION_DECK,0,1,1,nil) 
		local g2=Duel.SelectMatchingCard(tp,cm.thfil2,tp,LOCATION_DECK,0,1,1,nil) 
		g1:Merge(g2)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
function cm.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER) and c:IsSSetable()
end
function cm.thfil1(c)
	return c:IsSetCard(0x629) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thfil2(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER) and c:IsAbleToHand()
end