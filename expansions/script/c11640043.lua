--天龙座的眼镜
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.setcon)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.tgcon)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4) 
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(s.con2)
	e5:SetOperation(s.op2)
	c:RegisterEffect(e5)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.GetFlagEffect(tp,id)==0 and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
		 and rc:IsRelateToEffect(re) and rc:IsCanTurnSet() and rc:IsStatus(STATUS_LEAVE_CONFIRMED) and rc:IsSetCard(0x3224) and rc:IsType(TYPE_RITUAL)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectEffectYesNo(tp,rc,aux.Stringid(id,1)) then
		rc:CancelToGrave()
		Duel.ChangePosition(rc,POS_FACEDOWN)
		Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,0)
	end
end
--
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if not ac:IsControler(tp) then ac,bc=bc,ac end
	--if ac:IsType(TYPE_LINK) or bc:IsType(TYPE_LINK) then return false end
	local lv1,lv2=ac:GetLevel()|ac:GetRank()|ac:GetLink(),bc:GetLevel()|bc:GetRank()|bc:GetLink()
	if lv1==lv2 then return false end
	local ld=math.abs(lv1-lv2)  
	e:SetLabelObject(ac)
	e:SetLabel(ld)  
	return ac:IsFaceup() and ac:IsControler(tp) and ac:IsAttribute(ATTRIBUTE_LIGHT) and (ac:IsLevelAbove(1) or ac:IsRankAbove(1)) and bc:IsControler(1-tp) and (bc:IsLevelAbove(1) or bc:IsRankAbove(1))
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(e:GetLabel()*100)
		tc:RegisterEffect(e1)
	end
end
--03
function s.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsLevelAbove(1) and c:IsFaceup()
end
function s.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x3224) 
end
function s.cfilter3(c)
	return c:IsLevelBelow(3)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.cfilter,1,nil,tp) end
	local g=eg:Filter(s.cfilter,nil,tp)
	Duel.SetTargetCard(g)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local down=not (g:IsExists(s.cfilter3,1,nil))
	local op=aux.SelectFromOptions(tp,{true,aux.Stringid(id,2),2},{down,aux.Stringid(id,3),-2})
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(op)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end