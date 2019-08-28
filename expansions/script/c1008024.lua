--罪恶王冠 鸫
function c1008024.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c1008024.splimit)
	e0:SetCondition(c1008024.splimcon)
	c:RegisterEffect(e0)
	--scale change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1008024,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c1008024.sccon)
	e2:SetOperation(c1008024.scop)
	c:RegisterEffect(e2)
	--confirm
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetDescription(aux.Stringid(1008024,0))
	-- e1:SetType(EFFECT_TYPE_IGNITION)
	-- e1:SetRange(LOCATION_MZONE)
	-- e1:SetCountLimit(1)
	-- e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	-- e1:SetTarget(c1008024.target)
	-- e1:SetOperation(c1008024.operation)
	-- c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	-- e2:SetOwnerPlayer(tp)
	e2:SetTarget(c1008024.limtg)
	e2:SetValue(c1008024.efilter)
	c:RegisterEffect(e2)
	if not c1008024.global_check then
		c1008024.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetRange(LOCATION_MZONE)
		ge1:SetCondition(c1008024.checkcon)
		ge1:SetOperation(c1008024.checkop)
		c:RegisterEffect(ge1)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(ge2)
	end
	--creat void
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1008024,1))
	e5:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(1008001)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c1008024.voidtg)
	e5:SetOperation(c1008024.voidop)
	c:RegisterEffect(e5)
	--synchro custom
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetTarget(c1008024.syntg)
	e7:SetValue(1)
	e7:SetOperation(c1008024.synop)
	c:RegisterEffect(e7)
end
c1008024.tuner_filter=aux.FilterBoolFunction(Card.IsSetCard,0x320e)
function c1008024.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x320e) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c1008024.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c1008024.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and c:IsSetCard(0x320e) and (f==nil or f(c))
end
function c1008024.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g=Duel.GetMatchingGroup(c1008024.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local res=g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	return res
end
function c1008024.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g=Duel.GetMatchingGroup(c1008024.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	Duel.SetSynchroMaterial(sg)
end
function c1008024.sccon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return tc and tc:IsSetCard(0x320e) and Duel.IsExistingTarget(c1008024.scfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function c1008024.scfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c1008024.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.SelectTarget(tp,c1008024.scfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(tc:GetOriginalLeftScale())
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	e2:SetValue(tc:GetOriginalRightScale())
	c:RegisterEffect(e2)
end
-- function c1008024.filter(c)
	-- return c:GetSequence()~=5 and c:IsFacedown()
-- end
-- function c1008024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	-- if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) and c1008024.filter(chkc) end
	-- if chk==0 then return Duel.IsExistingTarget(c1008024.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	-- Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1008024,1))
	-- local g=Duel.SelectTarget(tp,c1008024.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	-- Duel.SetChainLimit(c1008024.limit(g:GetFirst()))
-- end
-- function c1008024.limit(c)
	-- return   function (e,lp,tp)
				-- return e:GetHandler()~=c
			-- end
-- end
-- function c1008024.operation(e,tp,eg,ep,ev,re,r,rp)
	-- local tc=Duel.GetFirstTarget()
	-- if tc:IsRelateToEffect(e) and tc:IsFacedown() then
		-- Duel.ConfirmCards(tp,tc)
	-- end
-- end
function c1008024.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler())
end
function c1008024.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(10080240,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c1008024.limtg(e,c)
	return c:IsSetCard(0x320e) and c:GetFlagEffect(10080240)~=0 
end
function c1008024.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c1008024.voidtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():IsFaceup() end
	Duel.Hint(8,tp,1008026)
end
function c1008024.voidop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 or not c:IsRelateToEffect(e) then return end
	if not c:IsLocation(LOCATION_MZONE) or not c:IsFaceup() then return end
	local code =1008026
	c:RegisterFlagEffect(10080011,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1008001,4))
	local g=Group.FromCards(Duel.CreateToken(tp,code))
	local tc=g:GetFirst()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.BreakEffect()
	c:SetCardTarget(tc)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c1008024.desop)
	c:RegisterEffect(e2,true)
	--Destroy2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c1008024.descon2)
	e3:SetOperation(c1008024.desop2)
	c:RegisterEffect(e3,true)
end
function c1008024.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc then
		Duel.Destroy(tc,REASON_RULE)
	end
end
function c1008024.descon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc) and re and not re:GetHandler():IsSetCard(0x320e)
end
function c1008024.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_RULE)
end