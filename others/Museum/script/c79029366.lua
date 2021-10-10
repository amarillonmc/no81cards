--企鹅物流·术士干员-莫斯提马·序时之匙
function c79029366.initial_effect(c)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c79029366.efilter)
	c:RegisterEffect(e2)	
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,79029366)
	e1:SetCondition(c79029366.spcon)
	e1:SetTarget(c79029366.sptg)
	e1:SetOperation(c79029366.spop)
	c:RegisterEffect(e1)
	--skip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c79029366.skcon)
	e3:SetOperation(c79029366.skop)
	c:RegisterEffect(e3)
end
function c79029366.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c79029366.spcon(e,tp,eg,ep,ev,re,r,rp)
	local x=0
	local y=0
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp then
		x=x+1
		else 
		y=y+1 
		end
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and x>=2 and y>=2
end
function c79029366.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c79029366.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(ev*1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		c:RegisterEffect(e2)
	Duel.SpecialSummonComplete()
	Debug.Message("差不多该结束了吧？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029366,6))
	local dg=Group.CreateGroup()
	for i=1,ev do
	local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	dg:AddCard(tc)
	 end
	 local lg=dg:Select(tp,0,99,nil)
	 local lc=lg:GetFirst()
	 while lc do
	 lc:RegisterFlagEffect(79029366,RESET_CHAIN,0,1)
	 lc=lg:GetNext()
	 end
	for i=1,ev do
	local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
	local p=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	if tc:GetFlagEffect(79029366)~=0 then
	Duel.ChangeChainOperation(i,c79029366.repop)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029366,i))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(te)
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and not te:IsHasProperty(EFFECT_FLAG_PLAYER_TARGET) then
	e1:SetOperation(c79029366.xsop)
	else
	e1:SetOperation(c79029366.drop)
	end
	Duel.RegisterEffect(e1,p)
	end 
	end
end
function c79029366.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c79029366.xsop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) 
end 
end
function c79029366.repop(e,tp,eg,ep,ev,re,r,rp)
end
function c79029366.skcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c79029366.skop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("偶尔追求一些刺激，也是不坏的选择。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029366,7))
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCode(EFFECT_SKIP_M2)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)  
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_SKIP_M1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp) 
end






















