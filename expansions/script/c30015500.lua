--终墟库
overuins=overuins or {}
ors=overuins
rkc=rkc or {}
daval=daval or {}
--setname 
local cardt,name,exname=GetID()
cardt.isoveruins=true
---------za---------
function ors.stf(c) 
	return (_G["c"..c:GetCode()]) and  _G["c"..c:GetCode()].isoveruins
end 
--Release
function ors.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
--shangji summon con
function ors.adsumcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
--sumon check
function ors.sumchk(c)
	return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
end
--set moxian
function ors.setf(c,tp)
	local b1=c:IsType(TYPE_FIELD)
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (b1 or b2) and c:IsSSetable(true)
end
--summon op
function ors.sumop(e,tp,tcc)
	if not tcc or tcc==nil then return false end
	if tcc then
		local s1=tcc:IsSummonable(true,nil)
		local s2=tcc:IsMSetable(true,nil)
		if (s1 and s2 and Duel.SelectPosition(tp,tcc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tcc,true,nil)
		else
			Duel.MSet(tp,tcc,true,nil)
		end
	end
end
---exremove Check  
function ors.rf(c,tp) 
	return c:IsAbleToRemove(tp,POS_FACEDOWN) 
end   
function ors.exrmop(e,tp,res)
	if res==0 then return false end
	Duel.BreakEffect()
	local ec=e:GetHandler()
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(ors.rf),tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,1-tp) 
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
		Duel.ConfirmCards(tp,og)
		if og:FilterCount(Card.IsPreviousLocation,nil,LOCATION_DECK)>0 then
			Duel.ShuffleDeck(tp)
		end
		if og:FilterCount(Card.IsPreviousLocation,nil,LOCATION_EXTRA)>0 then
			Duel.ShuffleExtra(tp)
		end
	end
end
---lechck
function ors.lechk(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==1-tp and c:GetPreviousControler()==tp then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
--remove flag op
-------ors remove 1 or 3--------
function ors.removeone(e,tp,sc)
	local c=e:GetHandler()
	if sc and sc~=nil then 
		local code=sc:GetCode()
		loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA 
		local rrmg=Duel.GetMatchingGroup(ors.coderm,tp,0,loc,nil,tp,code)
		if #rrmg==0 then return false end
		local rmg=rrmg:RandomSelect(tp,1)
		local chka=0
		local chkb=0
		local chkc=0
		if rmg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)>0 then
			chka=1
		end
		if rmg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)>0 then
			chkb=1
		end
		if rmg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)>0 then
			chkc=1
		end
		Duel.Hint(HINT_CARD,0,c:GetOriginalCodeRule()) 
		Duel.BreakEffect()
		if Duel.Remove(rmg,POS_FACEDOWN,REASON_EFFECT)==0 then return false end
		Duel.ConfirmCards(tp,rmg)
		if chka>0 then Duel.ShuffleHand(1-tp) end
		if chkb>0 then Duel.ShuffleDeck(1-tp) end
		if chkc>0 then Duel.ShuffleExtra(1-tp) end
	end
end
function ors.removeall(e,tp,sc)
	local c=e:GetHandler()
	if sc and sc~=nil then 
		local code=sc:GetCode()
		loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA 
		local rmg=Duel.GetMatchingGroup(ors.coderm,tp,0,loc,nil,tp,code)
		if #rmg==0 then return false end
		local chka=0
		local chkb=0
		local chkc=0
		if rmg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)>0 then
			chka=1
		end
		if rmg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)>0 then
			chkb=1
		end
		if rmg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)>0 then
			chkc=1
		end
		Duel.Hint(HINT_CARD,0,c:GetOriginalCodeRule()) 
		Duel.BreakEffect()
		if Duel.Remove(rmg,POS_FACEDOWN,REASON_EFFECT)==0 then return false end 
		Duel.ConfirmCards(tp,rmg)
		if chka>0 then Duel.ShuffleHand(1-tp) end
		if chkb>0 then Duel.ShuffleDeck(1-tp) end
		if chkc>0 then Duel.ShuffleExtra(1-tp) end
	end
end
--------ors yongxu yiyan-------
function ors.yongxule(c)
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetCode(EVENT_LEAVE_FIELD_P)
	e20:SetOperation(ors.lechk)
	c:RegisterEffect(e20)
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_REMOVE)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(ors.orsmc)
	e21:SetTarget(ors.orsmtup)
	e21:SetOperation(ors.yleop)
	c:RegisterEffect(e21)
	local e32=Effect.CreateEffect(c)
	e32:SetCategory(CATEGORY_REMOVE)
	e32:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e32:SetCode(EVENT_CHAIN_NEGATED)
	e32:SetProperty(EFFECT_FLAG_DELAY)
	e32:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e32:SetCondition(ors.yycon)
	e32:SetTarget(ors.yytg)
	e32:SetOperation(ors.yyop)
	c:RegisterEffect(e32)
	local e33=e32:Clone()
	e33:SetCode(EVENT_CUSTOM+30015500)
	e33:SetCondition(ors.yycon2)
	c:RegisterEffect(e33)
	return e20,e21,e32,e33
end
function ors.yleop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	end
	if ct>0 then
		local sc=Duel.GetFirstTarget() 
		ors.removeall(e,tp,sc)
	end
end
--negop--
function ors.yycon(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	local dc=de:GetHandler()
	if de and de~=nil and dc:IsControler(1-tp) then
		e:SetLabelObject(dc)
	end
	return rp==tp and de and de~=nil and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and e:GetHandler()==re:GetHandler() and e:GetHandler():GetReasonEffect()==de
end
function ors.yycon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==re:GetHandler() and c:GetReasonEffect()==nil
end
function ors.yytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(30015500)
	local dc=e:GetLabelObject()
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	if ct>0 then
		Duel.SetTargetParam(1) 
	end
	if dc and dc~=nil then
		Duel.SetTargetCard(dc)
		sg:AddCard(dc)   
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,e:GetHandler(),0,0)
end
function ors.yyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=e:GetLabelObject()
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	end
	if dc and dc~=nil then
		local sc=Duel.GetFirstTarget() 
		ors.removeall(e,tp,sc)
	end
end
--------ors monster yiyan-------
function ors.monsterle(c)
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetCode(EVENT_LEAVE_FIELD_P)
	e20:SetOperation(ors.lechk)
	c:RegisterEffect(e20)
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(ors.orsmc)
	e21:SetTarget(ors.orsmt)
	e21:SetOperation(ors.orsmp)
	c:RegisterEffect(e21)
	return e20,e21
end
function ors.monsterleup(c)
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetCode(EVENT_LEAVE_FIELD_P)
	e20:SetOperation(ors.lechk)
	c:RegisterEffect(e20)
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(ors.orsmc)
	e21:SetTarget(ors.orsmtup)
	e21:SetOperation(ors.orsmpup)
	c:RegisterEffect(e21)
	return e20,e21
end
function ors.coderm(c,tp,code) 
	return c:IsAbleToRemove(tp,POS_FACEDOWN) and c:IsCode(code)
end  
function ors.orsmc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function ors.orsmt(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	if ct>0 then
		local rc=c:GetReasonCard()
		local re=c:GetReasonEffect()
		if not rc and re then
			local sc=re:GetHandler()
			if not rc then
				Duel.SetTargetCard(sc)
				sg:AddCard(sc)
			end
		end 
		if rc then 
			Duel.SetTargetCard(rc)
			sg:AddCard(rc)
		end
	end
	if ct>0 then
		loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA 
		local xg=sg:Clone()
		xg:RemoveCard(c)
		local rmg=Duel.GetMatchingGroup(ors.coderm,tp,0,loc,nil,tp,xg:GetFirst():GetCode())
		rmg:AddCard(c)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rmg,2,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
	end
end
function ors.orsmp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	local dp=e:GetOwnerPlayer()
	if ct>0 then
		ors[dp]=ors[dp]+2
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(30015500,5))
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(30015500,5))
	else
		ors[dp]=ors[dp]+1
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	e1:SetValue(ors[dp]+1)
	Duel.RegisterEffect(e1,dp)
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)   
	end
	if ct>0 then
		local sc=Duel.GetFirstTarget() 
		ors.removeone(e,tp,sc)
	end
end
function ors.orsmtup(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	if ct>0 then
		local rc=c:GetReasonCard()
		local re=c:GetReasonEffect()
		if not rc and re then
			local sc=re:GetHandler()
			if not rc then
				Duel.SetTargetCard(sc)
				sg:AddCard(sc)
			end
		end 
		if rc then 
			Duel.SetTargetCard(rc)
			sg:AddCard(rc)
		end
	end
	if ct>0 then
		loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA 
		local xg=sg:Clone()
		xg:RemoveCard(c)
		local rmg=Duel.GetMatchingGroup(ors.coderm,tp,0,loc,nil,tp,xg:GetFirst():GetCode())
		rmg:AddCard(c)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rmg,#rmg,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
	end
end
function ors.orsmpup(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	local dp=e:GetOwnerPlayer()
	if ct>0 then
		ors[dp]=ors[dp]+2
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(30015500,5))
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(30015500,5))
	else
		ors[dp]=ors[dp]+1
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	e1:SetValue(ors[dp]+1)
	Duel.RegisterEffect(e1,dp)
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	end
	if ct>0 then
		local sc=Duel.GetFirstTarget() 
		ors.removeall(e,tp,sc)
	end
end
--remove flag
--------atkdef or ors-------
function ors.atkordef(c,vala,valb)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ors.atkval)
	e1:SetLabel(vala,valb)
	c:RegisterEffect(e1)
	if not ors.remove then
		ors.remove=true
		daval[0]=0
		daval[1]=0
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_REMOVE)
		ge0:SetOperation(ors.amp)
		Duel.RegisterEffect(ge0,0)
	end
end
function ors.ft1(c) 
	local tc=c:GetReasonCard()
	local re=c:GetReasonEffect()
	local b1= tc  and tc~=nil and ors.stf(tc)
	local b2=re and re~=nil and ors.stf(re:GetHandler())
	return c:IsLocation(LOCATION_REMOVED) and (b1 or b2) 
end  
function ors.amp(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(ors.ft1,nil)
	if ct>0 then
		daval[Duel.GetTurnPlayer()]=daval[Duel.GetTurnPlayer()]+ct
	end
end
function ors.atkval(e,c)
	local va,vb=e:GetLabel()
	--100,2000
	local ct=daval[0]+daval[1]
	if ct*va<=vb then
		return vb
	else
		return ct*va
	end
end
--all or overuins
function ors.alldrawflag(c)
	if not ors.counter then
		ors.counter=true
		ors[0]=0
		ors[1]=0
		rkc[0]=0
		rkc[1]=0
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_DRAW)
		ge0:SetCondition(ors.exdrcon)
		ge0:SetOperation(ors.rmexdr)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_NEGATED)
		ge1:SetOperation(ors.alne)
		Duel.RegisterEffect(ge1,0)
		--local ge3=Effect.CreateEffect(c)
		--ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		--ge3:SetCode(EVENT_ADJUST)
		--ge3:SetOperation(ors.rmexdrx)
		--Duel.RegisterEffect(ge3,0)
	end
end
function ors.exdrcon(e,tp,eg,ep,ev,re,r,rp)
	local b2=Duel.GetCurrentPhase()==PHASE_DRAW 
	return r==REASON_RULE and b2
end
function ors.rmexdr(e,tp,eg,ep,ev,re,r,rp)
	ors[ep]=0
end
function ors.rmexdrx(e,tp,eg,ep,ev,re,r,rp)
	local ct=rkc[tp]+rkc[1-tp]
	local tunp=Duel.GetTurnPlayer()
	if Duel.GetTurnCount()==1 and Duel.GetLP(tunp)>=16000 and ct==0 then
		rkc[tunp]=rkc[tunp]+1
		Debug.Message(rkc[tunp]) 
	end
end
function ors.alne(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local lp=re:GetOwnerPlayer()
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	if de and de~=nil then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetOperation(ors.negevent)
		e1:SetLabelObject(re)
		Duel.RegisterEffect(e1,re:GetOwnerPlayer())
		if dp and rc:GetPreviousControler()==lp and dp==1-lp then
			rc:RegisterFlagEffect(30015500,RESET_PHASE+PHASE_END,0,1) 
		end
	end
end
function ors.negevent(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local lp=te:GetOwnerPlayer()
	Duel.RaiseEvent(te:GetHandler(),EVENT_CUSTOM+30015500,te,0,lp,lp,0)
	e:Reset()
end
--draw or overuins
function ors.redraw(c)
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetCode(EVENT_LEAVE_FIELD_P)
	e20:SetOperation(ors.lechk)
	c:RegisterEffect(e20)
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(30015500,6))
	e21:SetCategory(CATEGORY_REMOVE)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(ors.impcon)
	e21:SetTarget(ors.imptg)
	e21:SetOperation(ors.impop)
	c:RegisterEffect(e21)
	local e32=Effect.CreateEffect(c)
	e32:SetCategory(CATEGORY_REMOVE)
	e32:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e32:SetCode(EVENT_CHAIN_NEGATED)
	e32:SetProperty(EFFECT_FLAG_DELAY)
	e32:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e32:SetCondition(ors.tthcon)
	e32:SetTarget(ors.tthtg)
	e32:SetOperation(ors.tthop)
	c:RegisterEffect(e32)
	local e33=e32:Clone()
	e33:SetCode(EVENT_CUSTOM+30015500)
	e33:SetCondition(ors.tthcon2)
	c:RegisterEffect(e33)
	return e20,e21,e32,e33
end
--negate--
function ors.tthcon(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	return rp==tp and de and de~=nil and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and e:GetHandler()==re:GetHandler() and e:GetHandler():GetReasonEffect()==de
end
function ors.tthcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==re:GetHandler() and c:GetReasonEffect()==nil
end
function ors.lechk(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==1-tp and c:GetPreviousControler()==tp then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function ors.impcon(e,tp,eg,ep,ev,re,r,rp) --rp==1-tp and
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function ors.imptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel()
	if chk==0 then return true end
	if ct>0 then
		Duel.SetTargetParam(1) 
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function ors.impop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM) 
	local dp=e:GetOwnerPlayer()
	if num>0 then
		ors[dp]=ors[dp]+2
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(30015500,5))
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(30015500,5))
	else
		ors[dp]=ors[dp]+1
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	e1:SetValue(ors[dp]+1)
	Duel.RegisterEffect(e1,dp)
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	end
end
function ors.tthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(30015500)
	if chk==0 then return true end
	if ct>0 then
		Duel.SetTargetParam(1) 
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function ors.tthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM) 
	local dp=e:GetOwnerPlayer()
	if num>0 then
		ors[dp]=ors[dp]+2 
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(30015500,5))
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(30015500,5))
	else
		ors[dp]=ors[dp]+1 
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	e1:SetValue(ors[dp]+1)
	Duel.RegisterEffect(e1,dp)
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	end
end


----linshi------------
--proc or overuins
function ors.summonproc(c,lv,rmval,reval)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(30015500,8))
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SUMMON_PROC)
	e11:SetCondition(ors.otcon)
	e11:SetOperation(ors.otop)
	e11:SetValue(SUMMON_TYPE_ADVANCE)
	e11:SetLabel(lv,rmval,reval)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e12)
end
function ors.srm(c)
	return c:IsAbleToRemoveAsCost(POS_FACEDOWN) and not c:IsType(TYPE_TOKEN)
end
function ors.ref(c,tp)
	local te=c:IsHasEffect(EFFECT_UNRELEASABLE_SUM)
	local code=c:GetOriginalCodeRule()
	if te~=nil or code==48411997 then return false end
	return ors.stf(c) 
end
function ors.fck(g,tp,ct)
	local b1=g:FilterCount(Card.IsControler,nil,1-tp)<=ct 
	local b2=Duel.GetMZoneCount(tp,g)>0
	return b1 and b2
end
function ors.tfck(g,tp)
	local b1=g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>0 
	local b2=Duel.GetMZoneCount(tp,g)>0
	return b1 and b2
end
function ors.otcon(e,c,minc)
	if c==nil then return true end
	local ct,aval,bval=e:GetLabel()
	local tp=e:GetHandlerPlayer()
	local mg=Duel.GetMatchingGroup(ors.srm,tp,LOCATION_ONFIELD,0,nil)
	local reg=Duel.GetMatchingGroup(ors.ref,tp,LOCATION_ONFIELD,0,nil,tp)
	if Duel.IsPlayerAffectedByEffect(tp,30015035) 
		or c:GetFlagEffect(30015035)>0 then
		local mg1=Duel.GetMatchingGroup(ors.srm,tp,0,LOCATION_ONFIELD,nil)
		mg:Merge(mg1)
	end
	local lv
	local bct 
	if ct==5 or ct==6 then
		lv=5
		bct=1
	elseif ct>=7 and ct<10 then
		lv=7
		bct=2
	elseif ct>=10 then
		lv=10
		bct=3
	end
	local ckval=math.floor(aval/2)
	local b1=mg:CheckSubGroup(ors.fck,aval,aval,tp,ckval) and minc<=aval
	local b2=#reg>=bval and minc<=bval
	return c:IsLevelAbove(lv) and (b1 or b2)
end
function ors.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local code=30015085
	local ct,aval,bval=e:GetLabel()
	tp=e:GetHandlerPlayer()
	local mg=Duel.GetMatchingGroup(ors.srm,tp,LOCATION_ONFIELD,0,nil)
	local reg=Duel.GetMatchingGroup(ors.ref,tp,LOCATION_ONFIELD,0,nil,tp)
	if Duel.IsPlayerAffectedByEffect(tp,30015035) 
		or c:GetFlagEffect(30015035)>0 then
		local mg1=Duel.GetMatchingGroup(ors.srm,tp,0,LOCATION_ONFIELD,nil)
		mg:Merge(mg1)
	end
	local ckval=math.floor(aval/2)
	local b1=mg:CheckSubGroup(ors.fck,aval,aval,tp,ckval)
	local b2=#reg>=bval 
	if b1 or b2 then
		if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(code,1),aux.Stringid(code,2))==0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=mg:SelectSubGroup(tp,ors.fck,false,aval,aval,tp,ckval)
			c:SetMaterial(sg)
			Duel.Remove(sg,POS_FACEDOWN,REASON_SUMMON+REASON_MATERIAL)
			if sg:FilterCount(Card.IsControler,nil,1-tp)>0 then
				local te=Duel.IsPlayerAffectedByEffect(tp,30015035)
				if te~=nil then te:UseCountLimit(tp) end
			end
		else
			local ssg
			if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
				ssg=reg:SelectSubGroup(tp,ors.tfck,false,bval,bval,tp)
			else
				ssg=reg:Select(tp,bval,bval,nil)
			end
			c:SetMaterial(ssg)
			Duel.Release(ssg,REASON_SUMMON+REASON_MATERIAL)
		end
	end
end