--升华念力斗士
local cm,m=GetID()
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--[[aux.AddFusionProcFunRep(c,function(c) return c:IsRace(RACE_PSYCHO) and c:IsFusionSetCard(0xe) end,1,true)
	local e10=aux.AddContactFusionProcedure(c,cm.filter,LOCATION_GRAVE+LOCATION_MZONE,0,cm.tdcfop(c))
	local con=e10:GetCondition()
	local op=e10:GetOperation()
	e10:SetCondition(function(e,...)
		local c=e:GetHandler()
		return c:GetFlagEffect(m)>0 and con(e,...)
	end)
	e10:SetOperation(function(e,...) 
		local c=e:GetHandler()
		c:ResetFlagEffect(m)
		op(e,...)
	end)--]]
	aux.AddFusionProcFun2(c,cm.filter0,cm.filter02,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e21:SetRange(LOCATION_EXTRA)
	e21:SetTargetRange(LOCATION_EXTRA,0)
	e21:SetTarget(function(e,c) return c:IsCode(m+1) end)
	e21:SetLabelObject(e2)
	c:RegisterEffect(e21)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--spsummon
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e20:SetCode(EVENT_CUSTOM+m)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e20:SetLabelObject(e2)
	e20:SetRange(LOCATION_EXTRA)
	e20:SetOperation(cm.op)
	c:RegisterEffect(e20)
	local e201=e21:Clone()
	e201:SetLabelObject(e20)
	c:RegisterEffect(e201)
	--
	local custom_code=cm.RegisterMergedDelayedEvent_ToSingleCard(c,m,{EVENT_MOVE,EVENT_LEAVE_FIELD,EVENT_CUSTOM+m+3})
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(custom_code)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	--e3:SetCondition(cm.sumcon)
	e3:SetTarget(cm.sumtg)
	e3:SetOperation(cm.sumop1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCode(custom_code+1)
	--e4:SetCondition(aux.TRUE) --cm.sumcon2)
	e4:SetOperation(cm.sumop2)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(custom_code+2)
	e5:SetDescription(aux.Stringid(m,3))
	--e5:SetCondition(cm.sumcon3)
	e5:SetOperation(cm.sumop)
	c:RegisterEffect(e5)
	if not cm.global_check then
		cm.global_check=true
		local _Overlay=Duel.Overlay
		function Duel.Overlay(xc,v,...)
			local t=Auxiliary.GetValueType(v)
			local g=Group.CreateGroup()
			if t=="Card" then g:AddCard(v) else g=v end
			local res=_Overlay(xc,v,...)
			Duel.RaiseEvent(g,EVENT_CUSTOM+m+1,e1,0,0,0,0)
			return res
		end
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_ACTIVATING)
		ge2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
		ge2:SetOperation(cm.chkop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.filter0(c,fc)
	if not c11451951 then return false end
	local rp=fc:GetControler() or 0
	return c:GetFlagEffect(11451951+rp)>0 or c11451951[rp][c:GetCode()]
end
function cm.filter02(c,fc)
	if not c11451951 then return false end
	local rp=fc:GetControler() or 0
	return c:GetFlagEffect(11451951+rp+1000)>0 or c11451951[rp+1000][c:GetCode()]
end
function cm.spfilter(c,fc,tp)
	return cm.filter(c) and Duel.GetLocationCountFromEx(tp,tp,c,fc)>0 and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:GetFlagEffect(m)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,c,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	c:SetMaterial(Group.FromCards(tc))
	c:ResetFlagEffect(m)
	cm.tdcfop(c)(Group.FromCards(tc))
end
function cm.RegisterMergedDelayedEvent_ToSingleCard(c,code,events)
	local g=Group.CreateGroup()
	g:KeepAlive()
	local g2=Group.CreateGroup()
	g2:KeepAlive()
	local mt=getmetatable(c)
	local seed=0
	if type(events) == "table" then 
		for _, event in ipairs(events) do
			seed = seed + event 
		end 
	else 
		seed = events
	end 
	while(mt[seed]==true)
	do 
		seed = seed + 1 
	end
	mt[seed]=true 
	local event_code_single = (code ~ (seed << 16)) | EVENT_CUSTOM
	for _, event in ipairs(events) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(event)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetRange(0xff)
		e1:SetLabel(event_code_single)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local c=e:GetOwner()
							if e:GetCode()==EVENT_MOVE then
								g:Merge(eg:Filter(cm.cfilter,nil))
							elseif e:GetCode()==EVENT_LEAVE_FIELD then
								g2:Merge(eg)
							else
								g:Merge(eg)
							end
							if Duel.CheckEvent(EVENT_MOVE) then 
								_,meg=Duel.CheckEvent(EVENT_MOVE,true)
								local c=e:GetOwner()
								if meg:IsContains(c) and (c:IsFaceup() or c:IsPublic()) then
									g:Clear()
									g2:Clear()
								end 
							end
							if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) and not g:IsExists(function(c) return c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsStatus(STATUS_CHAINING) and c:IsFaceup() end,1,nil) and not g2:IsExists(function(c) return c:GetEquipCount()>0 or c:GetOverlayCount()>0 end,1,nil) then
								local _eg=g:Clone()
								local _eg2=g2:Clone()
								if #g>0 and #g2>0 then
									Duel.RaiseEvent(_eg+_eg2,e:GetLabel()+2,re,r,rp,ep,ev)
								elseif #g>0 then
									Duel.RaiseEvent(_eg,e:GetLabel(),re,r,rp,ep,ev)
								elseif #g2>0 then
									Duel.RaiseEvent(_eg2,e:GetLabel()+1,re,r,rp,ep,ev)
								end  
								g:Clear()
								g2:Clear()
							end
						end)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHAIN_END)
		e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local c=e:GetOwner()
							if Duel.CheckEvent(EVENT_MOVE) then 
								_,meg=Duel.CheckEvent(EVENT_MOVE,true)
								local c=e:GetOwner()
								if meg:IsContains(c) and (c:IsFaceup() or c:IsPublic()) then
									g:Clear()
									g2:Clear()
								end 
							end
							local _eg=g:Clone()
							local _eg2=g2:Clone()
							if #g>0 and #g2>0 then
								Duel.RaiseEvent(_eg+_eg2,e:GetLabel()+2,re,r,rp,ep,ev)
							elseif #g>0 then
								Duel.RaiseEvent(_eg,e:GetLabel(),re,r,rp,ep,ev)
							elseif #g2>0 then
								Duel.RaiseEvent(_eg2,e:GetLabel()+1,re,r,rp,ep,ev)
							end  
							g:Clear()
							g2:Clear()
						end)
		c:RegisterEffect(e2)
	end
	--listened to again
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EVENT_MOVE)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
						local c=e:GetOwner()
						if c:IsFaceup() or c:IsPublic() then
							g:Clear()
							g2:Clear()
						end 
					end)
	c:RegisterEffect(e3)
	return event_code_single
end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,r,rp,ep,ev)
end
function cm.tdcfop(c)
	return function(g)
				if #g==0 then return end
				local tp=c:GetControler()
				local dg=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
				local cg=g:Filter(Card.IsFacedown,nil)
				if #dg>0 then
					Duel.SendtoHand(dg,nil,REASON_COST)
				end
				Duel.SendtoDeck(g-dg,nil,2,REASON_COST)
				if #dg>0 or #cg>0 then Duel.ConfirmCards(1-tp,g) end
			end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
	if cm[c]==1 or Duel.GetFlagEffect(tp,m)>0 or not c:IsSpecialSummonable(0) then cm[c]=nil c:ResetFlagEffect(m) return end
	if cm[c]==2 or Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,0)) then
		if not cm[c] then
			local sg=Duel.GetMatchingGroup(function(c) return c:IsCode(m+1) and c:IsSpecialSummonable(0) end,tp,LOCATION_EXTRA,0,nil)
			local g=Duel.GetMatchingGroup(function(c) return c:IsCode(m) and c:IsSpecialSummonable(0) end,tp,LOCATION_EXTRA,0,nil)
			local g0=sg+g
			if #sg>0 then
				if Duel.SelectEffectYesNo(tp,sg:GetFirst(),aux.Stringid(m,0)) then
					c:ResetFlagEffect(m)
					for tc in aux.Next(g0) do cm[tc]=1 end
					cm[c]=nil
					cm[sg:GetFirst()]=2
					return
				elseif c:GetOriginalCode()~=m then
					c:ResetFlagEffect(m)
					for tc in aux.Next(g0) do cm[tc]=1 end
					cm[c]=nil
					cm[g:GetFirst()]=2
					return
				end
			end
		else
			cm[c]=nil
		end
		if c:GetOriginalCode()~=m then
			local g=Duel.GetMatchingGroup(function(c) return c:IsCode(m) end,tp,LOCATION_EXTRA,0,nil)
			Duel.ConfirmCards(1-tp,g:GetFirst())
		end
		cm.sptg(e,tp,eg,ep,ev,re,r,rp,1,c)
		cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
		c:CompleteProcedure()
	else
		c:ResetFlagEffect(m)
	end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.filter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsFusionSetCard(0xe) and ((c:IsLocation(LOCATION_MZONE) and c:IsAbleToHandAsCost()) or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToDeckAsCost()))
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and not (c:IsLocation(LOCATION_HAND) and c:IsControler(c:GetPreviousControler()))
end
function cm.cfilter2(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and not c:IsOnField() --bug.
end
function cm.smfilter(c)
	return c:IsSetCard(0xe) and c:IsAbleToHand()
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp) and not eg:IsExists(cm.cfilter2,1,nil,1-tp)
end
function cm.sumcon2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsExists(cm.cfilter,1,nil,1-tp) and eg:IsExists(cm.cfilter2,1,nil,1-tp)
end
function cm.sumcon3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp) and eg:IsExists(cm.cfilter2,1,nil,1-tp)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_DECK,0)
	if #g<1 then return end
	local opt=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local typ,typ2=Duel.AnnounceType(tp),0
	if typ==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		typ2=Duel.AnnounceAttribute(tp,1,0x7f)
	end
	if opt==1 then
		local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
		Duel.MoveSequence(tc,0)
	end
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	Duel.ConfirmDecktop(1-tp,1)
	if tc:IsType(1<<typ) and (typ>0 or tc:IsAttribute(typ2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_DECK,0,1,1,tc)
		if tc:IsAbleToHand() then g:AddCard(tc) end
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	else
		if opt==1 then Duel.MoveSequence(tc,1) end
		if e:GetHandler():IsRelateToEffect(e) then Duel.GetControl(e:GetHandler(),1-tp) end
	end
end
function cm.sumop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_DECK,0)
	if #g<1 then return end
	local opt=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local typ,typ2=Duel.AnnounceType(tp),0
	if typ==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		typ2=Duel.AnnounceAttribute(tp,1,0x7f)
	end
	if opt==1 then
		local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
		Duel.MoveSequence(tc,0)
	end
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	Duel.ConfirmDecktop(1-tp,1)
	if tc:IsType(1<<typ) and (typ>0 or tc:IsAttribute(typ2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_DECK,0,1,1,tc)
		if tc:IsAbleToHand() then g:AddCard(tc) end
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	else
		if opt==1 then Duel.MoveSequence(tc,1) end
		if e:GetHandler():IsRelateToEffect(e) then Duel.GetControl(e:GetHandler(),1-tp) end
	end
end
function cm.sumop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_DECK,0)
	if #g<1 then return end
	local opt=1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local typ,typ2=Duel.AnnounceType(tp),0
	if typ==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		typ2=Duel.AnnounceAttribute(tp,1,0x7f)
	end
	if opt==1 then
		local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
		Duel.MoveSequence(tc,0)
	end
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	Duel.ConfirmDecktop(1-tp,1)
	if tc:IsType(1<<typ) and (typ>0 or tc:IsAttribute(typ2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_DECK,0,1,1,tc)
		if tc:IsAbleToHand() then g:AddCard(tc) end
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	else
		if opt==1 then Duel.MoveSequence(tc,1) end
		if e:GetHandler():IsRelateToEffect(e) then Duel.GetControl(e:GetHandler(),1-tp) end
	end
end