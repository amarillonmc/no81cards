--蝶幻-「流」
if not c71401001 then dofile("expansions/script/c71401001.lua") end
function c71401020.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c71401020.mfilter,aux.NonTuner(c71401020.mfilter),1)
	c:EnableReviveLimit()
	--Fissure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(c71401020.rmtarget)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	--Gravekeeper's Servant
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_FIELD)
	e1a:SetCode(81674782)
	e1a:SetRange(LOCATION_MZONE)
	e1a:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1a:SetTargetRange(0xff,0xff)
	e1a:SetTarget(c71401020.checktg)
	c:RegisterEffect(e1a)
	--disable
	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1b:SetCode(EVENT_CHAIN_SOLVING)
	e1b:SetRange(LOCATION_MZONE)
	e1b:SetCondition(c71401020.discon)
	e1b:SetOperation(c71401020.disop)
	c:RegisterEffect(e1b)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401020,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71401020)
	e2:SetCost(yume.ButterflyLimitCost)
	e2:SetTarget(c71401020.tg2)
	e2:SetOperation(c71401020.op2)
	c:RegisterEffect(e2)
	--cannot disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71401020,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,71501020)
	e3:SetCondition(c71401020.con3)
	e3:SetCost(yume.ButterflyLimitCost)
	e3:SetTarget(c71401020.tg3)
	e3:SetOperation(c71401020.op3)
	c:RegisterEffect(e3)
	yume.ButterflyCounter()
end
c71401020.material_type=TYPE_SYNCHRO
function c71401020.mfilter(c)
	return c:IsSynchroType(TYPE_SYNCHRO) and c:IsRace(RACE_SPELLCASTER)
end
function c71401020.rmtarget(e,c)
	return not c:IsLocation(0x80) and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c71401020.checktg(e,c)
	return not c:IsPublic()
end
function c71401020.discon(e,tp,eg,ep,ev,re,r,rp)
	local code,ctrl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CONTROLER)
	return ctrl==1-tp and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(Card.IsCode,0,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,code)
end
function c71401020.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c71401020.filter2(c)
	return not c:IsDisabled()
end
function c71401020.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c71401020.filter2,0,0,LOCATION_ONFIELD,1,nil)
			and Duel.IsExistingMatchingCard(c71401020.filter2,0,LOCATION_ONFIELD,0,1,nil)
			and Duel.GetDecktopGroup(tp,1):FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==1
	end
	local g=Duel.GetMatchingGroup(c71401020.filter2,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,2,0,0)
end
function c71401020.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(c71401020.filter2,tp,LOCATION_ONFIELD,0,nil)
	local ct2=Duel.GetMatchingGroupCount(c71401020.filter2,tp,0,LOCATION_ONFIELD,nil)
	local ct=math.min(ct1,ct2,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))
	if ct==0 then return end
	local ct_table={}
	for i=ct,1,-1 do
		if Duel.GetDecktopGroup(tp,i):FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==i then
			for j=1,i do
				ct_table[j]=j
			end
			break
		end
	end
	if #ct_table==1 then
		ct=1
	else
		if #ct_table==0 then return
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71401020,1))
			ct=Duel.AnnounceNumber(tp,table.unpack(ct_table))
		end
	end
	local rg=Duel.GetDecktopGroup(tp,ct)
	Duel.DisableShuffleCheck()
	Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local dg1=Duel.SelectMatchingCard(tp,c71401020.filter2,tp,LOCATION_ONFIELD,0,ct,ct,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local dg2=Duel.SelectMatchingCard(tp,c71401020.filter2,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	dg1:Merge(dg2)
	local c=e:GetHandler()
	for tc in aux.Next(dg1) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
	if not c:IsImmuneToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(71401001,6)) then
		Duel.BreakEffect()
		if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e4=Effect.CreateEffect(c)
			e4:SetCode(EFFECT_CHANGE_TYPE)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e4:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			c:RegisterEffect(e4)
		end
	end
end
function c71401020.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c71401020.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(nil,0,0,LOCATION_ONFIELD,1,nil)
			and Duel.IsExistingMatchingCard(nil,0,LOCATION_ONFIELD,0,1,nil)
			and Duel.GetDecktopGroup(tp,1):FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==1
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c71401020.op3(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD,0,nil)
	local ct2=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_ONFIELD,nil)
	local ct=math.min(ct1,ct2,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))
	if ct==0 then return end
	local ct_table={}
	for i=ct,1,-1 do
		if Duel.GetDecktopGroup(tp,i):FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==i then
			for j=1,i do
				ct_table[j]=j
			end
			break
		end
	end
	if #ct_table==1 then
		ct=1
	else
		if #ct_table==0 then return
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71401020,1))
			ct=Duel.AnnounceNumber(tp,table.unpack(ct_table))
		end
	end
	local rg=Duel.GetDecktopGroup(tp,ct)
	Duel.DisableShuffleCheck()
	Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71401020,3))
	local cg1=Duel.SelectMatchingCard(nil,tp,LOCATION_ONFIELD,0,ct,ct,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71401020,3))
	local cg2=Duel.SelectMatchingCard(nil,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	cg1:Merge(cg2)
	local c=e:GetHandler()
	for tc in aux.Next(cg1) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_INACTIVATE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetLabel(1)
		e1:SetValue(c71401020.efilter)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_DISEFFECT)
		e2:SetLabel(2)
		Duel.RegisterEffect(e2,tp)
		e1:SetLabelObject(e2)
		e2:SetLabelObject(tc)
		--chk
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_LEAVE_FIELD_P)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e0:SetLabelObject(e1)
		e0:SetOperation(c71401020.chk)
		tc:RegisterEffect(e0)
		--flag
		tc:RegisterFlagEffect(71401020,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71401020,4))
	end
end
function c71401020.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local label=e:GetLabel()
	local tc
	if label==3 then
		tc=e:GetLabelObject():GetLabelObject()
	else
		tc=e:GetLabelObject()
	end
	return tc and tc==te:GetHandler()
end
function c71401020.chk(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=e:GetLabelObject()
	local e2=e1:GetLabelObject()
	local te=c:GetReasonEffect()
	if c:GetFlagEffect(71401020)==0 or not te or not te:IsActivated() or te:GetHandler()~=c then
		e1:Reset()
		e2:Reset()
	else
		--reset
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_END)
		e0:SetLabelObject(e1)
		e0:SetOperation(c71401020.resetop)
		Duel.RegisterEffect(e0,tp)
	end
end
function c71401020.resetop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	local e2=e1:GetLabelObject()
	e1:Reset()
	e2:Reset()
	e:Reset()
end