--噩梦醇
local m=14010217
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(cm.regtg)
	e0:SetOperation(cm.bgmop)
	c:RegisterEffect(e0)
	--cannot be destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot set/activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.setlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(cm.actlimit)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
--
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetCode(EVENT_CHAINING)
	e11:SetRange(LOCATION_FZONE)
	e11:SetOperation(cm.op11)
	e11:SetLabelObject(e4)
	c:RegisterEffect(e11)
--
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(cm.rtcon)
	e6:SetTarget(cm.rttg)
	e6:SetOperation(cm.rtop)
	c:RegisterEffect(e6)
end
function cm.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local c=e:GetHandler()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(cm.gycon)
	e1:SetOperation(cm.gyop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
end
function cm.gycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function cm.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,2))
end
--
function cm.op11(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local le=e:GetLabelObject()
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_CANNOT_ACTIVATE)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetRange(LOCATION_FZONE)
	if e:GetHandlerPlayer()~=ep then
		e12:SetTargetRange(0,1)
	else
		e12:SetTargetRange(1,0)
	end
	e12:SetLabelObject(le)
	e12:SetValue(cm.actlimit)
	e12:SetReset(RESET_CHAIN)
	c:RegisterEffect(e12)
end
function cm.actlimit(e,te,tp)
	local le=e:GetLabelObject()
	return te==le and te:GetHandler()==e:GetHandler()
end
--
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() and re:GetHandler()~=e:GetHandler() and Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and re:GetHandler():IsRelateToEffect(re) then
		local tc=re:GetHandler()
		tc:RegisterFlagEffect(m,0,0,1)
		Duel.Destroy(tc,REASON_EFFECT+REASON_TEMPORARY)
	end
end
function cm.GetZones(c,loc,seq)
	local zone=0
	if loc==LOCATION_MZONE and (seq>4 or seq<0) then return zone end
	zone=zone|(1<<(seq))
	if seq and loc==LOCATION_DECK or loc==LOCATION_EXTRA then return seq end
	return zone
end
function cm.tgfilter(c)
	return c:GetFlagEffect(m)>0 and bit.band(c:GetReason(),REASON_DESTROY)~=0
end
function cm.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.tgfilter,1,nil)
end
function cm.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:Filter(cm.tgfilter,nil):GetFirst()
	if not tc then return end
	tc:CreateEffectRelation(e)
	tc:ResetFlagEffect(m)
	e:SetLabelObject(tc)
	if tc:IsPreviousLocation(LOCATION_HAND) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
	elseif tc:IsPreviousLocation(LOCATION_DECK) or tc:IsPreviousLocation(LOCATION_EXTRA) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
	end
end
function cm.rtop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject(tc)
	if tc and e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local loc,pos,p,seq=tc:GetPreviousLocation(),tc:GetPreviousPosition(),tc:GetPreviousControler(),tc:GetPreviousSequence()
		if loc&LOCATION_ONFIELD~=0 then
			Duel.ReturnToField(tc,pos,cm.GetZones(tc,loc,seq))
			if tc:IsType(TYPE_SPELL+TYPE_TRAP) and not tc:IsType(TYPE_CONTINUOUS+TYPE_FIELD) and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
				tc:CancelToGrave(false)
			end
		elseif loc&LOCATION_HAND~=0 then
			Duel.SendtoHand(tc,p,REASON_EFFECT+REASON_RETURN)
		elseif loc&LOCATION_DECK~=0 then
			Duel.SendtoDeck(tc,p,seq,REASON_EFFECT+REASON_RETURN)
		elseif loc&LOCATION_EXTRA~=0 then
			if tc:IsType(TYPE_PENDULUM) and pos&POS_FACEUP~=0 then
				Duel.SendtoExtraP(tc,p,REASON_EFFECT+REASON_RETURN)
			else
				Duel.SendtoDeck(tc,p,seq,REASON_EFFECT+REASON_RETURN)
			end
		end
	end
end