--黑·瑟谣浮收藏-汐斯塔人
function c79029429.initial_effect(c)
	--fusion
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,79029030,aux.FilterBoolFunction(Card.IsFusionType,TYPE_MONSTER),2,true,true)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029429,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHAIN_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029429.chain_target)
	e1:SetOperation(c79029429.chain_operation)
	e1:SetValue(aux.FilterBoolFunction(Card.IsCode,79029429))
	c:RegisterEffect(e1) 
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029030)
	c:RegisterEffect(e2)  
	--spsummon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c79029429.succon)
	e3:SetOperation(c79029429.sucop)
	c:RegisterEffect(e3)
	--move
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79029429,1))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c79029429.discon)
	e4:SetTarget(c79029429.distg)
	e4:SetOperation(c79029429.disop)
	c:RegisterEffect(e4)
	--Damage or Recover
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCountLimit(1,79029429) 
	e5:SetCost(aux.bfgcost)
	e5:SetCondition(c79029429.drcon)
	e5:SetTarget(c79029429.drtg)
	e5:SetOperation(c79029429.drop)
	c:RegisterEffect(e5)
		if not c79029429.global_check then
		c79029429.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c79029429.checkop)
		Duel.RegisterEffect(ge1,0)
   end  
end
function c79029429.checkop(e,tp,eg,ep,ev,re,r,rp)
	local flag=Duel.GetFlagEffectLabel(ep,79029429)
	if flag then
	Duel.SetFlagEffectLabel(ep,79029429,flag+ev)
	else
	Duel.RegisterFlagEffect(ep,79029429,RESET_PHASE+PHASE_END,0,1,ev)
	end
end
function c79029429.filter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c79029429.chain_target(e,te,tp)
	return Duel.GetMatchingGroup(c79029429.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,te)
end
function c79029429.chain_operation(e,te,tp,tc,mat,sumtype)
	if not sumtype then sumtype=SUMMON_TYPE_FUSION end
	tc:SetMaterial(mat)
	Debug.Message("让他们有来无回。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029429,4))
	Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,sumtype,tp,tp,false,false,POS_FACEUP)
end
function c79029429.succon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():GetMaterial():FilterCount(Card.IsSetCard,nil,0xa900)==e:GetHandler():GetMaterialCount() and e:GetHandler():GetMaterialCount()>0
end
function c79029429.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Debug.Message("罗德岛充斥着战场上的怪物，这样的战斗，我只能尽量模仿。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029429,5))
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029429,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c79029429.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c79029429.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c79029429.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c79029429.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c79029429.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq) 
	Debug.Message("这个位置......不错。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029429,6)) 
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	Duel.Destroy(eg,REASON_EFFECT)
	end   
	local val=aux.SequenceToGlobal(tp,LOCATION_MZONE,seq)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(val)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	-- 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(800)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
function c79029429.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffectLabel(tp,79029429)~=nil 
end
function c79029429.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end   
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0xa900) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 then 
	e:SetProperty((EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE))
	Debug.Message("真显眼。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029429,8)) 
	else
	Debug.Message("他们跑不了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029429,7)) 
	end
	local x=Duel.GetFlagEffectLabel(tp,79029429)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,aux.Stringid(79029429,2),aux.Stringid(79029429,3))
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_RECOVER)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(x)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,x)
	else
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(x)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,x)
	end
end
function c79029429.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if e:GetLabel()==0 then
	Debug.Message("确认周围已经安全了，下一步怎么做？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029429,9)) 
	Duel.Recover(p,d,REASON_EFFECT)
	else 
	Debug.Message("小姐有仁慈之心，我没有。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029429,10)) 
	Duel.Damage(p,d,REASON_EFFECT) 
	end
end












