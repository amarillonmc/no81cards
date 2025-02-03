--秘计螺旋 重振
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(s.reptg)
	e2:SetValue(aux.TRUE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(id)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local g=Group.CreateGroup()
		g:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetLabelObject(g)
		ge1:SetCondition(s.recon)
		ge1:SetOperation(s.reop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetLabelObject(ge1)
		ge2:SetOperation(s.addop)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.spfilter(c,e,tp,atk)
	return c:IsAttackBelow(atk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_REMOVED,0,1,99,nil)
	local dg=g:Filter(Card.IsFacedown,nil)
	if dg:GetCount()>0 then Duel.ConfirmCards(tp,dg) end
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		local g=Duel.GetOperatedGroup()
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		local atk=Duel.Recover(tp,ct*500,REASON_EFFECT)
		if atk==0 then return end
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,atk)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			local tc=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.repfilter(c,tp)
	local loc=c:GetDestination()
	local rt={c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT)}
	for i,v in ipairs(rt) do
		if v:GetValue()==LOCATION_REMOVED then loc=LOCATION_REMOVED end
	end
	return c:IsControler(tp) and loc==LOCATION_REMOVED and c:IsAbleToRemove() and c:IsFaceup() and (c:IsLocation(LOCATION_MZONE) and c:IsCanTurnSet() or c:IsLocation(LOCATION_SZONE) and c:IsSSetable(true)) and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFlagEffect(tp,id)>0 or r&REASON_EFFECT==0 or r&REASON_REPLACE>0 then return end
	local c=e:GetHandler()
	if chk==0 then return r&REASON_EFFECT>0 and eg:IsExists(s.repfilter,1,nil,tp) and c:IsAbleToRemove() end
	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		local g=eg:Filter(s.repfilter,nil,tp)
		local ct=g:GetFirst()
		local mg=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
		Duel.ChangePosition(mg,POS_FACEDOWN_DEFENSE)
		local sg=g:Filter(aux.TRUE,mg)
		for sc in aux.Next(sg) do
			sc:CancelToGrave()
			Duel.ChangePosition(sc,POS_FACEDOWN)
		end
		Duel.RaiseEvent(sg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		return true
	else return false end
end
function s.addop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local g=e:GetLabelObject():GetLabelObject()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc and rc:IsStatus(STATUS_LEAVE_CONFIRMED) then
		g:AddCard(rc)
		rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function s.recon(e,tp,eg,ep,ev,re,r,rp)
	return ev==1
end
function s.refilter(c,tp)
	if not c:IsLocation(LOCATION_SZONE) and c:GetFlagEffect(id)==0 or not c:IsControler(tp) or not c:IsAbleToRemove()then return false end
	local rt={c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT)}
	for i,v in ipairs(rt) do
		if v:GetValue()==LOCATION_REMOVED then return true end
	end
	return false
end
function s.rmfilter(c)
	return c:IsHasEffect(id)~=nil and c:IsAbleToRemove()
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	for p=0,1 do
		local sg=g:Filter(s.refilter,nil,p)
		local rg=Duel.GetMatchingGroup(s.rmfilter,p,LOCATION_HAND+LOCATION_GRAVE,0,nil)
		if rg:GetCount()>0 and sg:GetCount()>0 then
			if Duel.SelectYesNo(p,aux.Stringid(id,2)) then
				local rc=rg:Select(p,1,1,nil)
				Duel.Remove(rc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
				for sc in aux.Next(sg) do
					sc:SetStatus(STATUS_LEAVE_CONFIRMED,false)
					Duel.ChangePosition(sc,POS_FACEDOWN)
				end
				g=g:Filter(aux.TRUE,sg)
				Duel.RaiseEvent(sg,EVENT_SSET,e,REASON_EFFECT,p,p,0)
			else
				Duel.RegisterFlagEffect(p,id,0,0,0)
			end
		end
	end
	Duel.ResetFlagEffect(0,id)
	Duel.ResetFlagEffect(1,id)
	g:Clear()
end