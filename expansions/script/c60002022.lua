--时光酒桌 年华
local m=60002022
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c60002009") end) then require("script/c60002009") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
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
function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=10 end 
	if Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,0,nil):GetCount()>=3 then 
		Duel.SetChainLimit(cm.chlimit)
	end
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.ckfil(c)
	return c:IsSetCard(0x629) or (c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER))
end
function cm.thfil1(c)
	return c:IsAbleToHand() and (c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER))
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<10 then return end
	Duel.ConfirmDecktop(tp,10)
	local g=Duel.GetDecktopGroup(tp,10)
	local count=g:FilterCount(cm.ckfil,nil)--counter and 0x629
	local cg=Group.CreateGroup()
	if count>=0 and g:FilterCount(cm.thfil1,nil)>0 then
		local tc=g:FilterSelect(tp,cm.thfil1,1,1,nil):GetFirst()
		if Duel.SendtoHand(tc,tp,REASON_EFFECT)>0 then
			cg:AddCard(tc)
			Duel.ConfirmCards(1-tp,tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(cm.aclimit)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
	if count>=2 and Duel.IsPlayerCanDraw(tp,1) then
		cg:Merge(Duel.GetDecktopGroup(tp,1))
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if count>=4 and g:FilterCount(Card.IsAbleToHand,cg)>0 then
		local g3=g:FilterSelect(tp,Card.IsAbleToHand,1,1,cg)
		Duel.SendtoHand(g3,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g3)
	end
end
--e2
function cm.setf(c)
	return c:IsSSetable() and c:IsSetCard(0x629) and c:IsType(TYPE_MONSTER)
end
function cm.extra3(e,tp)
	if Duel.IsExistingMatchingCard(cm.setf,tp,LOCATION_GRAVE,0,2,nil) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SelectMatchingCard(tp,cm.setf,tp,LOCATION_GRAVE,0,2,2,nil)
		local tc=sg:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true) 
			Duel.ConfirmCards(1-tp,tc)
			timeTable.getCounter(tc)
			tc=sg:GetNext()
		end
	end
end
function cm.extra5(e,tp)
	if Duel.IsPlayerCanDraw(tp,3) then 
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end