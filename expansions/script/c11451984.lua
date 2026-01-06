--恶兆扳机
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_DESTROY+CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.toss_dice=true
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,2)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d1,d2=Duel.TossDice(tp,2)
	CURSE_TRIGGER_DIVE=0
	CURSE_TRIGGER_FIN=0
	local e1=Effect.CreateEffect(c)
	local code=EVENT_CUSTOM+m+e1:GetFieldID()
	e:SetValue(code)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(code)
	e1:SetValue(code)
	e1:SetOperation(cm.dice)
	e1:SetReset(RESET_CHAIN)
	--Duel.RegisterEffect(e1,tp)
	cm.dice(e,tp,eg,ep,d1,re,r,rp)
	cm.dice(e,tp,eg,ep,d2,re,r,rp)
	CURSE_TRIGGER_DIVE=0
	CURSE_TRIGGER_FIN=0
	--Duel.RaiseEvent(c,code,e,r,rp,ep,d1)
	--Duel.RaiseEvent(c,code,e,r,rp,ep,d2)
end
function cm.dice(e,tp,eg,ep,d,re,r,rp)
	--Debug.Message(CURSE_TRIGGER_DIVE)
	if CURSE_TRIGGER_FIN>0 then return end
	if CURSE_TRIGGER_DIVE>3 and CURSE_TRIGGER_FIN==0 then
		CURSE_TRIGGER_FIN=1
		Debug.Message("recursive event trigger detected.")
		Debug.Message("[string \"./script/c11451984.lua\"]:47: attempt to index a nil value (local 'e')")
	end
	local c=e:GetHandler()
	if CURSE_TRIGGER_FIN==0 and d==1 then
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		local t={}
		if #g>0 then t[#t+1]=2 end
		t[#t+1]=3
		if Duel.IsPlayerCanDraw(tp,1) then t[#t+1]=4 end
		t[#t+1]=5
		if c:IsRelateToEffect(e) and c:IsCanTurnSet() and c:IsFaceup() then t[#t+1]=6 end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,CURSE_TRIGGER_DIVE))
		local d1=Duel.AnnounceNumber(tp,table.unpack(t))
		Duel.Hint(HINT_NUMBER,1-tp,d1)
		CURSE_TRIGGER_DIVE=CURSE_TRIGGER_DIVE+1
		cm.dice(e,tp,eg,ep,d1,re,r,rp)
		--Duel.RaiseEvent(c,e:GetValue(),re,r,rp,ep,d1)
		CURSE_TRIGGER_DIVE=CURSE_TRIGGER_DIVE-1
	elseif d==2 then
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		if sc then
			local p=sc:GetControler()
			if Duel.Destroy(sc,REASON_EFFECT)>0 then Duel.Draw(p,1,REASON_EFFECT) end
		end
	elseif d==3 then
		local d1=Duel.TossDice(tp,1)
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		if not (d1==2 and #g==0) and not (d1==4 and not Duel.IsPlayerCanDraw(tp,1)) and not (d1==6 and not (c:IsRelateToEffect(e) and c:IsCanTurnSet() and c:IsFaceup())) and CURSE_TRIGGER_FIN==0 and Duel.SelectYesNo(tp,aux.Stringid(m,4+CURSE_TRIGGER_DIVE)) then
			CURSE_TRIGGER_DIVE=CURSE_TRIGGER_DIVE+1
			cm.dice(e,tp,eg,ep,d1,re,r,rp)
			--Duel.RaiseEvent(c,e:GetValue(),re,r,rp,ep,d1)
			CURSE_TRIGGER_DIVE=CURSE_TRIGGER_DIVE-1
		end
	elseif d==4 then
		if Duel.Draw(tp,1,REASON_EFFECT)>0 then
			Duel.ShuffleHand(tp)
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	elseif d==5 then
		local d1,d2=Duel.TossDice(tp,2)
		CURSE_TRIGGER_DIVE=CURSE_TRIGGER_DIVE+1
		cm.dice(e,tp,eg,ep,d1,re,r,rp)
		cm.dice(e,tp,eg,ep,d2,re,r,rp)
		--Duel.RaiseEvent(c,e:GetValue(),re,r,rp,ep,d1)
		--Duel.RaiseEvent(c,e:GetValue(),re,r,rp,ep,d2)
		CURSE_TRIGGER_DIVE=CURSE_TRIGGER_DIVE-1
	elseif d==6 then
		if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end