if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53765008
local cm=_G["c"..m]
cm.name="枷狱首席执行官 路西法"
cm.Snnm_Ef_Rst=true
cm.AD_Ht=true
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1,e1_1,e2,e3=SNNM.ActivatedAsSpellorTrap(c,0x20004,LOCATION_HAND)
	e1:SetDescription(aux.Stringid(m,0))
	SNNM.HelltakerActivate(c,m)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSummonLocation,LOCATION_SZONE))
	e6:SetValue(cm.atkval)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(cm.efilter)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetCode(m)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(1,0)
	e9:SetValue(cm.imuval)
	c:RegisterEffect(e9)
	e8:SetLabelObject(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_ADJUST)
	e10:SetRange(LOCATION_MZONE)
	e10:SetLabelObject(e8)
	e10:SetOperation(cm.imuct)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,3))
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_PHASE+PHASE_END)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1)
	e11:SetTarget(cm.pltg)
	e11:SetOperation(cm.plop)
	c:RegisterEffect(e11)
	if not cm.global_check then
		cm.global_check=true
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetOperation(cm.mvcount)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		Duel.RegisterEffect(ge4,1)
		cm[13]=Card.IsImmuneToEffect
		Card.IsImmuneToEffect=function(rc,re)
			Akanekosan_Say_No=true
			local res=cm[13](rc,re)
			Akanekosan_Say_No=false
			return res
		end
		cm[14]=Card.IsCanBeRitualMaterial
		Card.IsCanBeRitualMaterial=function(...)
			Akanekosan_Say_Yes=true
			local res=cm[14](...)
			Akanekosan_Say_Yes=false
			return res
		end
		cm[15]=Duel.GetRitualMaterial
		Duel.GetRitualMaterial=function(...)
			Akanekosan_Say_Yes=true
			local res=cm[15](...)
			Akanekosan_Say_Yes=false
			return res
		end
		cm[16]=Duel.GetRitualMaterialEx
		Duel.GetRitualMaterialEx=function(...)
			Akanekosan_Say_Yes=true
			local res=cm[16](...)
			Akanekosan_Say_Yes=false
			return res
		end
		cm[17]=Duel.Overlay
		Duel.Overlay=function(rc,tg)
			tg=Group.__add(tg,tg)
			for tc in aux.Next(tg) do
				if tc:IsHasEffect(53766006) then
					local re={tc:IsHasEffect(53766006)}
					re=re[#re]
					re=re:GetLabelObject()
					if cm[13](tc,re) then tg:RemoveCard(tc) end
				end
			end
			return cm[17](rc,tg)
		end
		cm[18]=Duel.MoveSequence
		Duel.MoveSequence=function(rc,...)
			if rc:IsHasEffect(53766006) then
				local re={rc:IsHasEffect(53766006)}
				re=re[#re]
				re=re:GetLabelObject()
				if cm[13](rc,re) then return nil end
			end
			return cm[18](rc,...)
		end
		cm[19]=Card.RegisterEffect
		Card.RegisterEffect=function(rc,re,bool)
			if not bool and rc:IsHasEffect(53766006) then
				local re={rc:IsHasEffect(53766006)}
				re=re[#re]
				re=re:GetLabelObject()
				if cm[13](rc,re) then return nil else return cm[19](rc,re,true) end
			end
			return cm[19](rc,re,bool)
		end
		cm[20]=Duel.CalculateDamage
		Duel.CalculateDamage=function(rc1,rc2,...)
			tg=Group.__add(rc1,rc2)
			local res=true
			for tc in aux.Next(tg) do
				if tc:IsHasEffect(53766006) then
					local re={tc:IsHasEffect(53766006)}
					re=re[#re]
					re=re:GetLabelObject()
					if cm[13](tc,re) then res=false end
				end
			end
			if res then return cm[20](rc1,rc2,...) else return nil end
		end
		cm[21]=Duel.MoveToField
		Duel.MoveToField=function(rc,...)
			if rc:IsHasEffect(53766006) then
				local re={rc:IsHasEffect(53766006)}
				re=re[#re]
				re=re:GetLabelObject()
				if cm[13](rc,re) then return false end
			end
			return cm[21](rc,...)
		end
	end
	SNNM.ActivatedAsSpellorTrapCheck(c)
end
function cm.atkval(e,c)
	local flag=e:GetHandler():GetFlagEffectLabel(m+50) or 0
	return flag*500
end
function cm.imuval(e,c)
	return e:GetHandler():GetFlagEffectLabel(m+50) or 0
end
function cm.imufilter(c,e)
	return not c:IsImmuneToEffect(e) and c:IsSummonLocation(LOCATION_SZONE)
end
function cm.imuct(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.imufilter,tp,LOCATION_MZONE,0,nil,e:GetLabelObject())
	local re=e:GetLabelObject():GetLabelObject()
	for tc in aux.Next(g) do
		local pe={Duel.IsPlayerAffectedByEffect(tp,m)}
		local ct=0
		for _,v1 in pairs(pe) do
			local val=v1:GetValue()
			local ct3=0
			if v1==re then ct3=val(v1,tc) end
			local ce={tc:IsHasEffect(m)}
			local ct1=0
			for _,v2 in pairs(ce) do
				if v2:GetLabelObject()==v1 then ct1=v2:GetLabel() end
			end
			local ct2=ct3-ct1
			ct=math.max(ct,ct2)
		end
		tc:ResetFlagEffect(m)
		if ct>0 then tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,ct+5)) end
	end
end
function cm.efilter(e,te,c)
	local tp=e:GetHandlerPlayer()
	if te:GetOwnerPlayer()==tp or not te:IsActivated() or te:GetActivateLocation()&LOCATION_ONFIELD==0 then return false end
	if Akanekosan_Say_No then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(53766006)
		e1:SetLabelObject(te)
		c:RegisterEffect(e1,true)
		return false
	end
	c:ResetEffect(53766006,RESET_CODE)
	local re=e:GetLabelObject()
	local ct=0
	local pe={Duel.IsPlayerAffectedByEffect(tp,m)}
	for _,v in pairs(pe) do
		local val=v:GetValue()
		if v==re then ct=val(v,c) end
	end
	if ct<1 then return false end
	local ce={c:IsHasEffect(m)}
	local res=true
	for _,v in pairs(ce) do
		if v:GetLabelObject()==re and v:GetLabel()>=ct then res=false end
	end
	if not res then return false end
	if Akanekosan_Say_Yes then return true end
	for _,v1 in pairs(pe) do
		local ce={c:IsHasEffect(m)}
		local flag=0
		for _,v2 in pairs(ce) do
			if v2:GetLabelObject()==v1 then
				flag=v2:GetLabel()
				v2:Reset()
			end
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(m)
		e1:SetLabel(flag+1)
		e1:SetLabelObject(v1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
	end
	return true
end
function cm.mvcount(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,m)
	local adjust=false
	for tc in aux.Next(g) do
		local ce={tc:IsHasEffect(m)}
		for _,v1 in pairs(ce) do
			local re=v1:GetLabelObject()
			local pe={Duel.IsPlayerAffectedByEffect(tp,m)}
			local res=false
			for _,v2 in pairs(pe) do if v2==re then res=true end end
			if not res then
				adjust=true
				tc:ResetFlagEffect(m)
				v1:Reset()
			end
		end
	end
	if adjust then Duel.Readjust() end
end
function cm.plfilter(c)
	return c:IsSetCard(0xc530) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and not Duel.IsExistingMatchingCard(function(c,cd)return c:IsFaceup() and c:IsCode(cd)end,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,c:GetCode())
end
function cm.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.plfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.opfilter(c)
	local seq,loc=c:GetSequence(),0
	if c:IsLocation(LOCATION_MZONE) then loc=LOCATION_MZONE else loc=LOCATION_SZONE end
	return ((seq<5 and ((seq>0 and Duel.CheckLocation(tp,loc,seq-1)) or (seq<4 and Duel.CheckLocation(tp,loc,seq+1)))) or c:IsAbleToHand()) and not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function cm.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.plfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(cm.opfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			local sg=Duel.SelectMatchingCard(tp,cm.opfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
			Duel.HintSelection(sg)
			local sc=sg:GetFirst()
			local seq,loc=sc:GetSequence(),0
			if sc:IsLocation(LOCATION_MZONE) then loc=LOCATION_MZONE else loc=LOCATION_SZONE end
			if ((seq>0 and Duel.CheckLocation(tp,loc,seq-1)) or (seq<4 and Duel.CheckLocation(tp,loc,seq+1))) and (not sc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(m,5))) then
				local flag=0
				local ct=(sc:IsLocation(LOCATION_MZONE) and 0) or 8
				if seq>0 and Duel.CheckLocation(tp,loc,seq-1) then flag=bit.replace(flag,0x1,seq-1+ct) end
				if seq<4 and Duel.CheckLocation(tp,loc,seq+1) then flag=bit.replace(flag,0x1,seq+1+ct) end
				flag=bit.bxor(flag,0xffff)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
				local s=Duel.SelectDisableField(tp,1,loc,0,flag)
				local nseq=math.log(s,2)
				if nseq>7 then nseq=nseq-8 end
				Duel.MoveSequence(sc,nseq)
			else
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
			end
		end
	end
end
