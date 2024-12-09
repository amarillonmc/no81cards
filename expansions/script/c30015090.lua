--终墟鸟击
local m=30015090
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	--e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.postg)
	e1:SetOperation(cm.posop)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=ors.redraw(c)
	--all
	local e9=ors.alldrawflag(c)
end
c30015090.isoveruins=true
--Activate
function cm.ff(c,tp,loc,e) 
	local tg=Group.CreateGroup()
	tg:AddCard(e:GetHandler())
	tg:AddCard(c)
	return Duel.IsExistingTarget(nil,tp,loc,loc,2,tg)   
end  
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local loc=LOCATION_ONFIELD 
	local check=Duel.IsExistingTarget(cm.ff,tp,loc,0,1,e:GetHandler(),tp,loc,e)
	if chk==0 then return check end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,cm.ff,tp,loc,0,1,1,e:GetHandler(),tp,loc,e)
	local tg=Group.CreateGroup()
	tg:AddCard(e:GetHandler())
	tg:AddCard(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,nil,tp,loc,loc,2,2,tg)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,#g1,0,0)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(sg,REASON_EFFECT)==0 then return false end
	local og=Duel.GetOperatedGroup()
	local res=1
	cm.exrmop(e,tp,res,og)
end

-----
function cm.exrmop(e,tp,res,exg)
	if res==0 then return false end
	Duel.BreakEffect()
	local ec=e:GetHandler()
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(ors.rf),tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,exg,1-tp) 
	if #rg>0 and Duel.SelectYesNo(1-tp,aux.Stringid(30015500,4)) and Duel.IsPlayerCanRemove(1-tp) then
		Duel.Hint(HINT_CARD,0,ec:GetOriginalCodeRule())
		Duel.ConfirmCards(1-tp,rg)
		local sg=Group.CreateGroup()
		local g2=rg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		local g3=rg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		local g4=rg:Filter(Card.IsLocation,nil,LOCATION_DECK)
		local ct=3
		if #g2>0 and ct>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(30015500,1))
			local sg2=g2:FilterSelect(1-tp,aux.NecroValleyFilter(ors.rf),0,ct,nil,1-tp)
			ct=ct-#sg2
			sg:Merge(sg2)
		end 
		if #g3>0 and ct>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(30015500,2))
			local sg3=g3:FilterSelect(1-tp,aux.NecroValleyFilter(ors.rf),0,ct,nil,1-tp)
			ct=ct-#sg3
			sg:Merge(sg3)
		end
		if #g4>0 and ct>0 then
			local nt=0
			if ct==3 then nt=1 end
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(30015500,3))
			local sg4=g4:FilterSelect(1-tp,aux.NecroValleyFilter(ors.rf),nt,ct,nil,1-tp)
			ct=ct-#sg4
			sg:Merge(sg4)
		end
		if #sg==0 then return false end
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if og:FilterCount(Card.IsPreviousLocation,nil,LOCATION_DECK)>0 then
			Duel.ShuffleDeck(tp)
		end
		if og:FilterCount(Card.IsPreviousLocation,nil,LOCATION_EXTRA)>0 then
			Duel.ShuffleExtra(tp)
		end
	end
end
