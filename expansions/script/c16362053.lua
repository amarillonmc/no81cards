--脉冲爆破 天启帝君
function c16362053.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c16362053.matfilter,2,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--splimit
	local e00=Effect.CreateEffect(c)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e00:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e00:SetCode(EVENT_SPSUMMON_SUCCESS)
	e00:SetCondition(c16362053.regcon)
	e00:SetOperation(c16362053.regop)
	c:RegisterEffect(e00)
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(c16362053.evalue)
	c:RegisterEffect(e1)
	--immune
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(c16362053.efilter)
	c:RegisterEffect(e11)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCountLimit(1,16362053)
	e2:SetTarget(c16362053.destg)
	e2:SetOperation(c16362053.desop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,16362153)
	e3:SetTarget(c16362053.destg2)
	e3:SetOperation(c16362053.desop2)
	c:RegisterEffect(e3)
end
function c16362053.matfilter(c)
	return c:IsFusionSetCard(0xdc0) and c:IsFusionType(TYPE_FUSION+TYPE_SYNCHRO)
end
function c16362053.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c16362053.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c16362053.splimit1)
	Duel.RegisterEffect(e1,tp)
end
function c16362053.splimit1(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(16362053) and bit.band(sumtype,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c16362053.evalue(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and (rc:GetType()==TYPE_SPELL or rc:GetType()==TYPE_TRAP)
end
function c16362053.efilter(e,te)
	local rc=te:GetHandler()
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and (rc:GetType()==TYPE_SPELL or rc:GetType()==TYPE_TRAP)
end
function c16362053.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c16362053.desfilter(c,s)
	local seq=c:GetSequence()
	return seq<5 and math.abs(seq-s)==1
end
function c16362053.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	local seq=tc:GetSequence()
	local dg=Group.CreateGroup()
	if seq<5 then dg=Duel.GetMatchingGroup(c16362053.desfilter,tp,0,LOCATION_MZONE,nil,seq) end
	if dg:GetCount()>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c16362053.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
	local g=tc:GetColumnGroup()
	g:AddCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c16362053.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local col=tc:GetColumnZone(LOCATION_ONFIELD,0)+aux.SequenceToGlobal(tc:GetControler(),tc:GetLocation(),tc:GetSequence())
	local g=tc:GetColumnGroup()
	g:AddCard(tc)
	if tc:IsRelateToEffect(e) and Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)~=0 then
	--disable field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE_FIELD)
	e4:SetValue(c16362053.disval)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetLabel(col)
	c:RegisterEffect(e4)
	end
end
function c16362053.disval(e)
	return e:GetLabel()
end