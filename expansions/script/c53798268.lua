local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.ef1con)
	e1:SetCost(s.ef1cost)
	e1:SetTarget(s.ef1tg)
	e1:SetOperation(s.ef1op)
	c:RegisterEffect(e1)
	--Effect 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.reptg)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end

function s.ef1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end

function s.ef1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.filter(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden()
end

function s.ef1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=3 end
end

function s.ef1op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	Duel.ConfirmCards(1-tp,sg)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
	local tg=sg:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if Duel.SSet(tp,tc)~=0 then

		sg:Sub(tg)
		--Trap handling
		if tc:IsType(TYPE_TRAP) then
			--Act in set turn
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
			
			--Register connection (Reference: Yellow Spring Maze Dragon/Snake)
			local c=e:GetHandler()
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,c:GetFieldID())
			
			--Watcher (Reference: Grave Robber)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAINING)
			e2:SetLabelObject(tc)
			e2:SetCondition(s.actcon)
			e2:SetOperation(s.actop)
			Duel.RegisterEffect(e2,tp)
			
			--Solver (Reference: Grave Robber)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_CHAIN_SOLVED)
			e3:SetLabelObject(tc)
			e3:SetCondition(s.solvecon)
			e3:SetOperation(s.solveop)
			Duel.RegisterEffect(e3,tp)

	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end

function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc or tc:GetFlagEffect(id)==0 then
		e:Reset()
		return false
	end
	return re:GetHandler()==tc
end

function s.actop(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():RegisterFlagEffect(id+1,RESET_CHAIN,0,1)
end

function s.solvecon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc or tc:GetFlagEffect(id)==0 then
		e:Reset()
		return false
	end
	return re:GetHandler()==tc and tc:GetFlagEffect(id+1)~=0
end

function s.solveop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local c=e:GetHandler()
	--Check connection (Reference: Yellow Spring Maze Dragon/Snake)
	if tc:GetFlagEffectLabel(id)~=c:GetFieldID() then return end
	
	local b1=tc:IsAbleToRemove(tp,POS_FACEDOWN)
	local b2=c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_MZONE) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and tc:IsCanOverlay()
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 then
		op=0
	elseif b2 then
		op=1
	else
		return
	end
	
	if op==0 then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	else
		tc:CancelToGrave()
		Duel.Overlay(c,tc)
	end
end

function s.repfilter(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsType(TYPE_CONTINUOUS)
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:GetReasonPlayer()==1-tp
		and c:GetOverlayGroup():IsExists(s.repfilter,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	if Duel.SelectEffectYesNo(tp,c,96) then
		return true
	else return false end
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=c:GetOverlayGroup():FilterSelect(tp,s.repfilter,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end