--隐秘见闻-见闻的█读
--1202520
local s,id,o=GetID()
s.KeSuLu=true
s.loc={{LOCATION_HAND+LOCATION_GRAVE,LOCATION_REMOVED}}
--通用效果去/来的位置
local KSLid=1202500	--克苏鲁公用id1
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,1))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e0:SetCost(s.cost)
	e0:SetTarget(s.settg)
	e0:SetOperation(s.setop)
	c:RegisterEffect(e0)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	e1:SetCondition(s.rmcon)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--copy effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.recon)
	e2:SetTarget(s.retg)
	e2:SetOperation(s.reop)
	c:RegisterEffect(e2)
	
end
--开始
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.IsExistingMatchingCard(s.rmfilter1,tp,0x1f,0,1,nil) 
		or Duel.IsExistingMatchingCard(s.rmfilter2,tp,LOCATION_REMOVED,0,1,nil))
end
function s.rmfilter1(c)	--去
	if not c.KeSuLu or c.KeSuLu==false then return false end
	if not c.loc or not c.loc[1] or c.loc[1][2]~=LOCATION_REMOVED then return false end
	local nowloc=c:GetLocation()
	return bit.band(nowloc,c.loc[1][1])==nowloc and c:IsAbleToRemove()
end
function s.rmfilter2(c,tp)	--回
	if not c.KeSuLu or c.KeSuLu==false then return false end
	if not c.loc or not c.loc[2] or c.loc[2][1]~=LOCATION_REMOVED then return false end
	if c:IsType(TYPE_SPELL) then
		if c:IsType(TYPE_CONTINUOUS) then return c:GetFlagEffect(KSLid-1)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
		return c:GetFlagEffect(KSLid-1)~=0
	elseif c:IsType(TYPE_MONSTER) then
		return c:GetFlagEffect(KSLid-1)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	end
	return false
end
function s.rtgfilter(c,loc)
	if not c.loc or not c.loc[2] or c.loc[2][1]~=LOCATION_REMOVED then return false end
	return c.loc[2][2]==loc
end

function s.rmcheck(g,tp)
	return g:Filter(Card.IsType,nil,TYPE_CONTINUOUS):GetCount()<=Duel.GetLocationCount(tp,LOCATION_SZONE) 
		and g:Filter(Card.IsType,nil,TYPE_MONSTER):GetCount()<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and g:Filter(Card.IsType,nil,TYPE_FIELD):GetCount()<=1
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,KSLid)==0 then
		local htg=Group.CreateGroup()
		if Duel.IsExistingMatchingCard(s.rmfilter1,tp,0x1f,0,1,nil) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,2)) then
			local g=Duel.GetMatchingGroup(s.rmfilter1,tp,0x1f,0,nil)
			if not g or g:GetCount()==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=g:Select(tp,1,g:GetCount(),nil)
			if not tg then return end
			Duel.Hint(HINT_CARD,0,id)
			htg=tg:Filter(Card.IsLocation,nil,0x1f)
			--Duel.Remove(htg,POS_FACEUP,REASON_EFFECT)
			local num1=Duel.Remove(htg,POS_FACEUP,REASON_EFFECT)
			local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			if og:GetCount()>0 then
				for tc in aux.Next(og) do
					if tc.KeSuLu and tc.KeSuLu==true then
						tc:RegisterFlagEffect(KSLid-1,RESET_EVENT+RESETS_STANDARD,0,0)		
					end
				end
			end
			if num1~=0 then
				Duel.HintSelection(htg)
			end
		end
		--Debug.Message(2)
		if Duel.IsExistingMatchingCard(s.rmfilter2,tp,LOCATION_REMOVED,0,1,htg,tp) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,3)) then
			local g=Duel.GetMatchingGroup(s.rmfilter2,tp,LOCATION_REMOVED,0,htg,tp)
			if not g or g:GetCount()==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local tg=g:SelectSubGroup(tp,s.rmcheck,true,1,math.min(g:GetCount(),Duel.GetLocationCount(tp,LOCATION_SZONE)+Duel.GetLocationCount(tp,LOCATION_MZONE)+1),tp)
			if not tg then return end
			Duel.Hint(HINT_CARD,0,id)
			--local tg=g:Select(tp,1,math.min(g:GetCount()),nil)
			local rtg=tg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			if rtg and rtg:GetCount()>0 then 
				Duel.HintSelection(rtg)
				local srtg=rtg:Filter(s.rtgfilter,nil,LOCATION_SZONE)
				local frtg=rtg:Filter(s.rtgfilter,nil,LOCATION_FZONE)
				local mrtg=rtg:Filter(s.rtgfilter,nil,LOCATION_MZONE)
				if srtg:GetCount()>0 then
					for tc in aux.Next(srtg) do
						Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
					end
				end		
				if mrtg:GetCount()>0 then
					for tc in aux.Next(mrtg) do
						Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
					end
				end		
				if frtg:GetCount()>0 then
					local frtc=frtg:GetFirst()
					local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
					if fc then
						Duel.SendtoGrave(fc,REASON_RULE)
						Duel.BreakEffect()
					end
					Duel.MoveToField(frtc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				end
			end
		end
		Duel.RegisterFlagEffect(tp,KSLid,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_CHAIN,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetReset(RESET_PHASE+RESET_CHAIN)
		e1:SetLabel(tp)
		e1:SetCountLimit(1)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,KSLid)~=0
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(e:GetLabel(),KSLid)
end
--结束

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK,0,2,2,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_COST)>0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if og:GetCount()>0 then
			for tc in aux.Next(og) do
				if tc.KeSuLu and tc.KeSuLu==true then
					tc:RegisterFlagEffect(KSLid-1,RESET_EVENT+RESETS_STANDARD,0,0)		
				end
			end
		end
	end
end
function s.filter(c)
	return c:IsSetCard(0xa240) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden()
end
function s.costfilter(c)
	return c:IsSetCard(0xa240) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToRemoveAsCost()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=ft-1 end
		return ft>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function s.recon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rc:IsSetCard(0xa240) and c:IsPreviousLocation(LOCATION_HAND)
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local te,ceg,cev,cre,cr,crp=c:CheckActivateEffect(false,true,true)
	--Duel.ClearTargetCard()
	c:CreateEffectRelation(e)
	if not te then return false end
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	--Duel.ClearOperationInfo(0)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not (te and te:GetHandler():IsRelateToEffect(e)) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	--Debug.Message(1)
	if op and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,0)) then 
		Duel.Hint(HINT_CARD,0,id)
		op(e,tp,eg,ep,ev,re,r,rp) 
	end
end