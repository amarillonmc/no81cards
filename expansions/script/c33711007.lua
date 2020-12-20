--罪恶的牺牲
function c33711007.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e00:SetProperty(EFFECT_FLAG_DELAY)
	e00:SetCode(EVENT_CUSTOM+33711007)
	e00:SetRange(LOCATION_SZONE)
	e00:SetCondition(c33711007.con)
	e00:SetOperation(c33711007.op)
	c:RegisterEffect(e00)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c33711007.damval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e4:SetCondition(c33711007.damcon)
	c:RegisterEffect(e4) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c33711007.valcon)
	e2:SetValue(c33711007.val)
	c:RegisterEffect(e2)  
end
function c33711007.valcon(e)
	return true
end
function c33711007.val(e,re,dam,r,rp,rc)
	return dam*2
end
function c33711007.damval(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	local tp=Duel.GetTurnPlayer()
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and c:GetFlagEffect(33711007)==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 then
			c:RegisterFlagEffect(33711007,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			Duel.DisableActionCheck(true)   
			Duel.RaiseEvent(c,EVENT_CUSTOM+33711007,e,val,tp,rp,re)
		end
	end
	Duel.DisableActionCheck(false)
	return val
end
function c33711007.con(e,tp,eg)
   return e:GetHandler():GetFlagEffect(33711007)~=0 and e:GetHandler():GetFlagEffect(33711008)==0
end
function c33711007.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 and Duel.SelectYesNo(tp,aux.Stringid(33711007,1)) then
		Duel.ConfirmDecktop(tp,3)
		local g=Duel.GetDecktopGroup(tp,3)
		local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if hg:GetCount()>0 then
			hg:Merge(g)
			hg=hg:Filter(Card.IsType,nil,TYPE_MONSTER)
			if hg:GetCount()>0 then
				local tc=hg:Select(tp,1,1,nil):GetFirst()
				Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_SUMMON)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetTarget(c33711007.sumlimit)
				e1:SetLabel(tc:GetCode())
				Duel.RegisterEffect(e1,tp)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				Duel.RegisterEffect(e2,tp)
				local c=e:GetHandler()
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetCode(EFFECT_DISABLE)
				e3:SetTargetRange(0x7f,0x7f)
				e3:SetTarget(c33711007.distg)
				e3:SetLabelObject(tc)
				Duel.RegisterEffect(e3,tp)
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e4:SetCode(EVENT_CHAIN_SOLVING)
				e4:SetCondition(c33711007.discon)
				e4:SetOperation(c33711007.disop)
				e4:SetLabelObject(tc)
				Duel.RegisterEffect(e4,tp)
				Duel.Damage(tp,math.max(0,r-tc:GetTextDefense()),REASON_EFFECT)	  
				e:GetHandler():RegisterFlagEffect(33711008,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			end
		end
	else
		Duel.Damage(tp,r/2^(Duel.GetMatchingGroupCount(c33711007.filter2,tp,LOCATION_SZONE,0,nil)-1),REASON_EFFECT)   
		e:GetHandler():RegisterFlagEffect(33711008,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c33711007.filter2(c)
	return c:IsFaceup() and c:GetOriginalCode()==33711007
end
function c33711007.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c33711007.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c33711007.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c33711007.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function c33711007.damcon(e)
	return e:GetHandler():GetFlagEffect(33711007)==0
end