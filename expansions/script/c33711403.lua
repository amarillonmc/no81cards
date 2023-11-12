--肉欲之壶
local m=33711403
local cm=_G["c"..m]
function cm.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK+CATEGORY_TOEXTRA+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.cfilter1(c)
	return c:IsAbleToExtra()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local num2=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
	if chk==0 then
		return (Duel.IsPlayerCanDraw(tp,1) and num>=5) or num2>=5
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local num=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local num2=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
	local a1=num2>=5 
	local a2=num2>=10
	local a3=Duel.IsPlayerCanDraw(tp,1) and num>=5
	local a4=Duel.IsPlayerCanDraw(tp,2) and num>=10
	local op=5
	if a1 and a2 and a3 and a4 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3),aux.Stringid(m,4))
	elseif a1 and a2 and a3 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
	elseif a1 and a2 and a4 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,4))
		if op==2 then
			op=3
		end
	elseif a1 and a3 and a4 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,3),aux.Stringid(m,4))+1
		if op==1 then
			op=0
		end
	elseif a2 and a3 and a4 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3),aux.Stringid(m,4))+1
	elseif a1 and a2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif a1 and a3 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,3))
		if op==1 then
			op=2
		end
	elseif a1 and a4 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,4))
		if op==1 then
			op=3
		end
	elseif a2 and a3 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))+1
	elseif a2 and a4 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,4))+1
		if op==2 then
			op=3
		end
	elseif a3 and a4 then
		op=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))+2
	elseif a1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1))
	elseif a2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	elseif a3 then
		op=Duel.SelectOption(tp,aux.Stringid(m,3))+2
	elseif a4 then
		op=Duel.SelectOption(tp,aux.Stringid(m,4))+3
	end
	if op==0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
		local sg=g:RandomSelect(tp,5)
		local sg1=sg:Filter(Card.IsFaceup,nil)
		local sg2=Group.__sub(sg,sg1)
		Duel.Remove(sg2,POS_FACEDOWN,0)
		Duel.SendtoDeck(sg2,1-tp,2,REASON_EFFECT)
		Duel.Remove(sg1,POS_FACEDOWN,0)
		Duel.SendtoExtraP(sg1,1-tp,REASON_EFFECT)
		local sg3=sg:Filter(cm.filter,nil,tp)
		if sg3:GetCount()>4 then
			Duel.Recover(tp,2000,REASON_EFFECT)
		end
	end
	if op==1 then
		local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
		local sg=g:RandomSelect(tp,10)
		local sg1=sg:Filter(Card.IsType,nil,TYPE_PENDULUM)
		local sg2=Group.__sub(sg,sg1)
		Duel.Remove(sg2,POS_FACEDOWN,0)
		Duel.SendtoDeck(sg2,1-tp,2,REASON_EFFECT)
		Duel.Remove(sg1,POS_FACEDOWN,0)
		Duel.SendtoExtraP(sg1,1-tp,REASON_EFFECT)
		Duel.ShuffleExtra(1-tp)
		local sg3=sg:Filter(cm.filter,nil,tp)
		if sg3:GetCount()>4 and sg3:GetCount()<10 then
			Duel.Recover(tp,2000,REASON_EFFECT)
		end
		if sg3:GetCount()>9 then
			Duel.Recover(tp,4000,REASON_EFFECT)
		end
	end
	if op==2 then
		local g=Duel.GetDecktopGroup(tp,5)
		Duel.ConfirmDecktop(tp,5)
		if Duel.SendtoDeck(g,1-tp,2,REASON_EFFECT)==5 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
	if op==3 then
		local g=Duel.GetDecktopGroup(tp,10)
		Duel.ConfirmDecktop(tp,10)
		if Duel.SendtoDeck(g,1-tp,2,REASON_EFFECT)==10 then
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end
function cm.filter(c,tp)
	return c:IsLocation(LOCATION_EXTRA) and c:IsControler(1-tp)
end