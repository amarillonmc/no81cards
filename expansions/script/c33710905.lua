--流浪的交易者 ～各取所需～
function c33710905.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c33710905.activate)
	c:RegisterEffect(e1)
end
function c33710905.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetMatchingGroupCount(Card.IsAbleToHand,tp,LOCATION_HAND,0,nil)>0 or Duel.GetMatchingGroupCount(Card.IsAbleToHand,1-tp,LOCATION_HAND,0,nil)>0
	local b2=Duel.GetMatchingGroupCount(Card.IsControlerCanBeChanged,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)>0
	local b3=Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,LOCATION_DECK,0,nil)>9 and Duel.GetMatchingGroupCount(Card.IsAbleToDeck,1-tp,LOCATION_DECK,0,nil)>9
	stsck1={1,2,3,4}
	if not b1 then table.remove(stsck1,2) end
	if not b2 then table.remove(stsck1,3) end
	if not b3 then table.remove(stsck1,4) end
	local op=0
	if #stsck1==1 then op=Duel.SelectOption(tp,aux.Stringid(33710905,1)) end
	if #stsck1==2 then op=Duel.SelectOption(tp,aux.Stringid(33710905,stsck1[1]),aux.Stringid(33710905,stsck1[2])) end
	if #stsck1==3 then op=Duel.SelectOption(tp,aux.Stringid(33710905,stsck1[1]),aux.Stringid(33710905,stsck1[2]),aux.Stringid(33710905,stsck1[3])) end
	if #stsck1==4 then op=Duel.SelectOption(tp,aux.Stringid(33710905,1),aux.Stringid(33710905,2),aux.Stringid(33710905,3),aux.Stringid(33710905,4)) end
	local op1=op
	op=stsck1[op1+1]-1
	table.remove(stsck1,op1+1)
	if op==0 then
		local lp1=Duel.GetLP(tp)
		local lp2=Duel.GetLP(1-tp)
		Duel.SetLP(tp,lp2)
		Duel.SetLP(1-tp,lp1)
	elseif op==1 then
		local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local g2=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		if g1:GetCount()==0 and g2:GetCount()==0 then return end
		if g2 then
			Duel.ConfirmCards(tp,g2)
		end
		if g1 then
			Duel.ConfirmCards(1-tp,g1)
		end
		if g2 then
			Duel.SendtoHand(g2,tp,REASON_EFFECT)
		end
		if g1 then
			Duel.SendtoHand(g1,1-tp,REASON_EFFECT)
		end
	elseif op==2 then
		local g1=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,LOCATION_ONFIELD,0,nil)
		local g2=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,1-tp,LOCATION_ONFIELD,0,nil)
		Duel.GetControl(g1,1-tp)
		Duel.GetControl(g2,tp)
	else
		local g1=Duel.GetDecktopGroup(tp,10)
		local g2=Duel.GetDecktopGroup(1-tp,10)
		Duel.SendtoDeck(g2,tp,2,REASON_EFFECT)
		Duel.SendtoDeck(g1,1-tp,2,REASON_EFFECT)
	end
	local num=#stsck1
	tp=1-tp
	local num2=0
	for i=1,num,1 do
		if #stsck1==0 then return end
		if #stsck1==1 then op=Duel.SelectOption(tp,aux.Stringid(33710905,stsck1[1])) end
		if #stsck1==2 then op=Duel.SelectOption(tp,aux.Stringid(33710905,stsck1[1]),aux.Stringid(33710905,stsck1[2])) end
		if #stsck1==3 then op=Duel.SelectOption(tp,aux.Stringid(33710905,stsck1[1]),aux.Stringid(33710905,stsck1[2]),aux.Stringid(33710905,stsck1[3])) end
		local op1=op
		op=stsck1[op1+1]-1
		table.remove(stsck1,op1+1)
		if op==0 then
			local lp1=Duel.GetLP(tp)
			local lp2=Duel.GetLP(1-tp)
			Duel.SetLP(tp,lp2)
			Duel.SetLP(1-tp,lp1)
		elseif op==1 then
			local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			local g2=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
			if g1:GetCount()==0 and g2:GetCount()==0 then return end
			if g2 then
				Duel.ConfirmCards(tp,g2)
			end
			if g1 then
				Duel.ConfirmCards(1-tp,g1)
			end
			if g2 then
				Duel.SendtoHand(g2,tp,REASON_EFFECT)
			end
			if g1 then
				Duel.SendtoHand(g1,1-tp,REASON_EFFECT)
			end
		elseif op==2 then
			local g1=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,LOCATION_ONFIELD,0,nil)
			local g2=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,1-tp,LOCATION_ONFIELD,0,nil)
			Duel.GetControl(g1,1-tp)
			Duel.GetControl(g2,tp)
		else
			local g1=Duel.GetDecktopGroup(tp,10)
			local g2=Duel.GetDecktopGroup(1-tp,10)
			Duel.SendtoDeck(g2,tp,2,REASON_EFFECT)
			Duel.SendtoDeck(g1,1-tp,2,REASON_EFFECT)
		end
		num2=num2+1
		if not Duel.SelectYesNo(tp,aux.Stringid(33710905,5)) or #stsck1==0 then
			Duel.SetLP(tp,Duel.GetLP(tp)+5555*num2)
			return 
		end
	end
	Duel.SetLP(tp,Duel.GetLP(tp)+5555*num2)
end