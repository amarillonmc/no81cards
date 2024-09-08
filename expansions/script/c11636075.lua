--渊洋巨兽 “歌者”
local m=11636075
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSynchroMixProcedure(c,aux.Tuner(Card.IsSetCard,0x223),nil,nil,cm.mfilter,1,99,cm.syncheck(c))
	c:EnableReviveLimit() 
	--额外卡组0x9223怪兽效果重复适用用标记
	--Duel.IsPlayerAffectedByEffect(tp,11636065)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(11636065)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.tktg)
	e2:SetOperation(cm.tkop)
	c:RegisterEffect(e2) 
end
--
function cm.mfilter(c,syncard)
	return c:IsSetCard(0x223)
end
function cm.cfilter(c,syncard)
	return  c:IsSynchroType(TYPE_SYNCHRO)
end
function cm.syncheck(syncard)
	return  function(g)
				return g:IsExists(cm.cfilter,1,nil,syncard)
			end
end
--
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0  end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>0 then 
		local count=1
		local at=1
		while count>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 do
			local token=Duel.CreateToken(tp,11636076)
			Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_LEAVE_FIELD)
			e2:SetOperation(cm.damop)
			token:RegisterEffect(e2,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			token:RegisterEffect(e1,true)
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(m,2))
			e3:SetCategory(CATEGORY_DESTROY)
			e3:SetType(EFFECT_TYPE_QUICK_O)
			e3:SetCode(EVENT_FREE_CHAIN)
			e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
			e3:SetRange(LOCATION_SZONE)
			e3:SetCondition(cm.descon)
			e3:SetCost(cm.descost)
			e3:SetTarget(cm.destg)
			e3:SetOperation(cm.desop)
			token:RegisterEffect(e3)
			if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then
				count=0
			end
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and at==1 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				at=at-1
			else
				count=0
			end
		end 
	end
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) then
		local p=c:GetPreviousControler()
		Duel.Damage(1-p,800,REASON_EFFECT)
	end
	e:Reset()
end
--
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--