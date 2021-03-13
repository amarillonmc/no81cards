--邪魂之源 亚奥斯克
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm=rscf.DefineCard(30010000)
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),12,5,12)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	local e2,e3=rsef.SV_CANNOT_DISABLE_S(c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(0xff)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetValue(cm.efilter)
	c:RegisterEffect(e4)
	local e5=rsef.FTF(c,EVENT_PHASE+PHASE_STANDBY,{m,0},1,"se,th",nil,LOCATION_PZONE,nil,nil,nil,cm.thop)
	local e6=rsef.SV_CANNOT_DISABLE(c,"sp")
	local e7=rsef.SV_IMMUNE_EFFECT(c,rsval.imes)
	local e8=rsef.FV_REDIRECT(c,"tg",LOCATION_REMOVED,nil,{0xff,0xff})
	local e9,e10=rsef.SV_SET(c,"batk,bdef",cm.val)
	local e11=rsef.SV_LIMIT(c,"datk")
	local e12=rsef.QO(c,nil,{m,1},1,nil,nil,LOCATION_MZONE,nil,rscost.rmxyz(2),nil,cm.limitop)
	local e13=rsef.QF(c,EVENT_SUMMON,{m,2},nil,"rm,diss",nil,LOCATION_MZONE,cm.disscon,nil,cm.disstg,cm.dissop)
	local e14=rsef.QF(c,EVENT_CHAINING,{m,3},nil,"rm,neg","dsp,dcal",LOCATION_MZONE,cm.negcon,nil,cm.negtg,cm.negop)
	local e15=rsef.FTF(c,EVENT_PHASE+PHASE_END,{m,6},1,"rm",nil,LOCATION_MZONE,nil,nil,cm.rmtg,cm.rmop)
	local e16=rsef.I(c,{m,9},nil,"rm,dam",nil,LOCATION_MZONE,cm.damcon,rscost.rmxyz(1),cm.rmtg2,cm.rmop2)
	local e17=rsef.STF(c,EVENT_LEAVE_FIELD,{m,10},nil,"td,dam",nil,cm.lmcon,nil,cm.lmtg,cm.lmop)
	local e18=rsef.STF(c,EVENT_LEAVE_FIELD,{m,11},nil,nil,nil,cm.lmcon,nil,nil,cm.pop)
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function cm.lmcon(e,tp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function cm.lmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function cm.lmop(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,aux.ExceptThisCard(e))
	if #g>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,rsloc.de)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,ct*500,REASON_EFFECT,true)
			Duel.Damage(tp,ct*300,REASON_EFFECT,true)
			Duel.RDComplete()
		end
	end
end
function cm.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,rsloc.hg,0,nil)
	if chk==0 then return #g>0 and c:IsAbleToRemove() end
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#g*300)
end
function cm.rmop2(e,tp)
	local c=rscf.GetSelf(e)
	if c and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)>0 and c:IsLocation(LOCATION_REMOVED) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,rsloc.hg,0,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
			if ct>0 then
				Duel.Damage(1-tp,(ct+1)*300,REASON_EFFECT)
			end
		end
	end
end
function cm.damcon(e,tp)
	return e:GetHandler():GetOverlayCount()==1
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,rsloc.hog,LOCATION_ONFIELD,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function cm.rmop(e,tp)
	local c=rscf.GetSelf(e)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,rsloc.hog,LOCATION_ONFIELD,c)
	local b1=#g>0
	local b2=c and c:IsAbleToRemove()
	local op=rsop.SelectOption(tp,b1,{m,7},b2,{m,8})
	local rg=op==1 and g:Clone() or c
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0 and rp~=tp and Duel.IsChainNegatable(ev) 
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and aux.nbcon(tp,re)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,rsloc.hog)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,rsloc.hog,nil)
	local b1=#rg>0
	local b2=Duel.IsChainNegatable(ev) and aux.nbcon(tp,re)
	local op=rsop.SelectOption(1-tp,b1,{m,4},b2,{m,5})  
	if op==1 then
		rsgf.SelectRemove(rg,1-tp,aux.TRUE,1,1,nil,{})
	else
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.disfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function cm.disscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and e:GetHandler():GetFlagEffect(m)>0 and eg:IsExists(cm.disfilter,1,nil,1-tp)
end
function cm.disstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(cm.disfilter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,rsloc.hog)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,#g,0,0)
end
function cm.dissop(e,tp,eg)
	local g=eg:Filter(cm.disfilter,nil,1-tp)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,rsloc.hog,nil)
	local op=rsop.SelectOption(1-tp,#rg>0,{m,4},true,{m,5})
	if op==1 then
		rsgf.SelectRemove(rg,1-tp,aux.TRUE,1,1,nil,{})
	else
		Duel.NegateSummon(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.limitop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	if c then
		c:RegisterFlagEffect(m,rsreset.est_pend,0,1)
	end
end 
function cm.val(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)*1000
end
function cm.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler()
end
function cm.thop(e,tp)
	local c=e:GetHandler()
	local tct=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,c,30020000) and 3 or 1
	for p=0,1 do
		local tg=Duel.GetMatchingGroup(Card.IsAbleToHand,p,0,LOCATION_DECK,nil)
		if #tg>=tct then
			Duel.ConfirmCards(p,tg)
			rsgf.SelectToHand(tg,p,aux.TRUE,tct,tct,nil,{p,REASON_EFFECT })
		end
	end
end