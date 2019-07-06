--霓火特警
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c33700137.initial_effect(c)
	  --synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	c:EnableReviveLimit()
	 --Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700137,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetLabel(1)
	e1:SetCondition(c33700137.condition)
	e1:SetOperation(c33700137.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_DECK)
	e2:SetLabel(2)
	e2:SetCondition(c33700137.condition2)
	c:RegisterEffect(e2)
end
function c33700137.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) 
end
function c33700137.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33700137.cfilter,1,nil,1-tp)
end
function c33700137.desfilter(c,eg)
	return  eg:IsExists(c33700137.tyfilter,1,nil,c)
end
function c33700137.tyfilter(c,g)
	return (c:GetType() & g:GetType() & 0x7)>0
end
function c33700137.GroupCheck(g,hg)
	return Senya.CheckGroup(hg,c33700137.GroupCheck2,nil,g:GetCount(),g:GetCount(),g)
end
function c33700137.GroupCheck2(g,sg)
	for i=0,2 do
		local ty=0x1 << i
		if g:FilterCount(Card.IsType,nil,ty)<sg:FilterCount(Card.IsType,nil,ty) then return false end
	end
	return true
end
function c33700137.activate(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()>0 then
		local f=e:GetLabel()==1 and c33700137.cfilter or c33700137.cfilter2
		local dg=eg:Filter(f,nil,1-tp)
		local hg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil)
		Duel.Hint(HINT_CARD,0,33700137) 
		Duel.ConfirmCards(tp,dg)
		if not Senya.CheckGroup(dg,c33700137.GroupCheck,nil,1,63,hg) then return end
		if Duel.SelectYesNo(tp,aux.Stringid(33700137,1)) then
			local sg=Senya.SelectGroup(tp,HINTMSG_DESTROY,dg,c33700137.GroupCheck,nil,1,63,hg)
			local tg=Senya.SelectGroup(tp,HINTMSG_TOGRAVE,hg,c33700137.GroupCheck2,nil,sg:GetCount(),sg:GetCount(),sg)
			Duel.SendtoGrave(tg,REASON_EFFECT)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
function c33700137.cfilter2(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE) and c:GetReasonPlayer()==tp
end
function c33700137.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33700137.cfilter2,1,nil,1-tp)
end