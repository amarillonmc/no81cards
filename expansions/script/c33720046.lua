--Chaotic Song / Canto Caotico
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	c:EnableCounterPermit(0x246)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	--send to GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,5))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCost(s.tgcost)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		s.listed_names={}
	end
end

local function RememberName(c)
	local codes={c:GetCode()}
	for _,name in ipairs(codes) do
		local chk=true
		if #s.listed_names>0 then
			for _,checkn in ipairs(s.listed_names) do
				if name==checkn then
					chk=false
					break
				end
			end
		end
		if chk then
			table.insert(s.listed_names,name)
		end
	end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil,tp,POS_FACEDOWN)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil,1-tp,POS_FACEDOWN)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,PLAYER_ALL,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	for p=0,1 do
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
		local cg=Duel.SelectMatchingCard(p,Card.IsAbleToRemove,p,LOCATION_DECK,0,1,1,nil,p,POS_FACEDOWN)
		local tc=cg:GetFirst()
		if tc and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_REMOVED) then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE,1)
			tc:SetFlagEffectLabel(id,e:GetHandler():GetFieldID())
		end
	end
end

function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	local b2=Duel.IsExistingMatchingCard(aux.NOT(Card.IsPublic),tp,LOCATION_HAND,0,1,nil)
	if chk==0 then
		return e:GetHandler():IsCanAddCounter(0x246,1) and (b1 or b2)
	end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,e:GetHandler(),1,1,0x246)
	if b1 and not b2 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	elseif b2 and not b1 then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
	end
end
function s.negfilter(c,typ,pub)
	if not c:IsType(typ) or (pub and c:IsPublic()) then return false end
	for _,prev in ipairs({c:GetCode()}) do
		for _,name in ipairs(s.listed_names) do
			if prev==name then
				return false
			end
		end
	end
	return true
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c and c:IsFaceup() and c:IsRelateToEffect(e) and e:GetHandler():IsCanAddCounter(0x246,1) and c:AddCounter(0x246,1) then
		local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		local b2=Duel.IsExistingMatchingCard(aux.NOT(Card.IsPublic),tp,LOCATION_HAND,0,1,nil)
		if not b1 and not b2 then return end
		local opt
		if b1 and b2 then
			opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
		elseif b1 then
			opt=Duel.SelectOption(tp,aux.Stringid(id,1))
		else
			opt=Duel.SelectOption(tp,aux.Stringid(id,2))+1
		end
		if not opt then return end
		if opt==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.ConfirmCards(1-tp,g)
				RememberName(g:GetFirst())
				if Duel.IsChainDisablable(0) then
					local typ=g:GetFirst():GetType()&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
					local ng=Duel.GetMatchingGroup(s.negfilter,tp,0,LOCATION_DECK,nil,typ)
					if #ng>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,3)) then
						Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
						local sg=ng:Select(1-tp,1,1,nil)
						if #sg>0 then
							Duel.ConfirmCards(tp,sg)
							RememberName(sg:GetFirst())
							Duel.NegateEffect(0)
							return
						end
					end
				end
				Duel.Damage(1-tp,1000,REASON_EFFECT)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local g=Duel.SelectMatchingCard(tp,aux.NOT(Card.IsPublic),tp,LOCATION_HAND,0,1,1,nil)
			if #g>0 then
				Duel.ConfirmCards(1-tp,g)
				RememberName(g:GetFirst())
				local typ=g:GetFirst():GetType()&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
				local ng=Duel.GetMatchingGroup(s.negfilter,tp,0,LOCATION_HAND,nil,typ,true)
				if #ng>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,4)) then
					Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
					local sg=ng:Select(1-tp,1,1,nil)
					if #sg>0 then
						Duel.ConfirmCards(tp,sg)
						RememberName(sg:GetFirst())
						Duel.Damage(tp,1000,REASON_EFFECT)
						return
					end
				end
				Duel.Recover(tp,2000,REASON_EFFECT)
			end
		end
	end
end

function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	e:SetLabel(e:GetHandler():GetFieldID())
	Duel.SendtoGrave(c,REASON_COST)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x246)>=10 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(4000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,4000)
end
function s.ffilter(c,fid)
	return c:GetFlagEffect(id)>0 and c:GetFlagEffectLabel(id)==fid
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	--set countdown
	local g=Duel.GetMatchingGroup(s.ffilter,tp,LOCATION_REMOVED,0,nil,e:GetLabel())
	if #g==1 then
		local ct=Duel.GetTurnPlayer()==tp and Duel.GetTurnCount() or Duel.GetTurnCount()+1
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
		e1:SetCountLimit(1)
		e1:SetLabel(ct)
		e1:SetCondition(s.unocon)
		e1:SetOperation(s.unoop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,3)
		Duel.RegisterEffect(e1,1-tp)
		--
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_REMOVED)
		e2:SetHintTiming(TIMING_END_PHASE,0)
		e2:SetCountLimit(1)
		e2:SetLabel(ct)
		e2:SetLabelObject(e1)
		e2:SetCondition(s.turncon)
		e2:SetOperation(s.turnop)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,3)
		g:GetFirst():RegisterEffect(e2)
	end
end
function s.turncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END and Duel.GetTurnCount()==e:GetLabel()+4 and Duel.GetCurrentChain()==0
end
function s.turnop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,e:GetHandler():GetCode())
	Duel.Hint(HINT_CARD,1-tp,e:GetHandler():GetCode())
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/4))
	if e:GetLabelObject() and e:GetLabelObject().GetLabelObject then
		e:GetLabelObject():Reset()
	end
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end

function s.unocon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnCount()==e:GetLabel()+5 and Duel.GetCurrentChain()==0
end
function s.unoop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,id)
	Duel.Damage(1-tp,8000,REASON_EFFECT)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end