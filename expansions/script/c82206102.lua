--命运之轮·莫伊莱
local m=82206102
local cm=c82206102
function cm.initial_effect(c)
	--fusion material  
	c:EnableReviveLimit()  
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,6,false)
	--material limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_MATERIAL_LIMIT)
	e0:SetValue(cm.matlimit)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_COIN+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.coincon)
	e3:SetTarget(cm.cointg)
	e3:SetOperation(cm.coinop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(m,1))  
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_COIN+CATEGORY_RECOVER+CATEGORY_DRAW)
	e4:SetCondition(cm.coincon2)
	e4:SetCountLimit(1,m+1)
	e4:SetTarget(cm.cointg2)
	e4:SetOperation(cm.coinop2)
	c:RegisterEffect(e4)
	--
	if not cm.check_for_sm then
		cm.check_for_sm=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(cm.condition)
		ge1:SetOperation(cm.operation)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON)
		ge2:SetCondition(cm.condition2)
		ge2:SetOperation(cm.operation2)
		Duel.RegisterEffect(ge2,0)
	end
end
cm.toss_coin=true
function cm.ffilter(c,fc,sub,mg,sg)
	return not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute())
end
function cm.matlimit(e,c,fc,st)
	if st~=SUMMON_TYPE_FUSION then return true end
	return c:IsControler(fc:GetControler()) and c:IsLocation(LOCATION_ONFIELD)
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
		or st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
function cm.spfilter(g,fc,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g,fc)>0
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetReleaseGroup(tp):Filter(Card.IsCanBeFusionMaterial,nil,c,SUMMON_TYPE_SPECIAL)
	return mg:CheckSubGroup(cm.spfilter,3,nil,c,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetReleaseGroup(tp):Filter(Card.IsCanBeFusionMaterial,nil,c,SUMMON_TYPE_SPECIAL)
	local g=mg:SelectSubGroup(tp,cm.spfilter,false,3,3,c,tp)
	c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000,0,1)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function cm.coincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
		or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetParam(2000)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function cm.coinop(e,tp,eg,ep,ev,re,r,rp)
	local res
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.GetFlagEffect(tp,m)>0 then
		res=3
	else
		res=1-Duel.TossCoin(tp,1)
	end
	if res==0 or res==3 then
		Debug.Message("命运之轮·恒——日月安属，列星安陈")
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		if g:GetCount()>0 then
			for tc in aux.Next(g) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(2000)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetDescription(aux.Stringid(m,2))  
				e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e3:SetRange(LOCATION_MZONE)
				e3:SetValue(aux.tgoval)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				tc:RegisterEffect(e3)
				local e4=e3:Clone()
				e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
				e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				tc:RegisterEffect(e4)
			end
		end
	end
	if res==1 or res==3 then
		Debug.Message("命运之轮·恒——阴阳三合，苍穹斗转")
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if g:GetCount()>0 then
			local sg=g:RandomSelect(1-tp,1)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
			Duel.Damage(p,d,REASON_EFFECT)
		end
	end
end
function cm.coincon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.cointg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,1-tp,LOCATION_MZONE,0,1,nil)
		or Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetTargetParam(1)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,2000)
end
function cm.coinop2(e,tp,eg,ep,ev,re,r,rp)
	local res
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.GetFlagEffect(tp,m)>0 then
		res=3
	else
		res=1-Duel.TossCoin(tp,1)
	end
	if res==0 or res==3 then
		Debug.Message("命运之轮·界——兜兜转转，难舍难分")
		local g=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil)
		if g:GetCount()>0 then
			for tc in aux.Next(g) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-2000)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				tc:RegisterEffect(e2)
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e3=Effect.CreateEffect(e:GetHandler()) 
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				tc:RegisterEffect(e3)
				local e4=Effect.CreateEffect(e:GetHandler())
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e4:SetCode(EFFECT_DISABLE_EFFECT)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				tc:RegisterEffect(e4)
				local e5=Effect.CreateEffect(e:GetHandler())
				e5:SetDescription(aux.Stringid(m,3))
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetCode(EFFECT_CANNOT_TRIGGER)
				e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
				e5:SetRange(LOCATION_MZONE)
				e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				tc:RegisterEffect(e5)
			end
		end
	end
	if res==1 or res==3 then
		Debug.Message("命运之轮·界——初心不变，轮回永恒")
		Duel.Draw(p,d,REASON_EFFECT)
		Duel.Recover(p,2000,REASON_EFFECT)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and Duel.GetCurrentChain()>=2
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		local sp=tc:GetSummonPlayer()
		if Duel.GetFlagEffect(1-sp,m)==0 then
			Duel.RegisterFlagEffect(1-sp,m,RESET_PHASE+PHASE_END,0,1)
		end
	end
end   
function cm.check_for_self(c)
	return c:GetFlagEffect(m)>0
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:IsExists(cm.check_for_self,1,nil)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	local sp=rc:GetSummonPlayer()
	local coin=Duel.TossCoin(sp,1)
	if coin==0 then
		Duel.NegateSummon(eg)
		Duel.Destroy(eg,REASON_RULE)
	else
		Debug.Message("从来没有那么一人，有种前世今生的感觉，")
		Debug.Message("似星辰开启记忆，如命运做出选择………")
	end
end